//
//  ViewController.swift
//  LoginExample
//
//  Created by Gary Tokman on 3/10/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
  @IBOutlet weak var resetTextField: UITextField!
    @IBOutlet weak var regEmail: UITextField!
    @IBOutlet weak var regPassword: UITextField!
    var validation = Validation()

    var mail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
////       defaults.set(true, forKey:"userLogin")
           print("what???")
   print(  UserDefaults.standard.bool(forKey: "userLogin"))
//        // Do any additional setup after loading the view, typically from a nib.
        if(UserDefaults.standard.bool(forKey: "userLogin") == true){
//           self.performSegue(withIdentifier: "toHome", sender: nil)
            print("Session is saved")
//
//
       }
    

    }
      @IBAction func loginF(_ sender: Any) {
        
      

        guard
//            let name = validateNameTxtFld.text,
            let id = idTextField.text,
            let password = passwordTextField.text
        //,
//        let phone = validatePhoneTxtFld.text
            else {
           return
            }
//               let isValidateName = self.validation.validateName(name: name)
//               if (isValidateName == false) {
//                  print("Incorrect Name")
//                  return
//               }
//               let isValidateEmail = self.validation.validateEmailId(emailID: email)
//               if (isValidateEmail == false) {
//                  print("Incorrect Email")
//                self.showToast(message: "Incorrect Email", font: UIFont(name: "Times New Roman", size: 12.0)!)
//                emailTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
//
//                  return
//               }
        
//               let isValidatePhone = self.validation.validaPhoneNumber(phoneNumber: id)
//               if (isValidatePhone == false) {
//                  print("Incorrect id")
//                  return
//               }
//               if (isValidateName == true || isValidateEmail == true || isValidatePass == true || isValidatePhone == true) {
//                  print("All fields are correct")
        
        
        
        // how to use
        do {
            let resutl = try ValidateSAID.check(id)
        
            // this will print NationaltyType description
            print(resutl)
        } catch {
            // this will print error description
            print(error)
            self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
                          idTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
        }
        
        
        
        let isValidatePass = self.validation.validatePassword(password: password)
                if (isValidatePass == false) {
                   print("Incorrect Pass")
                 self.showToast(message: "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام", font: UIFont(name: "Times New Roman", size: 12.0)!)
                 passwordTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)

                   return
                }
        
        if (isValidatePass == true ) {
                       print("All fields are correct")
               }
            
        let db = Firestore.firestore()

        db.collection("patients").whereField("NID", isEqualTo: idTextField.text!)
             .getDocuments() { (querySnapshot, err) in
//                 if let err = err {
//                     print("Error getting documents: \(err)")
//                 } else {
                     for document in querySnapshot!.documents {
//                         print("\(document.documentID) => \(document.data())")


//                        let data = document.data()
                        self.mail = document.data()["Email"] as! String
                        print( self.mail)
                        
                        Auth.auth().signIn(withEmail: self.mail.trimmingCharacters(in: .whitespacesAndNewlines), password: self.passwordTextField.text!) { (user, error) in
                                
                        //        Auth.auth().signIn(withEmail: idTextField.text!, password: passwordTextField.text!) { (user, error) in

                                    
                                    if user != nil {
                                        // Couldn't sign in
                        //                self.errorLabel.text = error!.localizedDescription
                        //                self.errorLabel.alpha = 1
                                        print("user has signed in")
                                        UserDefaults.standard.set(true, forKey:Constants.isUserLoggedIn)
                                        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: Constants.userUid)

//                                        UserDefaults.standard.synchronize()
                                        self.performSegue(withIdentifier: "toHome", sender: nil)
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

    }
    
    
   
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
//            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//            self.performSegue(withIdentifier: "toHome", sender: nil)


//            let alertController = UIAlertController(title: "تسجيل الخروج", message:
//                "Hello, world!", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "هل أنت متأكد من أنك تريد تسجيل الخروج؟", style: .default))
//
//            self.present(alertController, animated: true, completion: nil)
