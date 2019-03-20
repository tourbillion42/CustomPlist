//
//  ListViewController.swift
//  CustomPlist
//
//  Created by Hwang on 11/12/2018.
//  Copyright © 2018 Hwang. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {

    @IBOutlet var account: UITextField!
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
  
    override func viewDidLoad() {
        
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func changeMarried(_ sender: UISwitch ) {
     
    }
}

