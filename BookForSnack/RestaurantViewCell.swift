//
//  RestaurantTableViewCell.swift
//  BookForSnack
//
//  Created by WORK on 5/7/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class RestaurantViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var imageViewThumb: UIImageView! {
        
        // Another method by code with didSet to change the corner radius beside the storyboard user defined runtime attribute
        didSet {
            imageViewThumb.layer.cornerRadius = imageViewThumb.bounds.width / 2
            imageViewThumb.clipsToBounds = true
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
