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
        let docRef = db.collection("trials").document("names")
        if segue.identifier == "fromCatiegoriesToTrial" {
            let destnationVC = segue.destination as! TrialController
//            for category in categories {
                let doc = docRef.collection("animal")
                doc.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
                }
//            }
            docRef.getDocument { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        var array = [Trial]()
                        if let data = snapshot.data() {
                            print(data)
//                            array.append(Trial(ID: data["ID"] as! String, answer: data["Answer"] as! String, image: data["Image"] as! String, exerciseType: data["ExerciseType"] as! String, category: data["Category"] as! String, trailClass: data["Class"] as! String, cues: data["Cues"] as! Array<String>))
                        }
                        destnationVC.trials = array
                    }
                }
            }
            
        }
    }
}
