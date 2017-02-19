//
//  BusinessFilterViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property declarations
    
    var categories: [String]!
    var selectedCategories: [String] = []
    
    var callback: (([String]) -> Void)!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let delegate = self
        tableView.dataSource = delegate
        tableView.delegate = delegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback(selectedCategories)
    }
    
    // MARK: - Dele
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Identifier.TableCell.categoryCell, for: indexPath)
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
