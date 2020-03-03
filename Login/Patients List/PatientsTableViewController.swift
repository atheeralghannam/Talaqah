
import UIKit
import Firebase

class PatientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var patientsArray = [Patient]()
    var db: Firestore!
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        db = Firestore.firestore()
        loadData()

    }
    func loadData() {
        
        

        

            var pEmail = String(), fName = String(), lName = String(), pGender = String(), pnID = String(), phoneNumber = String(), puid = String()
            let db = Firestore.firestore()
//                var patients = [Patient]()


                            db.collection("patients").whereField("slpUid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot {

                                        for document in snapshot.documents {

                                            let data = document.data()

                                            //self.pEmail = data["Email"] as? String ?? ""
                                            pEmail = data["Email"] as! String
                                            fName = data["FirstName"] as! String
                                            lName = data["LastName"] as! String
                                            pGender = data["Gender"] as! String
                                            pnID = data["NID"] as! String
                                           phoneNumber = data["PhoneNumber"] as! String
                                            puid = data["uid"] as! String

                                            let patient = Patient(NID: pnID, FirstName: fName, LastName: lName, Gender: pGender, PhoneNumber: phoneNumber, Email: pEmail, uid: puid)

                                            self.patientsArray.append(patient)

                                        }


//                                        print(self.scheduleIDarray)

                                        self.tableView.reloadData()


                                    }
                                }
                            }
        
        
        
        
//
//        db.collection("schedules").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//
//                    self.scheduleIDarray.append(document.documentID)
//                }
//            }
//            print(self.scheduleIDarray)
//
//            self.tableView.reloadData()
//        }

    }

    //Tableview setup
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

                print("Tableview setup \(patientsArray.count)")
        return patientsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell

   cell.configurateTheCell(patientsArray[indexPath.row])
        print("Array is populated \(patientsArray)")

        return cell
    }
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }

}

