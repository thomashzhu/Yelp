//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    private(set) var businesses = [Business]()
    
    private(set) var searchBar: UISearchBar!
    private(set) var mapButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var isMoreDataLoading = false
    private(set) var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let navigationBar = navigationController?.navigationBar {
            if let searchBarView = Bundle.main.loadNibNamed("SearchBarView", owner: nil, options: nil)?.first as? SearchBarView {
                
                searchBar = searchBarView.searchBar
                searchBar.delegate = self
                
                mapButton = searchBarView.mapButton
                mapButton.addTarget(self,
                                    action: #selector(BusinessesViewController.mapButtonTapped), for: .touchUpInside)
                
                searchBarView.frame = navigationBar.bounds
                navigationBar.addSubview(searchBarView)
            }
        }
        
        searchWith(term: "Restaurants")
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
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
        return businesses.count
    }
    
    private func searchWith(term: String) {
        Business.searchWithTerm(term: term, sort: .distance, categories: nil, deals: true) { (businesses, error) in
            if let businesses = businesses {
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                self.businesses.append(contentsOf: businesses)
                self.tableView.reloadData()
            }
        }
    }
    
    func mapButtonTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "BusinessesMapViewController") as? BusinessesMapViewController {
            vc.businesses = businesses
            present(vc, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                searchWith(term: searchBar.text ?? "Restaurants")
            }
        }
    }
}
