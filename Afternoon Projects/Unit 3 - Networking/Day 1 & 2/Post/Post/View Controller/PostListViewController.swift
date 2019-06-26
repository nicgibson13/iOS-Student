//
//  PostListViewController.swift
//  Post
//
//  Created by Nic Gibson on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit


class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.postTableView.reloadData()
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    var refreshControl = UIRefreshControl()
    
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.reloadTableView()
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    var postController = PostController()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username + "\(post.timestamp)"
        
        return cell
    }
    
    func presentErrorAlertController () {
        
        let alertController = UIAlertController(title: "Missing information!!!!🍤🍤🍤🍤", message: "Please input message and username", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Return", style: .cancel))
        present(alertController, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        var usernameTextField: UITextField?
        var messageTextField: UITextField?
        let presentNewPostAlert = UIAlertController(title: "Create a new post⛈", message: nil, preferredStyle: .alert)
        presentNewPostAlert.addTextField { (textfield) in
            textfield.placeholder = "Add username..."
            usernameTextField = textfield }
        presentNewPostAlert.addTextField { (textfield) in
            textfield.placeholder = "Create message..."
            messageTextField = textfield }
        presentNewPostAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        presentNewPostAlert.addAction(UIAlertAction(title: "Post", style: .default, handler: { (_) in
            guard let username = usernameTextField?.text, !username.isEmpty,
                let message = messageTextField?.text, !message.isEmpty
                else {self.presentErrorAlertController(); return}
            self.postController.addNewPostWith(username: username, text: message, completion: self.reloadTableView)
        }))
        present(presentNewPostAlert, animated: true)
    }
    
    
    @IBOutlet weak var postTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTableView.estimatedRowHeight = 45
        self.postTableView.rowHeight = UITableView.automaticDimension
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        reloadTableView()
        postTableView.delegate = self
        postTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    
}

extension PostListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= postController.posts.count - 1 {
            postController.fetchPosts(reset: false) {
                self.reloadTableView()
            }
        }
    }
}
