//
//  RepresentativeController.swift
//  Representative
//
//  Created by Nic Gibson on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepresentativeController {
    static let baseURL = URL(string: "https://whoismyrepresentative.com/getall_reps_bystate.php")
    
    static func fetchReps(forState state: String, completion: @escaping (([Representative]?) -> Void )) {
        guard let url = baseURL else {completion([]);return}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "state", value: state.lowercased())
        let jsonQuery = URLQueryItem(name: "output", value: "json")
        components?.queryItems = [searchQuery, jsonQuery]
        guard let finalURL = components?.url else { completion([]);return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("There's an error afoot! \(error.localizedDescription)")
                completion([]);return
            }
            
            guard let data = data,
            let dataAsASCII = String(data: data, encoding: .ascii),
            let dataAsUTF8 = dataAsASCII.data(using: .utf8)
                else { completion([]); return }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([String: [Representative]].self, from: dataAsUTF8)
                let reps = decodedData["results"]
                completion(reps)
            } catch {
                print(error.localizedDescription)
            }
        } .resume()
    }
}
