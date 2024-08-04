//
//  RedesignedDetailViewCell.swift
//  BookForSnack
//
//  Created by WORK on 16/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

class RedesignedDetailViewHeader : UIView {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            // Changing numberOfLines to 0 will resize the label based on the content
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subTitleLabel: UILabel! {
        didSet {
            // Enabling rounded corners
            subTitleLabel.layer.cornerRadius = 5
            subTitleLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet var imageViewFull: UIImageView!
    @IBOutlet var imageViewHeart: UIImageView! {
        didSet {
            // Changing the image tint color to white
            imageViewHeart.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate) // loading image as a template
            imageViewHeart.tintColor = .white
        }
    }
}
