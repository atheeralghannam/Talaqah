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
        if segue.identifier == "fromWordsToTrials" {
            let destnationVC = segue.destination as! TrialController
            if adj{
                destnationVC.categories = ["adj"]
                destnationVC.document = "adjectives"
            } else{
                destnationVC.categories = ["male"]
                destnationVC.document = "verbs"
            }
        }
    }
}
