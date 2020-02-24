//
//  editprofileViewController.swift
//  Login
//
//  Created by rawan almajed on 22/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

//
//  editprofileViewController.swift
//  Talaqah
//
//  Created by rawan almajed on 11/06/1441 AH.
//  Copyright © 1441 Muhailah AlSahali. All rights reserved.
//

import UIKit
import Firebase


class editprofileViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate{
 
   let db = Firestore.firestore()

    private var document:[DocumentSnapshot] = []
    
    var pEmail=String(), fName = String(), lName = String(), pGender = String(),pnID = String(), phoneNumber = String()
    
    


    @IBOutlet var natId: UITextField!
    @IBOutlet var uemail: UITextField!
    @IBOutlet var umobile: UITextField!
    @IBOutlet var funame: UITextField!
    @IBOutlet var luname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       loadProfileData()
      
        

        // Do any additional setup after loading the view.
        
        funame.delegate = self
       luname.delegate = self
       // age.delegate = self
       // gender.delegate = self
        natId.delegate = self
        umobile.delegate = self
        uemail.delegate = self
        
    }
    
    
    
    @IBAction func SaveProfileData(_ sender: Any) {
        editUsersProfile()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        umobile.resignFirstResponder()
       
    }
    
    
    func editUsersProfile(){
            
            guard let newfname  = self.funame.text else {return}
           guard let newlname  = self.luname.text else {return}
            guard let newemail = self.uemail.text else {return}
           guard let newidnum  = self.natId.text else {return}
         guard let newmobile  = self.umobile.text else {return}
        db.collection("patients")
            .whereField("uid", isEqualTo :Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                        print(error.localizedDescription)
                } else if querySnapshot!.documents.count != 1 {
                        print("More than one documents or none")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                      "FirstName": newfname,
                       "LastName": newlname,
                       "Email":newemail,
                       "NID": newidnum,
                       "PhoneNumber":newmobile
                       
                    ])
                    
//                 let user = Auth.auth().currentUser
//                    let credential = EmailAuthProvider.credential(withEmail: "email", password: "password")
//
//                    user?.reauthenticate(with: credential)
//                    { error in
//                       if let error = error {
//                          // An error happened.
//                       } else {
//                          // User re-authenticated.
//                          user?.updateEmail(to: "newemail")
//                          { error in
//
//                          }
//                       }
//                    }
                    
             Auth.auth().currentUser?.updateEmail(to: newemail) { (error) in
                      // ...
                print(error?.localizedDescription)
                    }
//
                    
                }
        }}
         
      //  guard let patid = Auth.auth().currentUser?.uid; else { return }
         //   guard let uid = Auth.auth().currentUser?.uid else { return }
     //mm   guard let uId = Auth.auth().currentUser?.uid else { return }
    //mmmm    let pofile = db.collection("patients").document(uId)//"6tQAB7vsPEjgyP6nrqwv")
//print(uId)
//print(pofile)
    // Set the "capital" field of the city 'DC'
  //mm  pofile.updateData([
     //mm   "FirstName": newfname,
     //   "LastName": newlname,
       // "Email":newemail,
        //"NID": newidnum,
        //"PhoneNumber":newmobile
        
    //]) { err in
      //  if let err = err {
        //    print("Error updating document: \(err)")
        //} else {
          //  print("Document successfully updated")
        //}
    //}
      //  }// end edit
    
    
    //
    func loadProfileData(){
              //if the user is logged in get the profile data
      // let db = Firestore.firestore()
        
        db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments {(snapshot, error) in
            if let error = error{print(error.localizedDescription)}
            else {
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        let data = document.data()
                    
      //  if let userID = Auth.auth().currentUser?.uid{
             //  db.child("patients").child(userID).observe(.value, with: { (snapshot) in
                      
                      //create a dictionary of users profile data
                     //   let values = snapshot.value as? NSDictionary
            self.pEmail = data["Email"] as! String
            self.fName = data["FirstName"] as! String
            self.lName = data["LastName"] as!String
                        
                        
                      
            self.pGender = data["Gender"] as! String
            self.pnID = data["NID"] as! String
            self.phoneNumber = data["PhoneNumber"] as! String
            
                        
                      
            self.uemail.text = self.pEmail
            self.funame.text = self.fName
            self.luname.text = self.lName
         //   self.gender.text = self.pGender
           self.natId.text = self.pnID
           self.umobile.text = self.phoneNumber
                    }}}}
}// end of load
 
    
    
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }

}
