//
//  SelectCategoriesController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 21/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SelectCategoriesController: UIViewController {
    var categories = [String]()
    let db = Firestore.firestore()
    var isSelect = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func selectedCategories(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            if let removedCategoryIndex = categories.firstIndex(of: sender.currentTitle!){
                categories.remove(at: removedCategoryIndex)
            }
            if categories.count == 0 {
                isSelect = false
            }
        } else {
            sender.isSelected = true
            categories.append(sender.titleLabel!.text!)
            isSelect = true
        }
    }
    @IBAction func goToTrial(_ sender: UIButton) {
        if isSelect {
            self.performSegue(withIdentifier: "fromCatiegoriesToTrial", sender: self)
        }
        else {
            let alertController = UIAlertController(title: "لم تقم بإختيار التصنيفات", message:
                "يجب عليك اختيار واحدة على الأقل", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func back(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWords", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCatiegoriesToTrial" {
            let destnationVC = segue.destination as! TrialController
            destnationVC.categories = categories
            destnationVC.document = "names"
        }
    }
}
