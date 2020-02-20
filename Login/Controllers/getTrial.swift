//
//  getTrial.swift
//  Login
//
//  Created by Horiah on 18/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class getTrial: UIViewController {

    var answer = String()
     var pict = String()
     let db = Firestore.firestore()
     
     override func viewDidLoad() {
         super.viewDidLoad()

         
         
     }
     func getAnswer() {
         
         db.collection("trials").getDocuments { (snapshot, error) in
                       if let error = error {
                           print(error.localizedDescription)
                       } else {
                           if let snapshot = snapshot {

                               for document in snapshot.documents {

                                 let data = document.data()
                                   
                                 self.answer = data["Answer"] as! String
                                 print(self.answer)
                               }
                               
                           }
                       }
         }
     }
     
     func getPic() {
         db.collection("trials").getDocuments { (snapshot, error) in
                              if let error = error {
                                  print(error.localizedDescription)
                              } else {
                                  if let snapshot = snapshot {

                                      for document in snapshot.documents {

                                        let data = document.data()
                                          
                                        self.pict = data["Image"] as! String
                                        print(self.pict)
                                      }
                                      
                                  }
                              }
                }
     }
    
     func getForCategory(category : String){
         db.collection("trials").whereField("Category", isEqualTo: category)
             .getDocuments() { (querySnapshot, error) in
                 if let error = error {
                     print("Error getting documents: \(error)")
                 } else {
                     for document in querySnapshot!.documents {
                         print("\(document.documentID) => \(document.data())")
                     }
                 }
         }
     }
     
     func getForExType(exType : String){
         db.collection("trials").whereField("ExerciseType", isEqualTo: exType)
             .getDocuments() { (querySnapshot, error) in
                 if let error = error {
                     print("Error getting documents: \(error)")
                 } else {
                     for document in querySnapshot!.documents {
                         print("\(document.documentID) => \(document.data())")
                     }
                 }
         }
     }
     
     func cues(){
         db.collection("trials").getDocuments { (snapshot, error) in
                       if let error = error {
                           print(error.localizedDescription)
                       } else {
                           if let snapshot = snapshot {

                               for document in snapshot.documents {

                                 let data = document.data()["Cues"]! as! [Any]
                                 print(data)
                                  
                                 for (index, element) in data.enumerated() {
                                     print(element)
                                 }

                               }
                               
                           }
                       }
         }
     }
}
