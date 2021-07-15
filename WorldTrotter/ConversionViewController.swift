//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Baoqiang Wu on 7/13/21.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    
    var fahrenHeitValues: Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValues: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenHeitValues {
            return fahrenheitValue.converted(to: UnitTemperature.celsius)
        }
        else{
            return nil
        }
    }
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenHeitFieldEditingChanged(_ textField: UITextField) {
//        celsiusLabel.text = textField.text
//        if let text = textField.text, !text.isEmpty{
//            celsiusLabel.text = text
//        }
//        else {
//            celsiusLabel.text = "???"
//        }
        if let text = textField.text, let value = Double(text) {
            fahrenHeitValues = Measurement(value: value, unit: UnitTemperature.fahrenheit)
        }
        else {
            fahrenHeitValues = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel(){
        if let celsiusValues = celsiusValues {
//            celsiusLabel.text = "\(celsiusValues.value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValues.value))
        }
        else{
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCelsiusLabel()
    }
    
    // 闭包
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("Curent text: \(textField.text)")
//        print("Replacement text: \(string)")
//        return true
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        // all illegal characters not allowed (added by bqwu)
        var legalSet = CharacterSet.decimalDigits
        legalSet.insert(charactersIn: ".")
        let illegalSet = legalSet.inverted
        
        let existingTextHasLetter = textField.text?.rangeOfCharacter(from: illegalSet)
        
        let replacementTextHasLetter = string.rangeOfCharacter(from: illegalSet)
        
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        }
        else if existingTextHasLetter != nil || replacementTextHasLetter != nil {
            return false
        }
        else {
            return true
        }
    }
}
