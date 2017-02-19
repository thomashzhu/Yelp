//
//  N.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

struct N {
    
    static let loadingText = "--"
    
    struct JSONKey {
        struct Business {
            struct CustomerReview {
                static let userInfo = "user"
                static let userName = "name"
                static let rating = "rating"
                static let reviewText = "excerpt"
                static let reviews = "reviews"
            }
        }
    }
}
