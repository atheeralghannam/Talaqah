//
//  ProgressViewController.swift
//  Talaqah
//
//  Created by Horiah on 21/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ProgressViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var sendProgress: UIButton!
     let db = Firestore.firestore()
    var pEmail = String()
    
    @IBOutlet var sendEmail: UIBarButtonItem!
    
    @IBAction func sendEmailPressed(_ sender: UIButton) {
    
    if MFMailComposeViewController.canSendMail() {
                    print("email")
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                db.collection("patients").whereField("uid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let snapshot = snapshot {
                            
                            for document in snapshot.documents {
                                let data = document.data()
                                self.pEmail = data["Email"] as! String
                                //print("I send email")
                            }
                        }
                    }
                    // from talagah to SLP check
                    //mail.setToRecipients(["horalfaisal2016@gmail.com"])
                    //mail.setToRecipients([self.pEmail])
                    //mail.setToRecipients(["horalfaisal2016@gmail.com","horalfaisal2016@gmail.com"])
                }
                 //message.append(Auth.auth().currentUser!.email!)
                mail.setToRecipients(["@gmail.com"])
                    mail.setSubject("Subject")
                    mail.setMessageBody("ViewBody", isHTML: false)
                    self.present(mail, animated: true)
                    
                } else {
                    // show failure alert
                            print("Cannot send email")

                }
            }
            
    // func configureMailComposer() -> MFMailComposeViewController{
    //             let mailComposeVC = MFMailComposeViewController()
    //             mailComposeVC.mailComposeDelegate = self
    // //            mailComposeVC.setToRecipients([self.textFieldTo.text!])
    // //            mailComposeVC.setSubject(self.textFieldSubject.text!)
    // //            mailComposeVC.setMessageBody(self.textViewBody.text!, isHTML: false)
    //             mailComposeVC.setToRecipients(["@gmail.com"])
    //             mailComposeVC.setSubject("Subject")
    //             mailComposeVC.setMessageBody("ViewBody", isHTML: false)
    //             return mailComposeVC
    //         }
    //
    //        let mailComposeViewController = configureMailComposer()
    //            if MFMailComposeViewController.canSendMail(){
    //                self.present(mailComposeViewController, animated: true, completion: nil)
    //                print("send email")
    //            }else{
    //                print("This device is not configured to send email. Please set up an email account.")
    //            }
    //
    //
    
       func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
                    case MFMailComposeResult.cancelled.rawValue:
                        print("Cancelled")
                    case MFMailComposeResult.saved.rawValue:
                        print("Saved")
                    case MFMailComposeResult.sent.rawValue:
                        print("Sent")
                    case MFMailComposeResult.failed.rawValue:
                        print("Error: \(String(describing: error?.localizedDescription))")
                    default:
                        break
                    }
       controller.dismiss(animated: true)
       }

      
        
        
        
        
        
      
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
