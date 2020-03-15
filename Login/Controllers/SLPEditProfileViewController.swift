//
//  SLPEditProfileViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 17/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase


class SLPEditProfileViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var slpLname: UITextField!
    @IBOutlet var slpfname: UITextField!
    @IBOutlet var slpPhone: UITextField!
    @IBOutlet var slpEmail: UITextField!
    @IBOutlet var saveButton: UIButton!
    let db = Firestore.firestore()
    var validation = Validation()

    @IBOutlet var errorLabel: UILabel!
    
    
    var sEmail=String(), fName = String(), lName = String(), phoneNumber = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        SetUpElements()

        // Do any additional setup after loading the view.
        loadProfileData()
        
        slpLname.delegate = self
        slpfname.delegate = self
        slpPhone.delegate = self
        slpEmail.delegate = self


    }
    
    func SetUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(textfield: slpLname)
        Utilities.styleTextField(textfield: slpfname)
        Utilities.styleTextField(textfield: slpPhone)
        Utilities.styleTextField(textfield: slpEmail)
        Utilities.styleSecondaryButton(button: saveButton)

        slpPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        slpPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    
        func validateFields() -> String? {
            
//            UserDefaults.standard.set(true,forKey: Constants.isNewEmail)

            
            // Get text input from TextField
    
            
            // Check that all fields are filled in
            if slpLname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                slpfname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                slpPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                slpEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                //            return "Please fill in all fields."
                return "الرجاء التحقق من تعبئة جميع الحقول"
            }
            
//            
//       
//            Firestore.firestore().collection("slps").whereField("email", isEqualTo:slpEmail.text!).getDocuments { (snapshot, error) in
//                                                                                        if let error = error {
//                                                                                            print(error.localizedDescription)
//                                                                                        } else {
//                                                                                            if let snapshot = snapshot {
//
//                                                                                                for document in snapshot.documents {
//            // patientSLP
//                            let data = document.data()
//                                                                                                    
//                                                                                                
//                    if(data ["uid"] as! String == Auth.auth().currentUser!.uid){
//                        UserDefaults.standard.set(true,forKey: Constants.isNewEmail)
//
//                                                                                                   
//                        print("yaaaas")
//                        
//                    }
//                    else{
//                        UserDefaults.standard.set(false,forKey: Constants.isNewEmail)
//                                                   }
//                                                                                                    
//                                                                                                }
//                                                                                            }
//                }
//            }
//            
//            
//            Firestore.firestore().collection("patients").whereField("Email", isEqualTo:slpEmail.text!).getDocuments { (snapshot, error) in
//                                                                                        if let error = error {
//                                                                                            print(error.localizedDescription)
//                                                                                        } else {
//                                                                                            
//                                                                                            
//                                                                       if let snapshot = snapshot {
//
//                                                                                                                            for document in snapshot.documents {
//                                                                                            // patientSLP
//                                                                                                            let data = document.data()
//                                                                                                                                                                                    
//                                                                                                                                                                                
//                                                                                                                                if(data ["Email"] as? String == self.slpEmail.text ){
//                                                                                                                                                                                   UserDefaults.standard.set(false,forKey: Constants.isNewEmail)
//
//                                                                                                        print("yaaaas")
//                                                                                                        
//                                                                                                    }
//                                                                                                                                else{
//                                                                                                                                    UserDefaults.standard.set(true,forKey: Constants.isNewEmail)
//
//                                                                                                                                }
//                                                                                                 
//                                                                                                                                                                                    
//                                                                        }
//                                                                                                                                                                            }
////                                                                                            self.isNewEmail=false
//                                                                                            
//                                                                                            }
//            }
//            
         
            
//             isNewEmail=

            let isValidPhone=self.validation.isValidPhoneNumber(phoneNumber: slpPhone.text!) 
            
            let isValidEmail=self.validation.validateEmailId(emailID: slpEmail.text!)

            
            if isValidPhone==false {
                return "الرجاء التحقق من إدخال رقم صحيح : ********05"
    //            return "Please enter valid phone: 05********"
            }
            
                    if isValidEmail==false {
                        return "الرجاء التحقق من إدخال بريد إلكتروني صحيح"
            //            return "Please enter valid phone: 05********"
                    }
            
//            print("??????")
//                           print(UserDefaults.standard.bool(forKey: Constants.isNewEmail))
//            if UserDefaults.standard.bool(forKey: Constants.isNewEmail)==false {
//                print("!!!!!!!!")
//                print("falsw")
//                                  return "هذا البريد الإلكتروني مستخدم من شخص آخر"
//                      //            return "Please enter valid phone: 05********"
//                              }
            
            
            let isValidName=self.validation.validateName(name: slpfname.text!) &&  self.validation.validateName(name: slpLname.text!)
            
                    if isValidName==false {
                        return "الرجاء التحقق من إدخال اسم"
                    }
            
            return nil
        }
    
    func showError(_ message:String) {

        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    
    
    
    
        

    
    
    
    @IBAction func saveTapped(_ sender: Any) {
        editUsersProfile()

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
        func loadProfileData(){

            
            db.collection("slps").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments {(snapshot, error) in
                if let error = error{print(error.localizedDescription)}
                else {
                    if let snapshot = snapshot {
                        for document in snapshot.documents{
                            let data = document.data()

                self.sEmail = data["email"] as! String
                self.fName = data["fname"] as! String
                self.lName = data["lname"] as!String
                self.phoneNumber = data["phone"] as! String
                
                            
                          
                self.slpEmail.text = self.sEmail
                self.slpfname.text = self.fName
                self.slpLname.text = self.lName
               self.slpPhone.text = self.phoneNumber
                        }}}}
    }// end of load
    
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
    
        func editUsersProfile(){
            
            
            
            
            
                    // Validate the fields
                    let error = validateFields()
                    
                    if error != nil {
                        
                        // There's something wrong with the fields, show error message
                        showError(error!)
                    }
                    else {
                        self.errorLabel.alpha = 0

    
                                                                        
                                                                        let refreshAlert = UIAlertController(title: "حفظ التغييرات", message:"هل أنت متأكد من أنك تريد حفظ التغييرات؟", preferredStyle: UIAlertController.Style.alert)
                                                                               
                                                                               refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                                                                                
                                                                                
                                                                                
                                                                                          guard let newfname  = self.slpfname.text else {return}
                                                                                           guard let newlname  = self.slpLname.text else {return}
                                                                                            guard let newemail = self.slpEmail.text else {return}
                                                                                         guard let newmobile  = self.slpPhone.text else {return}
                                                                                        
                                                                                self.db.collection("slps")
                                                                                            .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
                                                                                            .getDocuments() { (querySnapshot, error) in
                                                                                                if let error = error {
                                                                                                        print(error.localizedDescription)
                                                                                                } else if querySnapshot!.documents.count != 1 {
                                                                                                        print("More than one documents or none")
                                                                                                } else {
                                                                                                    let document = querySnapshot!.documents.first
                                                                                                    document!.reference.updateData([
                                                                                                      "fname": newfname,
                                                                                                       "lname": newlname,
                                                                                                       "email":newemail,
                                                                                                       "phone":newmobile
                                                                                                       
                                                                                                    ])

                                                                                                    
                                                                                             Auth.auth().currentUser?.updateEmail(to: newemail) { (error) in
                                                                                                      // ...
                                                                                                print(error?.localizedDescription)
                                                                                                    }
                                                                                                    
                                                                                                    

                                                                                //
                                                                                                    
                                                                                                }
                                                                                        }
                                                                         
                                                                                   
                                                                                                
                                                                                                
                                                                                                                  var refreshAlert = UIAlertController(title: "تم حفظ التغييرات بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)

                                                                                                                    refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                                                                                      print("Handle Ok logic here")
                                                                                                                   
                                     }))

                                                                                

                                                                                                                    self.present(refreshAlert, animated: true, completion: nil)
                                                                                
                                                                                
                                                                                   
                                                                               }))
                                                                               
                                                                               refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                                   print("Handle Cancel Logic here")
                                                                               }))
                                                                               
                                                                        self.present(refreshAlert, animated: true, completion: nil)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        

                                    
  
                        
                    }
            
            
            
            

            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           slpPhone.resignFirstResponder()
          
       }
    
    
}
