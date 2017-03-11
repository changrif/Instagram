//
//  InstaCell.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/20/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class InstaCell: UITableViewCell {
    
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postLabel.sizeToFit()
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showUser(exists: Bool) {
        if exists   {
        cellStackView.arrangedSubviews[0].isHidden = false
        }   else    {
        cellStackView.arrangedSubviews[0].isHidden = true
        }
    }
}
