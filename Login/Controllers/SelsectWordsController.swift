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
    @IBOutlet weak var NamesButton: UIButton!
    @IBOutlet weak var VerbsButton: UIButton!
    @IBOutlet weak var AdjButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let tal = UIColor(named: "Tala")
               let gradientLayer = CAGradientLayer()
               gradientLayer.frame = self.view.bounds
               gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
               self.view.layer.insertSublayer(gradientLayer, at: 0)
        setUpButtons()
    }
    override var shouldAutorotate: Bool {
        return true
    }
    func setUpButtons(){
        Utilities.styleFilledButton(button: NamesButton)
        Utilities.styleFilledButton(button: VerbsButton)
        Utilities.styleFilledButton(button: AdjButton)
    }
    @IBAction func wordButtonPressed(_ sender: UIButton) {
        if sender.currentTitle! == "الصفات"{
            adj = true
            self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
        }
        else if sender.currentTitle! == "الأفعال"{
            adj = false
            self.performSegue(withIdentifier: "fromWordsToTrials", sender: self)
        }else if sender.currentTitle! == "الأسماء"{
            self.performSegue(withIdentifier: "fromWtoC", sender: self)
        }
    }
    
    @IBAction func Home(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Home", sender: self)
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
                destnationVC.modalPresentationStyle = .fullScreen
            } else{
                for trial in trials{
                    if trial.category == "male" {
                        array.append(trial)
                    }
                }
                destnationVC.trials = array
                destnationVC.modalPresentationStyle = .fullScreen
            }
        }
        else if segue.identifier == "fromWtoC"{
            let destnationVC = segue.destination as! SelectCategoriesController
            destnationVC.trials = trials
        }
        else if segue.identifier == "Home" {
            let destnationVC = segue.destination as! BaseViewController
            destnationVC.trials = trials
            destnationVC.modalPresentationStyle = .fullScreen
        }
    }
}
