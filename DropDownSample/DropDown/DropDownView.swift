//
//  DropDownView.swift
//  DropDownSample
//
//  Created by Alex Logan on 09/08/2018.
//  Copyright © 2018 Alex Logan. All rights reserved.
//

import Foundation
import UIKit

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var options = [String]() {
        didSet {
            filteredOptions = options
            tableView.reloadData()
        }
    }
    
    var filteredOptions = [String]()
    
    var tableView = UITableView()
    var delegate: DropDownDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = UIColor.white
        tableView.alpha = 1
        
        self.backgroundColor = UIColor.white
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.reuseIdentifier)
        
        // Make Table view match "rounded-ness" of its container
        tableView.layer.cornerRadius = self.layer.cornerRadius
        
        // Just to be explicit.
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        // Delegate to itself. Passes selection to own delegate.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.reuseIdentifier, for: indexPath) as! DropDownCell
        cell.label.text = filteredOptions[indexPath.item]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelectDropdown(item: filteredOptions[indexPath.item])
    }
    
}

