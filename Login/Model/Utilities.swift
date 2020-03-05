//
//  Utilities.swift
//  Login
//
//  Created by Haneen Abdullah on 12/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
 
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
   
    
          static  let primaryColor=hexStringToUIColor(hex: "#F2A490")
    
//    let primaryColor = UIColor(rgb: 0xF2A490)
    static func styleTextField( textfield:UITextField) {
  
       
   // Create the bottom line
               let bottomLine = CALayer()
               
               bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
               
               bottomLine.backgroundColor = primaryColor.cgColor
               
               // Remove border on text field
               textfield.borderStyle = .none
               
               // Add the line to the text field
               textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton( button:UIButton) {
       
        // Filled rounded corner style
        button.backgroundColor = primaryColor
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton( button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleErrorLabel( label:UILabel) {
        label.font = UIFont(name: "UIFontWeightRegular", size: 12.0)
        label.textColor = UIColor.red
  
    }
    
      static func styleLabel( label:UILabel) {
          label.font = UIFont(name: "UIFontWeightRegular", size: 17.0)
          label.textColor = UIColor.black
    
      }
      static func styleSecondaryButton( button:UIButton) {
//          button. = UIFont(name: "UIFontWeightRegular", size: 17.0)
          button.tintColor = primaryColor
    
      }
    
        static func styleHeaderLabel( label:UILabel) {
            label.font = UIFont(name: "UIFontWeightRegular", size: 21)
                    label.textColor = UIColor.black
        }
    
    
//    static func isPasswordValid(_ password : String) -> Bool {
//
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
//    }
}
