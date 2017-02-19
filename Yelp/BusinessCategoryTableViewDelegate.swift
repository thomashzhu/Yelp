//
//  BusinessCategoryTableViewDelegate.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessFilterTableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Context
    
    private let vc: BusinessFilterViewController
    
    // MARK: Initializer
    
    init(vc: BusinessFilterViewController) {
        self.vc = vc
    }
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.Identifier.TableCell.categoryCell, for: indexPath)
        cell.textLabel?.text = vc.categories[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        if vc.selectedCategories.contains(vc.categories[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vc.categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            vc.selectedCategories.append(text)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let text = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            if let index = vc.selectedCategories.index(of: text) {
                vc.selectedCategories.remove(at: index)
            }
        }
    }

}
