//
//  DetailViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 08/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class DetailViewController: UIViewController, UITextFieldDelegate {

var patient: Patient?
    let db = Firestore.firestore()



    
    
    @IBOutlet var remove: UIButton!
    

    

    
    
    @IBOutlet var patientFullName: UITextField!
    
    @IBOutlet var patientID: UITextField!
    @IBOutlet var patientEmail: UITextField!
    @IBOutlet var patientPhone: UITextField!
    @IBOutlet var patientGender: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpElements()

        if let patient = patient {
            navigationItem.title = patient.FirstName
//            imageView.image = UIImage(named: recipe.thumbnails)
            
//            let name = patient.FirstName + " " + patient.LastName
                        
            patientFullName.text = patient.FirstName + " " + patient.LastName
            
            patientID.text =  patient.NID
            
            patientPhone.text =  patient.PhoneNumber
            
            patientGender.text =  patient.Gender
            
            patientEmail.text = patient.Email
       
        
        
        
        }
        
        patientFullName.delegate = self
        patientID.delegate = self
        patientPhone.delegate = self
        patientGender.delegate = self
        patientEmail.delegate = self

        
    }
    func SetUpElements() {
        
        // Hide the error label
        
        // Style the elements
        Utilities.styleTextField(textfield: patientFullName)
        Utilities.styleTextField(textfield: patientID)
        Utilities.styleTextField(textfield: patientPhone)
        Utilities.styleTextField(textfield: patientEmail)
        Utilities.styleTextField(textfield: patientGender)


        patientPhone.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        patientPhone.delegate = self
        
        
        //todo set up genderSegmented Style
        
    }
    
    @IBAction func removePatientTapped(_ sender: Any) {
        
        
        
        

                                                        
                                                        
                                                        let refreshAlert = UIAlertController(title: "إزالة المريض", message:"هل أنت متأكد من أنك تريد إزالة هذا المريض؟", preferredStyle: UIAlertController.Style.alert)
                                                               
                                                               refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                                                         
                                                                   
                                                                self.db.collection("patients")
                                                                    .whereField("NID", isEqualTo : self.patient?.NID)
                                                                                                .getDocuments() { (querySnapshot, error) in
                                                                                                    if let error = error {
                                                                                                            print(error.localizedDescription)
                                                                                                    } else if querySnapshot!.documents.count != 1 {
                                                                                                            print("More than one documents or none")
                                                                                                    } else {
                                                                                                        
                                                                                                    
                                                                                                        let document = querySnapshot!.documents.first
                                                                                                        document!.reference.updateData([
                                                                                                          "slpUid": ""
                                                                                                        ])
                                                                                //            self.tableView.reloadData()
                                                                                                       
                                                                                                        
                                                                                                        
                                                                //                                        self.showToast(message: "تمت الإضافة بنجاح", font: UIFont(name: "Times New Roman", size: 12.0)!)

                                                                                                    }}
                                                                                
                                                                                
                                                                                                  var refreshAlert = UIAlertController(title: "تم حذف المريض بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)

                                                                                                    refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                                                                      print("Handle Ok logic here")
                                                                                                   
                                                                                                        self.performSegue(withIdentifier: "backToPatientsList", sender: nil)
                                                                                                        
        //                                                                                                let patientsVC = self.storyboard?.instantiateViewController(withIdentifier: "patientsList") as! UIViewController
        //
        //                                                                                                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //                                                                                                appDel.window?.rootViewController = patientsVC
                                                                                                        
                                                                                                      }))

                                                                

                                                                                                    self.present(refreshAlert, animated: true, completion: nil)
                                                                
                                                                
                                                                   
                                                               }))
                                                               
                                                               refreshAlert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { (action: UIAlertAction!) in
                                                                   print("Handle Cancel Logic here")
                                                               }))
                                                               
                                                        self.present(refreshAlert, animated: true, completion: nil)
                                                        
                                                        
        
        
        
        
        

    }
}

