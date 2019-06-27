//
//  StateListTableViewController.swift
//  Representative
//
//  Created by Nic Gibson on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {
    
    var states: [States] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return States.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        let state = States.all[indexPath.row]
        cell.textLabel?.text = state
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
