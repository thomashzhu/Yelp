//
//  IdentifiableAnnotation.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import MapKit

class IdentifiableAnnotation: NSObject, MKAnnotation {

    let identifier : String?
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(identifier: String?, title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D)
    {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
