//
//  SelsectWordsController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 21/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase

class SelsectWordsController: UIViewController {
    var adj = false
    let db = Firestore.firestore()

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
    
    @IBAction func wordButtonPressed(_ sender: UIButton) {
        if sender.currentTitle! == "الصفات"{
            adj = true
            self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
        }
        else if sender.currentTitle! == "الأفعال"{
            adj = false
            self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
        }else if sender.currentTitle! == "الاسماء"{
            self.performSegue(withIdentifier: "fromWtoC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         var docRef = db.collection("trials").document("names")
         if segue.identifier == "fromWordsToTrials" {
            if adj{
                 docRef = db.collection("trials").document("adjectives")
            } else{
                docRef = db.collection("trials").document("verbs")
            }
             let destnationVC = segue.destination as! TrialController
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
