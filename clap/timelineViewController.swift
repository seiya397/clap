import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

struct CellData {
    var date: Date
    var time: String
    var title: String
    var name: String
    var image: URL
    var diaryID: String
}

class timelineViewController: UIViewController {

    var arr = [CellData]()
    let db = Firestore.firestore()
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var sections = [TableSection<Date, CellData>]()
    
    var teamIDFromFirebase: String = ""
    var dataImageFromFirestore = [Any]()
    var dataTitleFromFireStore = [Any]()
    var dataTimeFromFirestore = [Any]()
    var dataNameFromFireStore = [Any]()
    var dataDateFromFiewstore = [Any]()
    var timelineDocumentIdArr = [Any]()
    var draftDocumentIdArr = [Any]()
    var submitDocumentIdArr = [Any]()

    var selectedNum = 0

    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var userTable: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        if arr != nil {
            self.arr = [CellData]()
            self.dataNameFromFireStore = [Any]()
            self.dataTimeFromFirestore = [Any]()
            self.dataTitleFromFireStore = [Any]()
            self.dataImageFromFirestore = [Any]()
            self.dataDateFromFiewstore = [Any]()
            self.submitDocumentIdArr = [Any]()
            self.sections = [TableSection<Date, CellData>]()
            
            self.selectedNum = 1
            
            mustSbscribe()
            navColor()
            displayTimelineInfo()
        }
    }


    @IBAction func timeLineButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.dataDateFromFiewstore = []
        self.sections = []
        
        self.selectedNum = 1
        
        displayTimelineInfo()
    }


    @IBAction func subscribeButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.dataDateFromFiewstore = []
        self.sections = []
        
        self.selectedNum = 2

        displaySubmitOrSubscriptInfo(bool: false)
    }


    @IBAction func submitButton(_ sender: Any) {
        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.dataDateFromFiewstore = []
        self.sections = []

        self.selectedNum = 3
        
        displaySubmitOrSubscriptInfo(bool: true)
    }
    
    @IBAction func addDiaryButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goDiary", sender: nil)
    }
    
}


extension timelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func mustSbscribe() {
        userTable.delegate = self
        
        userTable.dataSource = self
        
        userTable.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        
        let date = section.sectionItem
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        
        return section.rowItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTable.dequeueReusableCell(withIdentifier: "cellName", for: indexPath) as! userTableViewCell
        
        let section = self.sections[indexPath.section]
        
        let cellDetail = section.rowItems[indexPath.row]
        
        cell.userTitle.text = cellDetail.title
        
        cell.userName.text = cellDetail.name
        
        cell.userTime.text = cellDetail.time
        
        cell.userImage.sd_setImage(with: cellDetail.image)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.sections[indexPath.section]
        
        let cellDetail = section.rowItems[indexPath.row]
        
        if self.selectedNum == 1 {
            
            Destination(segue: "goTimeline", cellDetail: cellDetail)
            
        } else if self.selectedNum == 2 {
            
            Destination(segue: "goDraft", cellDetail: cellDetail)
            
        } else if self.selectedNum == 3 {
            
            Destination(segue: "goSubmit", cellDetail: cellDetail)
            
        }
    }
}


private extension timelineViewController {
    private func displayTimelineInfo() {
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
                    return self.arr = [CellData(date: parseDate(""), time: "", title: "", name: "", image:URL(string: "")!, diaryID: "")]
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        
                        
                        
                        guard let documentData: [String: Any] = document.data() else { return }
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.dataImageFromFirestore.append((documentData["image"] as? String)!)
                        self.dataDateFromFiewstore.append((documentData["date"] as? String)!)
                        self.timelineDocumentIdArr.append((documentData["diaryID"] as? String)!)
                        
                        self.arr.append(CellData(date: parseDate(self.dataDateFromFiewstore[i] as! String), time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? "", name: self.dataNameFromFireStore[i] as? String ?? "", image: URL(string: self.dataImageFromFirestore[i] as! String)!, diaryID: self.timelineDocumentIdArr[i] as! String))
                        
                        i += 1
                        
                        self.sections = TableSection.group(rowItems: self.arr, by: { (headline) in
                            firstDayOfMonth(date: headline.date)
                        })
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    private func displaySubmitOrSubscriptInfo(bool: Bool) {
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            
            guard let data = document3.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: bool).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return self.arr = [CellData(date: parseDate(""), time: "", title: "", name: "", image:URL(string: "")!, diaryID: "")]
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        
                        self.submitDocumentIdArr.append(document.documentID)
                        
                        let documentData = document.data()
                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
                        self.dataImageFromFirestore.append((documentData["image"] as? String)!)
                        
                        self.dataDateFromFiewstore.append((documentData["date"] as? String)!)
                        
                        self.timelineDocumentIdArr.append((documentData["diaryID"] as? String)!)
                        
                        self.arr.append(CellData(date: parseDate(self.dataDateFromFiewstore[i] as! String), time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? "", name: self.dataNameFromFireStore[i] as? String ?? "", image: URL(string: self.dataImageFromFirestore[i] as! String)!, diaryID: self.timelineDocumentIdArr[i] as! String))
                        
                        i += 1
                        self.sections = TableSection.group(rowItems: self.arr, by: { (headline) in
                            firstDayOfMonth(date: headline.date)
                        })
                    }
                    self.userTable.reloadData()
                }
            }
        }
    }
    
    func Destination(segue: String, cellDetail: CellData) {
        let userDefaults:UserDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: segue)
        
        userDefaults.set(cellDetail.diaryID, forKey: segue)
        
        userDefaults.synchronize()
        
        self.performSegue(withIdentifier: segue, sender: nil)
    }
    
    
    func navColor() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 82/255, blue: 212/255, alpha: 100)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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




struct TableSection<SectionItem: Comparable&Hashable, RowItem>: Comparable {
    var sectionItem: SectionItem
    var rowItems: [RowItem]
    
    static func < (lhs: TableSection, rhs: TableSection) -> Bool {
        return lhs.sectionItem > rhs.sectionItem
    }
    
    static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        return lhs.sectionItem == rhs.sectionItem
    }
    
    static func group(rowItems : [RowItem], by criteria : (RowItem) -> SectionItem ) -> [TableSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rowItems, by: criteria)
        return groups.map(TableSection.init(sectionItem:rowItems:)).sorted()
    }
}




fileprivate func parseDate(_ str: String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy年MM月dd日"
    return dateFormat.date(from: str)!
}




fileprivate func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}
