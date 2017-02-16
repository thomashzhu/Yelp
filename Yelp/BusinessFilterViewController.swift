//
//  BusinessFilterViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categories: [String]!
    var selectedCategories: [String] = []
    
    var callback: (([String]) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback(selectedCategories)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        if selectedCategories.contains(categories[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            selectedCategories.append(text)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            if let index = selectedCategories.index(of: text) {
                selectedCategories.remove(at: index)
            }
        }
    }
}
