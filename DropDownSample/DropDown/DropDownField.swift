//
//  DropDownField.swift
//  DropDownSample
//
//  Created by Alex Logan on 08/08/2018.
//  Copyright © 2018 Alex Logan. All rights reserved.
//

import Foundation
import UIKit

protocol DropDownDelegate {
    func didSelectDropdown(item: String)
}

class DropDownField : UIView {
    
    var options = [String]()
    var filteredOptions = [String]()
    var isOpen = false
    var tableViewHeightConstraint : NSLayoutConstraint!
    var dropDownView = DropDownView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    var field: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        // Setup basic UI.
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "DropDown"
        title.textColor = .gray
        
        field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Please Select"
        field.textColor = .black
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        field.returnKeyType = .done

        let downArrow = UIImageView(image: #imageLiteral(resourceName: "down"))
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(downArrow)
        
        self.addSubview(field)
        self.addSubview(title)
        
        tableViewHeightConstraint = dropDownView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: field, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 24.6),
            NSLayoutConstraint(item: field, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: field, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: title, attribute: .trailing, relatedBy: .equal, toItem: field, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal, toItem: field, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: title, attribute: .bottom, relatedBy: .equal, toItem: field, attribute: .top, multiplier: 1, constant: 1),
            NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 17),
           NSLayoutConstraint(item: downArrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24),
           NSLayoutConstraint(item: downArrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24),
           NSLayoutConstraint(item: downArrow, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -24),
           NSLayoutConstraint(item: downArrow, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
           ])
        
        dropDownView.options = ["cool", "dropdown", "lol", "hello", "i'm out of stuff", "giraffes", "halloumi"]
        dropDownView.filteredOptions = dropDownView.options
        dropDownView.delegate = self
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.tableView.reloadData()
        
    
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        self.superview!.addSubview(dropDownView)
        self.superview!.bringSubview(toFront: dropDownView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: dropDownView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -self.layer.cornerRadius),
            NSLayoutConstraint(item: dropDownView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dropDownView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
        ])
        
        layoutIfNeeded()
        dropDownView.layoutIfNeeded()
    }
    
}

extension DropDownField: DropDownDelegate {
    // Function to be implemented by the end user.
    func didSelectDropdown(item: String) {
        field.text = item
    }
}

extension DropDownField: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        guard let text = textField.text, text != "" else {
            dropDownView.filteredOptions = dropDownView.options
            self.dropDownView.tableView.reloadData()
            return
        }
        
        self.dropDownView.filteredOptions = self.dropDownView.options.filter({ (item) -> Bool in
            return item.lowercased().contains(text.lowercased())
        })
        
        
        self.dropDownView.tableView.reloadData()
    }
    
    // Not delegate methods, but close enough.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        NSLayoutConstraint.deactivate([self.tableViewHeightConstraint])
        if self.dropDownView.tableView.contentSize.height > 150 {
            self.tableViewHeightConstraint.constant = 150
        } else {
            self.tableViewHeightConstraint.constant = self.dropDownView.tableView.contentSize.height
        }
        
        NSLayoutConstraint.activate([self.tableViewHeightConstraint])
        
        
        UIView.animate(withDuration: 0.4) {
            self.dropDownView.layoutIfNeeded()
            // This stops the view growing middle out. I do not know why.
            self.dropDownView.center.y += self.dropDownView.frame.height / 2
            self.dropDownView.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        NSLayoutConstraint.deactivate([self.tableViewHeightConstraint])
        self.tableViewHeightConstraint.constant = 0
        NSLayoutConstraint.activate([self.tableViewHeightConstraint])
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            // Same again.
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.alpha = 0
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
        
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
