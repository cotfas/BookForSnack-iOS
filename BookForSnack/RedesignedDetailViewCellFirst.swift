//
//  RedesignedDetailViewCellFirst.swift
//  BookForSnack
//
//  Created by WORK on 16/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

class RedesignedDetailViewCellFirst : UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            // Changing numberOfLines to 0 will resize the label based on the content
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet var imageViewIcon: UIImageView!
    
}
