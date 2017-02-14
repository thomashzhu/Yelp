//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    
    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let navigationBar = navigationController?.navigationBar {
            if let searchBarView = Bundle.main.loadNibNamed("SearchBarView", owner: nil, options: nil)?.first as? SearchBarView {
                searchBar = searchBarView.searchBar
                searchBar.delegate = self
                
                searchBarView.frame = navigationBar.bounds
                navigationBar.addSubview(searchBarView)
            }
        }
        
        searchWith(term: "Restaurants")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                searchWith(term: text)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell {
            
            let business = businesses[indexPath.row]
            cell.business = business
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        return 0
    }
    
    private func searchWith(term: String) {
        Business.searchWithTerm(term: term, sort: .distance, categories: nil, deals: true) { (businesses, error) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
