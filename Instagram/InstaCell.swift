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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideUser() {
        cellStackView.arrangedSubviews[0].isHidden = true
    }
}
