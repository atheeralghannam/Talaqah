//
//  HomeViewController.swift
//  Login
//
//  Created by Atheer Alghannam on 07/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//hmmmmmm...

import UIKit
import Firebase
import FirebaseAuth
class HomeViewController: UIViewController {
@IBOutlet weak var ResetTextField: UITextField!
    var validation = Validation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPassword(_ sender: Any) {
         guard
        //
                    let email = ResetTextField.text
         else {
        return
         }
        let isValidateEmail = self.validation.validateEmailId(emailID: email)
                      if (isValidateEmail == false) {
                         print("Incorrect Email")
                       self.showToast(message: "Incorrect Email", font: UIFont(name: "Times New Roman", size: 12.0)!)
                       ResetTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)

                         return
                      }
            Auth.auth().sendPasswordReset(withEmail: self.ResetTextField.text!) { error in
                if error != nil {
               print("email is wrong")
                     self.showToast(message: "email is wrong.", font: UIFont(name: "Times New Roman", size: 12.0)!)
              } else {
                print("Password reset email sent.")
                self.showToast(message: "Password reset email sent.", font: UIFont(name: "Times New Roman", size: 12.0)!)
                // Password reset email sent.
              }
            }
    }

}
