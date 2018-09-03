//
//  ViewController.swift
//  HashAPIEgbertTest
//
//  Created by Egbert-Jan Terpstra on 18/08/2018.
//  Copyright © 2018 Egbert-Jan Terpstra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Global variables
    let HASH_URL = "https://www.egbertjanterpstra.nl/hash/api.php"
    var hashArray = [String]()
    var chosenHashValue : String = ""
    
    
    // MARK: - Outlets
    @IBOutlet weak var hashValueLabel: UILabel!
    @IBOutlet weak var hashTextField: UITextField!
    @IBOutlet weak var hashPicker: UIPickerView!
    
    
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(HASH_URL, method: .get, parameters: ["a" : ""]).responseJSON { response in
            if response.result.isSuccess {
                
                let result : JSON = JSON(response.result.value!)
                let array = result.array
                
                for item in array!{
                    self.hashArray.append(item.stringValue)
                }
                
                self.hashPicker.delegate = self
                self.hashPicker.dataSource = self
                
                self.chosenHashValue = self.hashArray[0]
                
            }
            else{
                print("error")
            }
        }
        
        hashValueLabel.adjustsFontSizeToFitWidth = true
        hashValueLabel.layer.masksToBounds = true
        hashValueLabel.layer.cornerRadius = 4
        
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        
        let deleteText = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.undo, target: nil, action: #selector(self.keyboardDeleteClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.keyboardDoneClicked) )
        
        keyboardToolBar.setItems([deleteText, flexibleSpace, doneButton], animated: true)
        
        hashTextField.inputAccessoryView = keyboardToolBar
    }
    
    @objc func keyboardDeleteClicked(){
        hashTextField.text = ""
    }
    
    @objc func keyboardDoneClicked(){
        hashValueLabel.text = "Loading..."
        getHashData(url: HASH_URL, parameters: ["q" : hashTextField.text!, "h" : chosenHashValue])
        view.endEditing(true)
    }

    
    // MARK: - UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hashArray.count
    }
    
    
    
    // MARK: - UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hashArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenHashValue = hashArray[row]
    }
    
    

    //  MARK: - Self made methods
    func getHashData(url: String, parameters: [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            
            response in
            if response.result.isSuccess{
                let hashData : JSON = JSON(response.result.value!)
                
                self.hashValueLabel.text = hashData["value"].stringValue
            }
            else{
                print("fout")
            }
            
        }
    }

    
    
    // MARK: - IBAction methods
    @IBAction func hashButtonPressed(_ sender: Any) {
        hashValueLabel.text = "Loading..."
        getHashData(url: HASH_URL, parameters: ["q" : hashTextField.text!, "h" : chosenHashValue])
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = hashValueLabel.text
    }

    
}

