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
    
    private(set) var filterButton: UIButton!
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
            
            navigationBar.tintColor = UIColor.white
            
            if let searchBarView = Bundle.main.loadNibNamed("SearchBarView", owner: nil, options: nil)?.first as? SearchBarView {
                
                filterButton = searchBarView.filterButton
                filterButton.addTarget(self, action: #selector(BusinessesViewController.filterButtonTapped), for: .touchUpInside)
                
                searchBar = searchBarView.searchBar
                searchBar.delegate = self
                
                mapButton = searchBarView.mapButton
                mapButton.addTarget(self,
                                    action: #selector(BusinessesViewController.mapButtonTapped), for: .touchUpInside)
                
                searchBarView.frame = navigationBar.bounds
                searchBarView.tag = 1
                navigationBar.addSubview(searchBarView)
            }
        }
        
        searchWith(term: "Restaurants", newSearch: true)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.viewWithTag(1)?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.viewWithTag(1)?.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                searchWith(term: text, newSearch: true)
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
    
    func filterButtonTapped() {
        let message = "Yelp API only give us very limited number of results, are you sure you want to further filter down the result?" + "\n\n" + "Just kidding, this function is just still under construction. Please come back later."
        let ac = UIAlertController(title: "Filter", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    private func searchWith(term: String, newSearch: Bool) {
        Business.searchWithTerm(term: term, sort: .distance, categories: nil, deals: true) { (businesses, error) in
            if let businesses = businesses {
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                if newSearch {
                    self.businesses = businesses
                } else {
                    self.businesses.append(contentsOf: businesses)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func mapButtonTapped() {
        performSegue(withIdentifier: "BusinessesMapViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BusinessDetailViewController" {
            if let vc = segue.destination as? BusinessDetailViewController {
                if let selectedCell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: selectedCell) {
                        vc.business = businesses[indexPath.row]
                    }
                }
            }
        } else if segue.identifier == "BusinessesMapViewController" {
            if let vc = segue.destination as? BusinessesMapViewController {
                vc.businesses = businesses
            }
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
                searchWith(term: searchBar.text ?? "Restaurants", newSearch: false)
            }
        }
    }
}
