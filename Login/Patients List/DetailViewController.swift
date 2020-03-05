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


class DetailViewController: UIViewController {

var patient: Patient?
    let db = Firestore.firestore()


    @IBOutlet var imageViw: UIImageView!
    
    @IBOutlet var firstname: UILabel!
    
    
    @IBOutlet var patId: UILabel!
    
    
    @IBOutlet var remove: UIButton!
    
    @IBOutlet var phoneNum: UILabel!
    
    @IBOutlet var gender: UILabel!
    @IBOutlet var emailPatientLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let patient = patient {
            navigationItem.title = patient.FirstName
//            imageView.image = UIImage(named: recipe.thumbnails)
            
//            let name = patient.FirstName + " " + patient.LastName

            firstname.text = patient.FirstName + " " + patient.LastName
            
            patId.text = "رقم المريض:" + patient.NID
            
            phoneNum.text = "رقم الجوال:" + patient.PhoneNumber
            
            gender.text = "الجنس:" + patient.Gender
            
            emailPatientLabel.text = "البريد الإلكتروني:" + patient.Email
       
        
        
        
        }
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

