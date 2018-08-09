//
//  ViewController.swift
//  DropDownSample
//
//  Created by Alex Logan on 08/08/2018.
//  Copyright © 2018 Alex Logan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 238/255, green: 154/255, blue: 25/255, alpha: 1.0)
        // Do any additional setup after loading the view, typically from a nib.
        let dropDown = DropDownField()
        dropDown.backgroundColor = .white
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dropDown)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: dropDown, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: dropDown, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: dropDown, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        ])
        
        dropDown.layer.cornerRadius = 4
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
