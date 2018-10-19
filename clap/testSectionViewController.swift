import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage
//
//struct HeadLine {
//    var date: Date
//    var time: String
//    var title: String
//    var name: String
//    var image: URL
//}
//
//struct TableSection<SectionItem: Comparable&Hashable, RowItem>: Comparable {
//    var sectionItem: SectionItem
//    var rowItems: [RowItem]
//
//    static func < (lhs: TableSection, rhs: TableSection) -> Bool {
//        return lhs.sectionItem > rhs.sectionItem
//    }
//
//
//    static func == (lhs: TableSection, rhs: TableSection) -> Bool {
//        return lhs.sectionItem == rhs.sectionItem
//    }
//
//    static func group(rowItems : [RowItem], by criteria : (RowItem) -> SectionItem ) -> [TableSection<SectionItem, RowItem>] {
//        let groups = Dictionary(grouping: rowItems, by: criteria)
//        return groups.map(TableSection.init(sectionItem:rowItems:)).sorted()
//    }
//}
//
//fileprivate func parseDate(_ str: String) -> Date {
//    let dateFormat = DateFormatter()
//    dateFormat.dateFormat = "yyyy/MM/dd"
//    return dateFormat.date(from: str)!
//}
//
//fileprivate func firstDayOfMonth(date: Date) -> Date {
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.year, .month, .day], from: date)
//    return calendar.date(from: components)!
//}
//

//class testSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//
//    @IBOutlet weak var testTableView: UITableView!
//
//    var headlines = [HeadLine]()
//
////    var sections = [TableSection<Date, HeadLine>]()
//
////    let db = Firestore.firestore()
//
//    var teamIDFromFirebase: String = ""
//
////    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        testTableView.delegate = self
//        testTableView.dataSource = self
//
//        testTableView.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
//
//        headlines = [
//            HeadLine(date: parseDate("2018/7/21/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//            HeadLine(date: parseDate("2018/7/21/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//            HeadLine(date: parseDate("2017/7/21/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//            HeadLine(date: parseDate("2018/7/21/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//            HeadLine(date: parseDate("2018/7/20/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//            HeadLine(date: parseDate("2018/5/21/"), time: "20:20", title: "title1", name: "オムラ", image: URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")!),
//        ]
//
//        self.sections = TableSection.group(rowItems: self.headlines, by: { (headline) in
//            firstDayOfMonth(date: headline.date)
//        })
//
//
//
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.sections.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = self.sections[section]
//        let date = section.sectionItem
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = " yyyy年MM月dd日"
//        return dateFormatter.string(from: date)
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let section = self.sections[section]
//        return section.rowItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = testTableView.dequeueReusableCell(withIdentifier: "cellName", for: indexPath) as! userTableViewCell
//        let section = self.sections[indexPath.section]
//        let headline = section.rowItems[indexPath.row]
//        cell.userTitle?.text = headline.title
//        cell.userName?.text = headline.name
//        cell.userTime?.text = headline.time
//        cell.userImage?.sd_setImage(with: headline.image)
//        return cell
//
//    }
//
//
//}


//
//class timelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//

//
//    var dataImageFromFirestore = [Any]()
//
//    var dataTitleFromFireStore = [Any]()
//
//    var dataTimeFromFirestore = [Any]()
//
//    var dataNameFromFireStore = [Any]()
//
//    var timelineDocumentIdArr = [Any]()
//
//    var draftDocumentIdArr = [Any]()
//
//    var submitDocumentIdArr = [Any]()
//
//    var selectedNum = 0
//
//
//    @IBOutlet weak var circleButton: UIButton!
//
//    @IBOutlet weak var userTable: UITableView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        circleButton = Circle()
//
//        if arr != nil {
//            self.arr = []
//            self.dataNameFromFireStore = [Any]()
//            self.dataTimeFromFirestore = [Any]()
//            self.dataTitleFromFireStore = [Any]()
//            self.dataImageFromFirestore = [Any]()
//            self.submitDocumentIdArr = [Any]()
//
//            self.selectedNum = 1
//
//            userTable.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
//
//            self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
//                guard let document3 = snapshot3 else {
//                    print("erorr2 \(String(describing: error))")
//                    return
//                }
//                guard let data = document3.data() else { return }
//
//                self.teamIDFromFirebase = data["teamID"] as? String ?? ""
//                self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                        return self.arr = [CellData(image:URL(string: "")!, name: "", time: "", title: "")]
//                    } else {
//                        var i = 0
//                        for document in querySnapshot!.documents {
//                            self.timelineDocumentIdArr.append(document.documentID)
//
//                            guard let documentData: [String: Any] = document.data() else { return }
//                            self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
//                            self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
//                            self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
//                            self.dataImageFromFirestore.append((documentData["image"] as? String)!)
//                            self.arr.append(CellData(image: URL(string: self.dataImageFromFirestore[i] as! String)!, name: self.dataNameFromFireStore[i] as? String ?? "", time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? ""))
//                            print(self.arr)
//
//                            i += 1
//
//                        }
//                        self.userTable.reloadData()
//                    }
//                }
//            }
//        }
//    }
//
//
//    @IBAction func timeLineButton(_ sender: Any) {
//        self.arr = []
//        self.dataNameFromFireStore = [Any]()
//        self.dataTimeFromFirestore = [Any]()
//        self.dataTitleFromFireStore = [Any]()
//        self.dataImageFromFirestore = [Any]()
//        self.timelineDocumentIdArr = [Any]()
//
//        self.selectedNum = 1
//
//        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
//            guard let document3 = snapshot3 else {
//                print("erorr2 \(String(describing: error))")
//                return
//            }
//
//            guard let data = document3.data() else { return }
//
//            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
//
//            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    return self.arr = [CellData(image:URL(string: "")!, name: "", time: "", title: "")]
//                } else {
//                    var i = 0
//                    for document in querySnapshot!.documents {
//
//                        self.timelineDocumentIdArr.append(document.documentID)
//
//                        guard let documentData: [String: Any] = document.data() else { return }
//                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
//                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
//                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
//                        self.dataImageFromFirestore.append((documentData["image"] as? String)!)
//                        self.arr.append(CellData(image: URL(string: self.dataImageFromFirestore[i] as! String)!, name: self.dataNameFromFireStore[i] as? String ?? "", time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? ""))
//
//                        i += 1
//
//                    }
//                    self.userTable.reloadData()
//                }
//            }
//        }
//    }
//
//
//    @IBAction func subscribeButton(_ sender: Any) {
//        self.arr = []
//        self.dataNameFromFireStore = [Any]()
//        self.dataTimeFromFirestore = [Any]()
//        self.dataTitleFromFireStore = [Any]()
//        self.dataImageFromFirestore = [Any]()
//        self.draftDocumentIdArr = [Any]()
//
//        self.selectedNum = 2
//
//
//        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
//            guard let document3 = snapshot3 else {
//                print("erorr2 \(String(describing: error))")
//                return
//            }
//
//            guard let data = document3.data() else { return }
//
//            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
//
//
//            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: false).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    return self.arr = [CellData(image:URL(string: "")!, name: "", time: "", title: "")]
//                } else {
//                    var i = 0
//                    for document in querySnapshot!.documents {
//
//                        self.draftDocumentIdArr.append(document.documentID)
//
//                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
//                        let documentData = document.data()
//                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
//                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
//                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
//                        self.dataImageFromFirestore.append((documentData["image"] as? String)!)
//                        self.arr.append(CellData(image: URL(string: self.dataImageFromFirestore[i] as! String)!, name: self.dataNameFromFireStore[i] as? String ?? "", time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? ""))
//
//                        i += 1
//
//                    }
//                    self.userTable.reloadData()
//                }
//            }
//        }
//    }
//
//
//    @IBAction func submitButton(_ sender: Any) {
//        self.arr = []
//        self.dataNameFromFireStore = [Any]()
//        self.dataTimeFromFirestore = [Any]()
//        self.dataTitleFromFireStore = [Any]()
//        self.dataImageFromFirestore = [Any]()
//        self.submitDocumentIdArr = [Any]()
//
//        self.selectedNum = 3
//
//
//        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
//            guard let document3 = snapshot3 else {
//                print("erorr2 \(String(describing: error))")
//                return
//            }
//
//            guard let data = document3.data() else { return }
//
//            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
//            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    return self.arr = [CellData(image:URL(string: "")!, name: "", time: "", title: "")]
//                } else {
//                    var i = 0
//                    for document in querySnapshot!.documents {
//
//                        self.submitDocumentIdArr.append(document.documentID)
//
//                        print("成功成功成功成功成功\(document.documentID) => \(document.data())")
//                        let documentData = document.data()
//                        self.dataTitleFromFireStore.append((documentData["今日のタイトル"] as? String)!)
//                        self.dataTimeFromFirestore.append((documentData["time"] as? String)!)
//                        self.dataNameFromFireStore.append((documentData["userName"] as? String)!)
//                        self.dataImageFromFirestore.append((documentData["image"] as? String)!)
//                        self.arr.append(CellData(image: URL(string: self.dataImageFromFirestore[i] as! String)!, name: self.dataNameFromFireStore[i] as? String ?? "", time: self.dataTimeFromFirestore[i] as? String ?? "", title: self.dataTitleFromFireStore[i] as? String ?? ""))
//
//                        i += 1
//
//                    }
//                    self.userTable.reloadData()
//                }
//            }
//        }
//    }
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arr.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = userTable.dequeueReusableCell(withIdentifier: "cellName", for: indexPath) as! userTableViewCell
//        cell.userImage.sd_setImage(with: arr[indexPath.row].image)
//        cell.userName.text = arr[indexPath.row].name
//        cell.userTime.text = arr[indexPath.row].time
//        cell.userTitle.text = arr[indexPath.row].title
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.selectedNum == 1 {
//            let userDefaults:UserDefaults = UserDefaults.standard
//            userDefaults.removeObject(forKey: "goTimeline")
//            userDefaults.set(self.timelineDocumentIdArr[indexPath.row], forKey: "goTimeline")
//            userDefaults.synchronize()
//            self.performSegue(withIdentifier: "goTimeline", sender: nil)
//        } else if self.selectedNum == 2 {
//            let userDefaults:UserDefaults = UserDefaults.standard
//            userDefaults.removeObject(forKey: "goDraft")
//            userDefaults.set(self.draftDocumentIdArr[indexPath.row], forKey: "goDraft")
//            userDefaults.synchronize()
//            self.performSegue(withIdentifier: "goDraft", sender: nil)
//        } else if self.selectedNum == 3 {
//            let userDefaults:UserDefaults = UserDefaults.standard
//            userDefaults.removeObject(forKey: "goSubmit")
//            userDefaults.set(self.submitDocumentIdArr[indexPath.row], forKey: "goSubmit")
//            userDefaults.synchronize()
//            self.performSegue(withIdentifier: "goSubmit", sender: nil)
//        }
//    }
//
//    @IBAction func addDiaryButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "goDiary", sender: nil)
//    }
//
//}
//
//class Circle: UIButton {
//    @IBInspectable var borderColor :  UIColor = UIColor.black
//    @IBInspectable var borderWidth :  CGFloat = 0.1
//
//    var button: UIButton? {
//        didSet{
//            layer.masksToBounds = false
//            layer.borderColor = borderColor.cgColor
//            layer.borderWidth = borderWidth
//            layer.cornerRadius = frame.height/2
//            clipsToBounds = true
//        }
//    }
//}
