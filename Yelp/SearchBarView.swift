//
//  SearchBarView.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/13/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SearchBarView: UIView {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        filterButton.layer.borderColor = UIColor.white.cgColor
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 6.0
        filterButton.clipsToBounds = true
        
        searchBar.backgroundColor = F.Theme.Color.red
        searchBar.backgroundImage = UIImage()
        
        mapButton.layer.borderColor = UIColor.white.cgColor
        mapButton.layer.borderWidth = 1.0
        mapButton.layer.cornerRadius = 6.0
        mapButton.clipsToBounds = true
    }
}
