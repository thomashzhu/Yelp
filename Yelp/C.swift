//
//  C.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

struct C {
    
    private init() {}
    
    struct Identifier {
        
        struct Segue {
            static let businessDetailVC = "BusinessDetailViewController"
            static let businessFilterVC = "BusinessFilterViewController"
            static let businessMapVC = "BusinessMapViewController"
        }
        
        struct Storyboard {
            static let searchBarView = "SearchBarView"
        }
        
        struct TableCell {
            static let businessCell = "BusinessCell"
            static let categoryCell = "CategoryCell"
        }
    }
}
