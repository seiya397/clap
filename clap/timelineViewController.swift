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

//バグ内容
//SectionHeaderのバグです。
//具体的にいうと、日記登録画面で提出ボタンをタップすると、確かに日記は登録されるのですが、日付な並び順がおかしくなります(例　11月5日に提出すると、10月20日の提出として表示される)。しかし、もう一度ログインし直すと、表示が正常の状態になります。恐らくSectionHeaderを定義しているこの行目からが問題だと思うのですが、ご意見をいただきたいです。

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





class timelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var arr = [CellData]()

    let db = Firestore.firestore()
    
    var sections = [TableSection<Date, CellData>]()

    var teamIDFromFirebase: String = ""

    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")

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

        circleButton = Circle()

        if arr != nil {
            self.arr = [CellData]()
            self.dataNameFromFireStore = [Any]()
            self.dataTimeFromFirestore = [Any]()
            self.dataTitleFromFireStore = [Any]()
            self.dataImageFromFirestore = [Any]()
            self.submitDocumentIdArr = [Any]()
            self.sections = [TableSection<Date, CellData>]()

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
    }


    @IBAction func timeLineButton(_ sender: Any) {
        //日記詳細画面の”内容”についてのバグです。
        //tableViewに表示されているcellをタップした時に、その詳細を見れるページを用意しています。ログインをして日記ページに行き、タイムラインとして表示されている日記をどれでもいいのでタップすると、その時はしっかりと想定内の内容が詳細画面として表示されるのですが、問題はこのあとです。例えば、日記ページ上に"タイムライン", "下書き", "提出済"ボタンがあるのですが、"下書き"をタップして、その後"タイムライン"に戻りtableViewのcellをタップすると想定外の内容が表示されます(一つ一つの日記にdiaryIDを設定しているのですが、恐らくこのdiaryIDがズレている可能性があります)。アドバイスをいただきたいです。
        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.sections = []
        
        self.selectedNum = 1

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

                        self.timelineDocumentIdArr.append(document.documentID)

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


    @IBAction func subscribeButton(_ sender: Any) {

        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.sections = []
        
        self.selectedNum = 2


        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }

            guard let data = document3.data() else { return }

            self.teamIDFromFirebase = data["teamID"] as? String ?? ""


            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: false).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return self.arr = [CellData(date: parseDate(""), time: "", title: "", name: "", image:URL(string: "")!, diaryID: "")]
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {

                        self.draftDocumentIdArr.append(document.documentID)

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


    @IBAction func submitButton(_ sender: Any) {
        
        self.arr = []
        self.dataNameFromFireStore = []
        self.dataTimeFromFirestore = []
        self.dataTitleFromFireStore = []
        self.dataImageFromFirestore = []
        self.timelineDocumentIdArr = []
        self.sections = []

        self.selectedNum = 3


        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }

            guard let data = document3.data() else { return }

            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).whereField("userID", isEqualTo: self.fireAuthUID).getDocuments() { (querySnapshot, err) in
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
        return 79.5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.sections[indexPath.section]
        let cellDetail = section.rowItems[indexPath.row]
        if self.selectedNum == 1 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goTimeline")
            userDefaults.set(cellDetail.diaryID, forKey: "goTimeline")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "goTimeline", sender: nil)
        } else if self.selectedNum == 2 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goDraft")
            userDefaults.set(cellDetail.diaryID, forKey: "goDraft")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "goDraft", sender: nil)
        } else if self.selectedNum == 3 {
            let userDefaults:UserDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "goSubmit")
            userDefaults.set(cellDetail.diaryID, forKey: "goSubmit")
            userDefaults.synchronize()
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
