//
//  slpLoginViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 07/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
class slpLoginViewController: UIViewController {
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var haveAccount: UILabel!
    
    @IBOutlet var slploginButton: UIButton!
    var validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isLogin()
        setUpElements()
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
              guard
                  let email = emailTextfield.text,
                  let password = passwordTextfield.text

                  else {
                      return
              }
   
                             let isValidateEmail = self.validation.validateEmailId(emailID: email)
                             if (isValidateEmail == false) {
                                print("Incorrect Email")
                              self.showToast(message: "Incorrect Email", font: UIFont(name: "Times New Roman", size: 12.0)!)
                              emailTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
              
                                return
                             }
              
        let isValidatePass = self.validation.validatePassword(password: password)
        if (isValidatePass == false) {
            print("Incorrect Pass")
            self.showToast(message: "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام", font: UIFont(name: "Times New Roman", size: 12.0)!)
            passwordTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            
            return
        }

        
                       if (isValidateEmail == true || isValidatePass == true) {
                              print("All fields are correct")
                        
                        
                        Auth.auth().signIn(withEmail:email , password:password){ (user, error) in

                              
                              
                              if user != nil {
                                  // Couldn't sign in
                                  //                self.errorLabel.text = error!.localizedDescription
                                  //                self.errorLabel.alpha = 1
                                  print("user has signed in")
                                  UserDefaults.standard.set(true, forKey:Constants.isSlpLoggedIn)
                                  UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: Constants.userUid)
                                  
                                  //                                        UserDefaults.standard.synchronize()
                                  self.performSegue(withIdentifier: "toSLPhome", sender: nil)
                              }
                              else {
                                  if error != nil{
                                      print(error.debugDescription)
                                      
                                  }
                              }
                              
                          }
                          
                          //}
                      }
              }
              
              
              
              // Signing in the user
              
    
    
    func isLogin (){
        print(  UserDefaults.standard.bool(forKey: "slpLogin"))
        //        // Do any additional setup after loading the view, typically from a nib.
        if(UserDefaults.standard.bool(forKey: "slpLogin") == true){
            //           self.performSegue(withIdentifier: "toHome", sender: nil)
            print("Session is saved")
            //
            //
        }
        
    }
    
//    @IBAction func forgetPasswordTapped(_ sender: Any) {
//               self.performSegue(withIdentifier: "toResetPassword", sender: nil)
//      }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setUpElements() {
        
        // Hide the error label
        //           errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: emailTextfield)
        Utilities.styleTextField(textfield: passwordTextfield)
        Utilities.styleFilledButton(button: slploginButton)
        
        Utilities.styleLabel(label: haveAccount)
        Utilities.styleSecondaryButton(button: forgetPassword)
        Utilities.styleSecondaryButton(button: slploginButton)
        
        
//        // limit input length of id
//        idTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
//        idTextField.delegate = self
        
    }
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
}
