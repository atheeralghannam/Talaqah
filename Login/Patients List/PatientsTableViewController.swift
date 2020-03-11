
import UIKit
import Firebase

class PatientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var patientsArray = [Patient]()
    var db: Firestore!
    var patientId = ""
    var slpUidd=""

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


                            db.collection("patients").whereField("slpUid", isEqualTo:Auth.auth().currentUser!.uid).getDocuments { (snapshot, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    if let snapshot = snapshot {

                                        for document in snapshot.documents {

                                            let data = document.data()

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



                                        self.tableView.reloadData()


                                    }
                                }
                            }
        
        


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
                    
                    
                    var refreshAlert = UIAlertController(title: "خطأ", message: "رقم الهوية/الإقامة غير صالح", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                      print("Handle Ok logic here")
                      }))

                    self.present(refreshAlert, animated: true, completion: nil)
//
                }

                
                for element in self.patientsArray {
                    if refreshAlert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines) == element.NID{
                        
                        
                        
                                          var refreshAlert = UIAlertController(title: "", message: "هذا المريض مضاف لديك مسبقًا", preferredStyle: UIAlertController.Style.alert)

                                            refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                              print("Handle Ok logic here")
                                              }))


                                            self.present(refreshAlert, animated: true, completion: nil)
                        return

                    }
                    
                }
                
                            
                            self.db.collection("patients")
                                .whereField("NID", isEqualTo : refreshAlert?.textFields![0].text?.trimmingCharacters(in: .whitespacesAndNewlines))
                                .getDocuments() { (querySnapshot, error) in
                                    if let error = error {
                                            print(error.localizedDescription)

                                    } else if querySnapshot!.documents.count != 1 {
                                        var refreshAlert = UIAlertController(title: "", message: "عذرًا، لا يوجد مريض بهذا الرقم", preferredStyle: UIAlertController.Style.alert)

                                                                                       refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                                                         print("Handle Ok logic here")
                                                                                         }))


                                                                                       self.present(refreshAlert, animated: true, completion: nil)
                                            print("More than one documents or NONE")
                                    } else {
                                        
                                        
                                        for document in querySnapshot!.documents {
                                                       
                                                       let data = document.data()
                                                       
                                            self.slpUidd = data["slpUid"] as! String
                                                   }
                                        
                                    
                                        if(self.slpUidd==""){
                                        let document = querySnapshot!.documents.first
                                        document!.reference.updateData([
                                          "slpUid": Auth.auth().currentUser!.uid
                                        ])
                //            self.tableView.reloadData()
                                        self.patientsArray.removeAll()
                                        self.loadData()
                                        
                                        
                                        
                                        
                                                          var refreshAlert = UIAlertController(title: "تمت الإضافة بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)

                                                            refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                              print("Handle Ok logic here")
                                                              }))

                        

                                                            self.present(refreshAlert, animated: true, completion: nil)
                                        
                                        
                                             print("empty id")

                                        }
                                            //linked to another slp
                                        else{
                                            
                                            
                                            Firestore.firestore().collection("slps").whereField("uid", isEqualTo:self.slpUidd).getDocuments { (snapshot, error) in
                                                                            if let error = error {
                                                                                print(error.localizedDescription)
                                                                            } else {
                                                                                if let snapshot = snapshot {

                                                                                    for document in snapshot.documents {
// patientSLP
                                                                                        let data = document.data()
                                                                                        
                                                                                        
                                                                                        UserDefaults.standard.set(data["fname"] as! String, forKey: Constants.linkedSlpFname)
                                                                                                
                                                                                        UserDefaults.standard.set(data["lname"] as! String, forKey: Constants.linkedSlpLname)
                                                                                            
                                                                                        print("NEEEDDDD!!!")
                                                                                                                                   

                                                                                    }
                                                                                    
                                                                                    
                                                                                      let refreshAlert = UIAlertController(title: "إضافة مريض", message:  "هذا المريض مضاف بالفعل للأخصائي" + " "
                                                                                        + UserDefaults.standard.string(forKey: Constants.linkedSlpFname)! + " " + UserDefaults.standard.string(forKey: Constants.linkedSlpLname)! + " " + "هل تود إضافته بالفعل؟"  , preferredStyle: UIAlertController.Style.alert)
                                                                                      
                                                                                      refreshAlert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (action: UIAlertAction!) in
                                                                                    
                                                                                          
                                                                                          print("Handle Ok logic here")
                                                                                                                                  let document = querySnapshot!.documents.first
                                                                                                                                  document!.reference.updateData([
                                                                                                                                    "slpUid": Auth.auth().currentUser!.uid
                                                                                                                                  ])
                                                                                                                                  self.patientsArray.removeAll()
                                                                                                                                  self.loadData()
                                                                                                                                  
                                                                                                                                  
                                                                                                                                  
                                                                                                                                  
                                                                                                                                                    var refreshAlert = UIAlertController(title: "تمت الإضافة بنجاح", message: "", preferredStyle: UIAlertController.Style.alert)

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
                                                                        }
                                             
                                            
                                            print("linked to another slp")
                                    
                                            
                                        }
                                        
                                        
                                    }}

            } else {
                // Text field is empty
                                                  var refreshAlert = UIAlertController(title:"خطأ", message: "لم تقم بإدخال أية رقم" , preferredStyle: UIAlertController.Style.alert)

                                                    refreshAlert.addAction(UIAlertAction(title: "حسنًا", style: .default, handler: { (action: UIAlertAction!) in
                                                      print("Handle Ok logic here")
                                                      }))

                

                                                    self.present(refreshAlert, animated: true, completion: nil)
                
                print("empty id")
            }
            
        }  ))
    
        refreshAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
        // MARK: Segue Method
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "patientDetail",
                let indexPath = tableView?.indexPathForSelectedRow,
                let destinationViewController: DetailViewController = segue.destination as? DetailViewController {
                destinationViewController.patient = patientsArray[indexPath.row]
            }
        }

    
}


