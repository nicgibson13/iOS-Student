//
//  Post.swift
//  Post
//
//  Created by Nic Gibson on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post {
    var text: String
    var timestamp: TimeInterval
    var username: String
    
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.username = username
    }
}
