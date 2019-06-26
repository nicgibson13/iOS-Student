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
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        let urlParameters = ["orderBy": "\"timestamp\"","endAt":"\(queryEndInterval)","limitToLast":"15",]
        let queryItems = urlParameters.compactMap({URLQueryItem(name: $0.key, value: $0.value)})
        guard let baseURL = baseURL else { completion(); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let newURL = urlComponents?.url else {completion();return}
        let getterEndpoint = newURL.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { print(error.localizedDescription)
                completion()
                return
            } else {
                guard let data = data else {
                    completion(); return}
                do {
                    let jDecoder = JSONDecoder()
                    let postsDictionary = try jDecoder.decode([String:Post].self, from: data)
                    let posts: [Post] = postsDictionary.compactMap({ $0.value })
                    let sortedPosts = posts.sorted(by: {$0.timestamp>$1.timestamp})
                    if reset {
                        self.posts = sortedPosts
                    } else {
                        self.posts.append(contentsOf: sortedPosts)
                    }
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
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> ()) {
        let newPost = Post(text: text, username: username)
        var postData: Data
        guard let myURL = URL(string: "https:devmtn-posts.firebaseio.com/posts.json") else {return}
        let endPoint = myURL.appendingPathExtension("json")
        var urlRequest = URLRequest(url: endPoint)
        
        do {
            let postEncoder = JSONEncoder()
            postData = try postEncoder.encode(newPost)
            print(endPoint.absoluteURL)
            urlRequest.httpBody = postData
            urlRequest.httpMethod = "POST"
        } catch {
            print("Error encoding post")
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error
            {print(error.localizedDescription)
                completion()}
            guard let data = data,
                let dataString = String(data: data, encoding: .utf8) else {
                    print("Data is not retrievable.")
                    completion()
                    return
                    
            }
                self.fetchPosts {
                    completion()
                }
            }
        dataTask.resume()
    }
}



