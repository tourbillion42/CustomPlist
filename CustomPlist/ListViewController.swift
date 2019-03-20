//
//  ListViewController.swift
//  CustomPlist
//
//  Created by Hwang on 11/12/2018.
//  Copyright © 2018 Hwang. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var account: UITextField!
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    
    var accountList = [String]()
    var defaultPlist : NSDictionary!
  
    override func viewDidLoad() {
        
        if let defaultPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: defaultPlistPath)
        }
        
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        
        let val = sender.selectedSegmentIndex
        let customPlist = "\(self.account.text!).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(val, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch ) {
        
        let val = sender.isOn
        let customPlist = "\(self.account.text!).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
        
        data.setValue(val, forKey: "married")
        data.write(toFile: plist, atomically: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 && (self.account.text?.isEmpty)! == false {
            
            let alert = UIAlertController(title: nil, message: "put your name", preferredStyle: .alert)
            
            alert.addTextField() {
                $0.text = self.name.text
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
                
                let val = alert.textFields?[0].text
                let customPlist = "\(self.account.text!).plist"
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)
                
                data.setValue(val, forKey: "name")
                data.write(toFile: plist, atomically: true)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func pickDone(_ sender : Any) {
        self.view.endEditing(true)
        
        if let _account = self.account.text {
            
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 00
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    @objc func newAccount(_ sender : Any) {
        self.view.endEditing(true)
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let val = self.accountList[row]
        self.account.text = val
        
        let plist = UserDefaults.standard
        plist.set(val, forKey: "selectedAccount")
        plist.synchronize()
    }
}

