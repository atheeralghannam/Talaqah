
import UIKit
import Firebase

class PatientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var patientsArray = [Patient]()
    var db: Firestore!
    var patientId = ""
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet var addButton: UIButton!
    
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
//        cell.accessoryType.
        

        return cell
    }
    // ------------for disable rotate > portrait view only
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
       }
       
       override open var shouldAutorotate: Bool {
           return false
       }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "إضافة مريض", message: "ادخل رقم هوية/إقامة المريض الذي تود إضافته", preferredStyle: UIAlertController.Style.alert)
        
        
        
        refreshAlert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = .numberPad

            
        }
        
        refreshAlert.addAction(UIAlertAction(title: "إضافة", style: .default, handler: { [weak refreshAlert] (_) in

            let numOfText = refreshAlert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines).count
            
            if numOfText != 0 {
                // Text field is not empty

                
                // how to use
    do {
        let resutl = try ValidateSAID.check((refreshAlert?.textFields![0].text)!)
                    // this will print NationaltyType description
                    print(resutl)
                } catch {
                    // this will print error description
                print(error)
                self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
                }
//
//                if(){
//                    return
//                }
                var foundAddedBefore=false
                
                for element in self.patientsArray {
                    if refreshAlert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) == element.NID{
                        
                    self.showToast(message: "هذا المريض مضاف سابقًا بالفعل", font: UIFont(name: "Times New Roman", size: 12.0)!)
                        return

                    }
                    
                }
                
                            
                            self.db.collection("patients")
                                .whereField("NID", isEqualTo : refreshAlert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines))
                                .getDocuments() { (querySnapshot, error) in
                                    if let error = error {
                                            print(error.localizedDescription)
                                    } else if querySnapshot!.documents.count != 1 {
                                            print("More than one documents or none")
                                    } else {
                                        
                                    
                                        let document = querySnapshot!.documents.first
                                        document!.reference.updateData([
                                          "slpUid": Auth.auth().currentUser!.uid
                                        ])
                //            self.tableView.reloadData()
                                        self.patientsArray.removeAll()
                                        self.loadData()
                                        
                                        self.showToast(message: "تمت الإضافة بنجاح", font: UIFont(name: "Times New Roman", size: 12.0)!)
                                             print("empty id")

                                    }}

            } else {
                // Text field is empty
                self.showToast(message: "لم تقم بإدخال أية رقم", font: UIFont(name: "Times New Roman", size: 12.0)!)
                print("empty id")
            }
            
        }  ))
    
        refreshAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
}


