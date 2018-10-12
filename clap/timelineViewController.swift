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
    
    var timelineDocumentIdArr = [Any]()
    
    var draftDocumentIdArr = [Any]()
    
    var submitDocumentIdArr = [Any]()
    
    var selectedNum = 0
    
    
    @IBOutlet weak var circleButton: UIButton!
    
    @IBOutlet weak var userTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleButton = Circle()
        
        if arr != nil {
            self.arr = []
            self.dataNameFromFireStore = [Any]()
            self.dataTimeFromFirestore = [Any]()
            self.dataTitleFromFireStore = [Any]()
            self.submitDocumentIdArr = [Any]()
            
            self.selectedNum = 1
            
            userTable.delegate = self
            userTable.dataSource = self
            userTable.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
            
            self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
                guard let document3 = snapshot3 else {
                    print("erorr2 \(String(describing: error))")
                    return
                }
                guard let data = document3.data() else { return }
                
                self.teamIDFromFirebase = data["teamID"] as? String ?? ""
                
                self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var i = 0
                        for document in querySnapshot!.documents {
                            self.timelineDocumentIdArr.append(document.documentID)
                            
                            let documentData = document.data()
                            self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                            self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                            self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                            self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                            print(self.arr)
                            
                            i += 1
                            
                        }
                        self.userTable.reloadData()
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        print(self.timelineDocumentIdArr)
                    }
                }
            }
        } else {
            return arr = [CellData(image: UIImage(named: "")!, name: "", time: "", title: "")]
        }
    }
    
    
    @IBAction func timeLineButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        self.timelineDocumentIdArr = [Any]()
        
        self.selectedNum = 1
        
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
                        
                        self.timelineDocumentIdArr.append(document.documentID)
                        
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print(self.timelineDocumentIdArr)
                }
            }
        }
    }
    
    
    @IBAction func subscribeButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        self.draftDocumentIdArr = [Any]()
        
        self.selectedNum = 2
        
        
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
                        
                        self.draftDocumentIdArr.append(document.documentID)
                        
                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print(self.draftDocumentIdArr)
                }
            }
        }
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = [Any]()
        self.dataTimeFromFirestore = [Any]()
        self.dataTitleFromFireStore = [Any]()
        self.submitDocumentIdArr = [Any]()
        
        self.selectedNum = 3
        
        
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
                        
                        self.submitDocumentIdArr.append(document.documentID)
                        
                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.arr.append(CellData(image: UIImage(named: "weight")!, name: self.dataNameFromFireStore[i] as! String, time: self.dataTimeFromFirestore[i] as! String, title: self.dataTitleFromFireStore[i] as! String))
                        
                        i += 1
                        
                    }
                    self.userTable.reloadData()
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print(self.submitDocumentIdArr)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedNum == 1 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goTimeline")
            userDefaults.set(self.timelineDocumentIdArr[indexPath.row], forKey: "goTimeline")
            userDefaults.synchronize()
            print("????????????????????????????")
            print(self.timelineDocumentIdArr[indexPath.row])
            self.performSegue(withIdentifier: "goTimeline", sender: nil)
        } else if self.selectedNum == 2 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goDraft")
            userDefaults.set(self.draftDocumentIdArr[indexPath.row], forKey: "goDraft")
            userDefaults.synchronize()
            print("????????????????????????????")
            print(self.draftDocumentIdArr[indexPath.row])
            self.performSegue(withIdentifier: "goDraft", sender: nil)
        } else if self.selectedNum == 3 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goSubmit")
            userDefaults.set(self.submitDocumentIdArr[indexPath.row], forKey: "goSubmit")
            userDefaults.synchronize()
            print("????????????????????????????")
            print(self.submitDocumentIdArr[indexPath.row])
            self.performSegue(withIdentifier: "goSubmit", sender: nil)
        }
    }
    
    @IBAction func addDiaryButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goDiary", sender: nil)
    }
    
}

class Circle: UIButton {
    @IBInspectable var borderColor :  UIColor = UIColor.black
    @IBInspectable var borderWidth :  CGFloat = 0.1
    
    var button: UIButton? {
        didSet{
            layer.masksToBounds = false
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = frame.height/2
            clipsToBounds = true
        }
    }
}
