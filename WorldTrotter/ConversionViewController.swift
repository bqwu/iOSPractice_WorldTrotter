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
        
//        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    func getCurrentHour24() -> Int{
        let date = Date()
        let dateFormatter = DateFormatter()   // thread safety
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let time = dateFormatter.string(from: date)
//        print(time)
        
        let endBound = String.Index(utf16Offset: 2, in: time)
        let hr = String(time[time.startIndex..<endBound])
        
        return Int(hr)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let curHour = getCurrentHour24()
        
        /* now fixed sunrise and sunset time is used.
         I think it should be obtained dynamically
         by calulating from lat & lon or from another
         app like weather. Leave it for improvement
         in the future. Or a better way is to use the
         brightness of system to change background
        */
        
        let sunrise = 5, sunset = 20
        if curHour >= sunset || curHour <= sunrise {
            view.backgroundColor = UIColor.black
        }
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
