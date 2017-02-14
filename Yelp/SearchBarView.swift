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
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        filterButton.layer.borderColor = UIColor.white.cgColor
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 6.0
        filterButton.clipsToBounds = true
        
        searchBar.backgroundColor = F.Theme.Color.red
        searchBar.backgroundImage = UIImage()
    }
    
    func getSearchBar() -> UISearchBar {
        return searchBar
    }
}
