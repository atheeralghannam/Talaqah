//
//  RegisterViewController.swift
//  Login
//
//  Created by Haneen Abdullah on 12/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterController: UIViewController, UITextFieldDelegate {
    
    var validation = Validation()
    var gender = "male"
    
    //    var isValidId = true
    
    
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var nIDTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var haveAccount: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func genderSegmented(_ sender: Any) {
        let getIndex = genderSegmented.selectedSegmentIndex
        if getIndex == 0 {
            gender = "male"
        }
        else {
            gender = "female"
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SetUpElements()
    }
    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        
    }
    
    
    
    func SetUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: firstNameTextField)
        Utilities.styleTextField(textfield: lastNameTextField)
        Utilities.styleTextField(textfield: nIDTextField)
        Utilities.styleTextField(textfield: emailTextField)
        Utilities.styleTextField(textfield: phoneNumberTextField)
        Utilities.styleTextField(textfield: passwordTextField)
        Utilities.styleTextField(textfield: confirmPasswordTextField)
        Utilities.styleFilledButton(button: registerButton)
        Utilities.styleErrorLabel(label: errorLabel)
        Utilities.styleLabel(label: haveAccount)
        Utilities.styleSecondaryButton(button: loginButton)
        //setup limit inputs length
        nIDTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        phoneNumberTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nIDTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Get text input from TextField
        guard
            let password=passwordTextField.text
            
            else {
                return nil}
        
        let confirmPassword = confirmPasswordTextField.text
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            //            return "Please fill in all fields."
            return "الرجاء التحقق من تعبئة جميع الحقول"
        }
        
        
        // how to use
        //                                do {
        //                                    let resutl = try ValidateSAID.check(nIDTextField.text!)
        //
        //                                    // this will print NationaltyType description
        //                                    print(resutl)
        //                                } catch {
        //                                    // this will print error description
        //                                    isValidId=false
        //                                    print(error)
        ////                                    self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
        ////                                                  idTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
        //                                }
        
        
        
        // Check if the password is secure
        let isValidatePass = self.validation.validatePassword( password: password)
        let isMatchedPass=(password==confirmPassword)
        let isValidateId=self.validation.isValidateId(id: nIDTextField.text!)
        let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!)
        
        
        
        if isValidatePass == false {
            // Password isn't secure enough
            return "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام"
            //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        if isMatchedPass==false{
            return "كلمة المرور يجب أن تحتوي على الأقل ثمانية أحرف وأرقام"
            //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
            
        }
        
        if isValidateId==false{
            return "رقم الهوية/الإقامة غير صحيح"
        }
        
        if isValidPhone==false {
            return "الرجاء التحقق من إدخال رقم صحيح : ********05"
//            return "Please enter valid phone: 05********"
        }
        
        return nil
    }
    
    
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    
    @IBAction func RegisterTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let nID = nIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //                                let gender="female"
            
            
            
            
            
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    // check if email is already registered
                    Auth.auth().fetchSignInMethods(forEmail: email, completion: {
                        (providers, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.showError("خطأ في تسجيل المستخدم !")
                            //                            self.showError("Error creating user")
                            print("Error creating user")
                        } else if let providers = providers {
                            self.showError("هذا البريد الإلكتروني مسجل مسبقًا")
                            //                            self.showError("Email already exists")
                            print("Email already exists")
                            print(providers)
                        }
                    })
                    // There was an error creating the user
                    //                                        self.showError("Error creating user")
                    //                                        print("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    //                                     db.collection("users").addDocument(data: ["NID": nID,"FirstName":firstName,"LastName":lastName,"Email":email, "PhoneNumber": phone,"Gender":gender,"uid": result!.user.uid ]) { (error) in
                    db.collection("patients").addDocument(data: ["NID": nID, "FirstName":firstName, "LastName":lastName, "Email":email, "PhoneNumber": phone, "Gender": self.gender, "uid": result!.user.uid ]) { (error) in
                        
                        
                        
                        if error != nil {
                            // Show error message
                            self.showError("خطأ في حفظ بيانات المستخدم !")
                            //                             self.showError("Error saving user data")
                            print("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    //                                  self.transitionToHome()
                    self.performSegue(withIdentifier: "toStart", sender: nil)
                }
                
            }
            
            
        }
    }
    
    
    
    @IBAction func LoginTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let maxLength : Int
        
        if textField == nIDTextField {
            maxLength = 10
        }
        else if textField == phoneNumberTextField {
            maxLength = 10
        }
        else {
            maxLength = 50
        }
        
        let currentString: NSString = textField.text! as NSString
        
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
    
    
}


