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
    var trials = [Trial]()
    var array = [Trial]()

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
        print(trials)
        if segue.identifier == "fromWordsToTrials" {
            let destnationVC = segue.destination as! TrialController
            if adj{
                for trial in trials{
                    if trial.category == "adj"{
                        array.append(trial)
                    }
                }
                destnationVC.trials = array
            } else{
                for trial in trials{
                    if trial.category == "male" {
                        array.append(trial)
                    }
                }
                destnationVC.trials = array
            }
        }
        if segue.identifier == "fromWtoC"{
            let destnationVC = segue.destination as! SelectCategoriesController
            destnationVC.trials = trials
        }
    }
}
