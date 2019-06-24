//
//  PostController.swift
//  Post
//
//  Created by Nic Gibson on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation


class PostController {
    static let sharedInstance = PostController()
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    var posts: [Post] = []
    func fetchPosts(completion: @escaping () -> ()) {
        guard let baseURL = baseURL else { completion(); return}
        let getterEndpoint = baseURL.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { print(error)
                completion()
                return
            } else {
                guard let data = data else { completion(); return}
                do {
                    let jDecoder = JSONDecoder()
                    let postsDictionary = try jDecoder.decode([String:Post].self, from: data)
                    var posts = postsDictionary.compactMap({ $0.value })
                    posts.sort(by: {$0.timestamp>$1.timestamp})
                    self.posts = posts
                    completion()
                } catch {
                    print(error.localizedDescription)
                    completion()
                    return
                }
            }
        }
        dataTask.resume()
    }
}

