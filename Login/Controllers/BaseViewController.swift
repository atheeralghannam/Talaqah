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
    
    @IBOutlet weak var logout: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signOut(_ sender: Any) {
        
        
        
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
            
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDel.window?.rootViewController = loginVC
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
        
    }


}
