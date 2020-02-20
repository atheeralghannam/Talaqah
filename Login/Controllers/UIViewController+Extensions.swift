//
//  UIViewController+Extensions.swift
//  Login
//
//  Created by Gary Tokman on 3/24/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit
private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

extension UIViewController {
    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
    
    func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
    }}
    
    extension UITextField {
        func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
            animation.fromValue = baseColor
            animation.toValue = UIColor.red.cgColor
            animation.duration = 0.4
            if revert { animation.autoreverses = true } else { animation.autoreverses = false }
            self.layer.add(animation, forKey: "")

            let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
            shake.duration = 0.07
            shake.repeatCount = shakes
            if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
            shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
            shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
            self.layer.add(shake, forKey: "position")
        }
    }


