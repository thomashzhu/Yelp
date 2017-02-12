//
//  BusinessCell.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/11/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            thumbImageView.setImageWith(business.imageURL!)
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            ratingImageView.setImageWith(business.ratingImageURL!)
            reviewsCountLabel.text = "\(business.reviewCount)"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        thumbImageView.layer.cornerRadius = 3.0
        thumbImageView.clipsToBounds = true
    }
}
// Assignment Quickstart Video: Yelp Basic Setup
