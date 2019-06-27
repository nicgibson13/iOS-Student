//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Nic Gibson on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
    
    var state: String?
    
    var reps: [Representative] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let state = state {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            RepresentativeController.fetchReps(forState: state) { (reps) in
                guard let reps = reps else { return }
                self.reps = reps
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as? StateListTableViewCell else { return UITableViewCell()}
        cell.rep = reps[indexPath.row]
        return cell
    }
}
