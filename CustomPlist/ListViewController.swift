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
        
        let picker = UIPickerView()
        picker.delegate = self
        self.account.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = UIColor.lightGray
        self.account.inputAccessoryView = toolbar
        
        let done = UIBarButtonItem()
        done.title = "DONE"
        done.target = self
        done.action = #selector(pickDone(_:))
        
        let flewSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: noErr, action: nil)
        
        let new = UIBarButtonItem()
        new.title = "NEW"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        toolbar.setItems([new, flewSpace, done], animated: true)
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn]
        
        let plist = UserDefaults.standard
        
        self.name.text = plist.string(forKey: "name")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        self.married.isOn = plist.bool(forKey: "married")
        
        let accountlist = plist.array(forKey: "accountList") as? [String] ?? [String]()
        self.accountList = accountlist
        
        if let val = plist.string(forKey: "selectedAccount") {
            self.account.text = val
            
            let customPlist = "\(val).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 00
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다"
            self.gender.isEnabled = false
            self.married.isEnabled = false
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
                
                self.name.text = val 
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
        
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        
        alert.addTextField() {
            $0.placeholder = "abc@gmail.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) {(_) in
            
            if let val = alert.textFields?[0].text {
                
                self.accountList.append(val)
                self.account.text = val
                
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                let plist = UserDefaults.standard
                plist.set(self.accountList, forKey: "accountList")
                plist.set(val, forKey: "selectedAccount")
                plist.synchronize()
                
            }
        })
        self.present(alert, animated: true, completion: nil)
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

