//
//  Patient.swift
//  Login
//
//  Created by Haneen Abdullah on 09/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import Foundation
import Firebase

struct Patient {
    var NID:String
    var FirstName:String
    var LastName:String
    var Gender:String
    var PhoneNumber:String
    var Email:String
    var uid:String
    
    func printName() {
        print("\(self.FirstName) \(self.LastName)")
    }
    
}
//extension Patient {
//    
//    static func createPatients() -> [Patient]{
//        var pEmail = String(), fName = String(), lName = String(), pGender = String(), pnID = String(), phoneNumber = String(), puid = String()
//        let db = Firestore.firestore()
//            var patients = [Patient]()
//
//
//                        db.collection("patients").whereField("slpUid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            } else {
//                                if let snapshot = snapshot {
//
//                                    for document in snapshot.documents {
//
//                                        let data = document.data()
//
//                                        //self.pEmail = data["Email"] as? String ?? ""
//                                        pEmail = data["Email"] as! String
//                                        fName = data["FirstName"] as! String
//                                        lName = data["LastName"] as! String
//                                        pGender = data["Gender"] as! String
//                                        pnID = data["NID"] as! String
//                                       phoneNumber = data["PhoneNumber"] as! String
//                                        puid = data["uid"] as! String
//
//                                        var patient = Patient(NID: pnID, FirstName: fName, LastName: lName, Gender: pGender, PhoneNumber: phoneNumber, Email: pEmail, uid: puid)
//
//                                        patients.append(patient)
//
//                                    }
//                                    for element in patients {
//                                                       print(element)
//                                                     }
//
//
//
//
//                                }
//                            }
//                        }
//        return patients
//
//    }
//    }
//

