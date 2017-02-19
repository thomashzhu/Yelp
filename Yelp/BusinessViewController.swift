//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

import EZLoadingActivity

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties declarations
    
    private(set) var businesses = [Business]()
    private(set) var allBusinesses = [Business]()
    
    private(set) var categories = [String]()
    private(set) var selectedCategories = [String]()
    
    private(set) var filterButton: UIButton!
    private(set) var searchBar: UISearchBar!
    private(set) var mapButton: UIButton!
    
    private(set) var manager = CLLocationManager()
    private(set) var userLocation: CLLocation!
    
    private(set) var isMoreDataLoading = false
    private(set) var loadingMoreView: InfiniteScrollActivityView?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let navigationBar = navigationController?.navigationBar {
            
            navigationBar.tintColor = UIColor.white
            
            if let searchBarView = Bundle.main.loadNibNamed(C.Identifier.Storyboard.searchBarView, owner: nil, options: nil)?.first as? SearchBarView {
                
                filterButton = searchBarView.filterButton
                filterButton.addTarget(self, action: #selector(BusinessViewController.filterButtonTapped), for: .touchUpInside)
                
                searchBar = searchBarView.searchBar
                searchBar.delegate = self
                
                mapButton = searchBarView.mapButton
                mapButton.addTarget(self,
                                    action: #selector(BusinessViewController.mapButtonTapped), for: .touchUpInside)
                
                searchBarView.frame = navigationBar.bounds
                searchBarView.tag = 1
                navigationBar.addSubview(searchBarView)
            }
        }
        
        manager.delegate = self
        manager.distanceFilter = 100.0
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
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
        
        if !selectedCategories.isEmpty {
            businesses = allBusinesses.filter { business in
                if let categories = business.categories {
                    let categoryArray = categories.components(separatedBy: ", ")
                    for category in categoryArray {
                        if selectedCategories.contains(category) {
                            return true
                        }
                    }
                }
                return false
            }
        } else {
            businesses = allBusinesses
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.viewWithTag(1)?.isHidden = true
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            
            if let searchBarText = searchBar.text {
                searchWith(term: searchBarText.isEmpty ? "Restaurants" : searchBarText, newSearch: true)
            }
        }
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if !text.isEmpty {
                searchWith(term: text, newSearch: true)
            }
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: C.Identifier.TableCell.businessCell, for: indexPath) as? BusinessCell {
            
            let business = businesses[indexPath.row]
            cell.business = business
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    // MARK: - UIScrollViewDelegate methods
    
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
                searchWith(term: searchBar.text!.isEmpty ? "Restaurants" : searchBar.text!, newSearch: false)
            }
        }
    }
    
    // MARK: - Navigation bar actions
    
    func filterButtonTapped() {
        if !businesses.isEmpty {
            performSegue(withIdentifier: C.Identifier.Segue.businessFilterVC, sender: nil)
        }
    }
    
    func mapButtonTapped() {
        if !businesses.isEmpty {
            performSegue(withIdentifier: C.Identifier.Segue.businessMapVC, sender: nil)
        }
    }
    
    // MARK: - Helper methods
    
    private func searchWith(term: String, newSearch: Bool) {
        
        let locationString: String? = {
            if let userLocation = userLocation {
                return "\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"
            } else {
                return nil
            }
        }()
        
        if navigationController?.topViewController == self {
            EZLoadingActivity.show("Loading...", disableUI: true)
        } else {
            print("Location change detected. Refreshing data in the back...")
        }
        
        Business.searchWithTerm(term: term, location: locationString, sort: .distance, categories: nil, deals: true) { (businesses, error) in
            if let businesses = businesses {
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                if newSearch {
                    self.allBusinesses = businesses
                } else {
                    self.allBusinesses.append(contentsOf: businesses)
                }
                self.businesses = self.allBusinesses
                
                self.categories = businesses.reduce([]) { (allCategories, business) -> [String] in
                    if let categories = business.categories {
                        if !categories.isEmpty {
                            let categoryArray = categories.components(separatedBy: ", ")
                            return categoryArray.reduce(allCategories) { (businessCategories, category) -> [String] in
                                return allCategories.contains(category) ? businessCategories : businessCategories + [category]
                            }
                        }
                    }
                    return allCategories
                }
                self.categories.sort()
                
                self.tableView.reloadData()
                
                EZLoadingActivity.hide()
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case C.Identifier.Segue.businessDetailVC:
                if let vc = segue.destination as? BusinessDetailViewController {
                    if let selectedCell = sender as? UITableViewCell {
                        if let indexPath = tableView.indexPath(for: selectedCell) {
                            vc.business = businesses[indexPath.row]
                        }
                    }
                }
            case C.Identifier.Segue.businessFilterVC:
                if let vc = segue.destination as? BusinessFilterViewController {
                    vc.categories = categories
                    vc.selectedCategories = selectedCategories
                    
                    vc.callback = { selectedCategories in
                        self.selectedCategories = selectedCategories
                    }
                }
            case C.Identifier.Segue.businessMapVC:
                if let vc = segue.destination as? BusinessMapViewController {
                    vc.businesses = businesses
                }
            default:
                break;
            }
        }
    }
}
