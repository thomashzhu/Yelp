//
//  BusinessFilterViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessFilterViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property declarations
    
    var categories: [String]!
    var selectedCategories: [String] = []
    
    var callback: (([String]) -> Void)!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = BusinessFilterTableViewDelegate(vc: self)
        tableView.dataSource = delegate
        tableView.delegate = delegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback(selectedCategories)
    }
}
