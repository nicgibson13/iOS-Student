//
//  StateListTableViewCell.swift
//  Representative
//
//  Created by Nic Gibson on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewCell: UITableViewCell {

    var rep: Representative? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    func updateViews() {
        guard let rep = rep else {return}
        self.nameLabel.text = rep.name
        self.partyLabel.text = rep.party
        self.districtLabel.text = rep.district
        self.websiteLabel.text = rep.link
        self.phoneNumberLabel.text = rep.phone
    }
}
