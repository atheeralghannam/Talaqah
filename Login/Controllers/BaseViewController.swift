//
//  BaseViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 30/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase


class BaseViewController: UIViewController {
    
    let db = Firestore.firestore()
    var trials = [Trial]()
    var categories = ["male","female", "adj", "animal", "body","personal", "family", "cloths", "food", "drinks", "vegetables", "fruits", "pots", "house", "furniture", "devices", "public", "transportation", "jobs", "shapes","colors"]
    var documents = ["names", "verbs", "adjectives"]
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        let tal = UIColor(named: "Tala")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [tal!.cgColor, UIColor.white.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        print(trials.isEmpty)
        if (trials.isEmpty){
        for document in documents{
        let docRef = db.collection("trials").document(document)
        for category in categories {
            let doc = docRef.collection(category)
            doc.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if !data.isEmpty{
                        self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                            , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                Array<String>, settings: data["settings"] as! Array<Int>, category: category))
                        }
                       // print("\(document.documentID) => \(document.data())")
                    }
                    
                    }
                //print(self.trials)
                }
            }
        }
        }
        print(trials)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startTrial" {
            let destnationVC = segue.destination as! SelsectWordsController
            destnationVC.trials = trials
            destnationVC.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "ViewProfile" {
            let destnationVC = segue.destination as! AccountViewController
                    
                       destnationVC.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func Profile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ViewProfile", sender: self)
    }
    @IBAction func Start(_ sender: UIButton) {
        if trials.isEmpty {
            let alertController = UIAlertController(title: "فضلًا انتظر", message:
                           "يتم تحميل البيانات", preferredStyle: .alert)
                       alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                       
                       self.present(alertController, animated: true, completion: nil)
        }else{
        self.performSegue(withIdentifier: "startTrial", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logout(_ sender: UIButton) {
        
            
            let refreshAlert = UIAlertController(title: "تسجيل الخروج", message: "هل أنت متأكد من أنك تريد تسجيل الخروج؟", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    print ("signing out DONE")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                print("Handle Ok logic here")
                UserDefaults.standard.set(false, forKey:Constants.isUserLoggedIn)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "startingScreen") as! UIViewController
                
                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDel.window?.rootViewController = loginVC
                
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
    }
    
 

}
