import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct CellData {
    var image: UIImage
    var name: String
    var time: String
    var title: String
}

class timelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var arr = [CellData]()
    
    let db = Firestore.firestore()
    
    
    var teamIDFromFirebase: String = ""
    
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var dataTitleFromFireStore = [Any]()
    
    var dataTimeFromFirestore = [Any]()
    
    var dataNameFromFireStore = [Any]()
    
    @IBOutlet weak var userTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTable.delegate = self
        userTable.dataSource = self
        userTable.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
        
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            let data = document3.data()
            
            self.teamIDFromFirebase = (data!["teamID"] as? String)!
            
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        
                        
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        print(self.arr)
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func timeLineButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            
            let data = document3.data()
            
            self.teamIDFromFirebase = (data!["teamID"] as? String)!
            
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func subscribeButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        
        
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            
            let data = document3.data()
            
            self.teamIDFromFirebase = (data!["teamID"] as? String)!
            
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: false).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents { 
                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        
        
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            
            let data = document3.data()
            
            self.teamIDFromFirebase = (data!["teamID"] as? String)!
            
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTable.dequeueReusableCell(withIdentifier: "cellName", for: indexPath) as! userTableViewCell
        cell.userImage.image = arr[indexPath.row].image
        cell.userName.text = arr[indexPath.row].name
        cell.userTime.text = arr[indexPath.row].time
        cell.userTitle.text = arr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addDiaryButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goDiary", sender: nil)
    }
    
}
