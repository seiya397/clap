import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

struct GroupData {
    var image: URL?
    var text: String?
    var userID: String?
}

struct DiaryData {
    var title: String?
    var diaryID: String?
    var content1: String?
    var content2: String?
    var content3: String?
    var content4: String?
    var content5: String?
    
    init(title: String, diaryID: String, content1: String, content2: String, content3: String, content4: String, content5: String) {
        self.title = title
        self.diaryID = diaryID
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
    }
    
    init?(dictionary : [String:String]) {
        guard let title = dictionary["title"],
                let diaryID = dictionary["artist"],
                let content1 = dictionary["content1"],
                let content2 = dictionary["content2"],
                let content3 = dictionary["content3"],
                let content4 = dictionary["content4"],
                let content5 = dictionary["content5"]
            else { return nil }
        self.init(
              title: title,
              diaryID: diaryID,
              content1: content1,
              content2: content2,
              content3: content3,
              content4: content4,
              content5: content5
        )
    }
    var propertyListRepresentation : [String:String] {
        return ["title" : title!, "diaryID" : diaryID!, "content1": content1!, "content2": content2!, "content3": content3!, "content4": content4!, "content5": content5!]
    }
}


class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    var teamIDFromFirebase: String = ""
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var userDefaults = UserDefaults.standard
    
    var groupData = [GroupData]()
    var groupImageArr = [Any]()
    var groupTextArr = [Any]()
    var groupUserIDArr = [Any]()
    
    var diaryData = [DiaryData]()
    var memberNewDiaryTitle = [Any]()
    var memberNewDiaryID = [Any]()
    var memberNewDiaryContent1 = [Any]()
    var memberNewDiaryContent2 = [Any]()
    var memberNewDiaryContent3 = [Any]()
    var memberNewDiaryContent4 = [Any]()
    var memberNewDiaryContent5 = [Any]()
    
    @IBOutlet weak var memberCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        memberCollection.backgroundColor = UIColor.white
        let nibName = UINib(nibName: "memberCollectionViewCell", bundle: nil)
        memberCollection.register(nibName, forCellWithReuseIdentifier: "memberCell")
        memberCollection.delegate = self
        memberCollection.dataSource = self
        getGroupData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberCollection.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! memberCollectionViewCell
        let cellData = groupData[indexPath.row]
        cell.memberImage.sd_setImage(with: cellData.image)
        cell.memberTitle.text = cellData.text
        cell.userID.text = cellData.userID
        cell.groupDefaultColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = groupData[indexPath.row]
        let userID = cellData.userID
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubmitedNewDiaryViewController") as! SubmitedNewDiaryViewController
        DispatchQueue.global(qos: .default).async {
            self.getDiaryData(userID: userID!)
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.size.width / 4
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset =  (self.view.frame.width / 4) / 5
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 4) / 5
    }
    
    @IBAction func memberAddButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goMemberSelect", sender: nil)
    }
    
}

private extension GroupViewController {
    private func getGroupData() {
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print(String(describing: error))
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.db.collection("group").document(self.teamIDFromFirebase).collection(self.fireAuthUID).getDocuments(completion: { (querySnapshot, err) in
                if err != nil {
                    print(String(describing: err))
                    return
                } else {
                    
                    var i = 0
                    for document in querySnapshot!.documents {
                        guard var documentData: [String: Any] = document.data() else { return }
                        print(documentData)
                        self.groupImageArr.append((documentData["image"] as? String)!)
                        self.groupTextArr.append((documentData["name"] as? String)!)
                        self.groupUserIDArr.append((documentData["userID"] as? String)!)
                        self.groupData.append(GroupData(image: URL(string: self.groupImageArr[i] as! String), text: self.groupTextArr[i] as! String, userID: self.groupUserIDArr[i] as! String))
                        i += 1
                    }
                    self.memberCollection.reloadData()
                }
            })
        }
    }
    
    func getDiaryData(userID: String) {
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print(String(describing: error))
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            let newSubmitDate = self.getNewSubmitDate()
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("userID", isEqualTo: userID).whereField("submit", isEqualTo: true).whereField("date", isEqualTo: newSubmitDate).getDocuments(completion: { (query, err) in
                if err != nil {
                    return
                } else {
                    var i = 0
                    for document in query!.documents {
                        guard var documentData: [String: Any] = document.data() else { return }
                        self.memberNewDiaryTitle.append(documentData["今日のタイトル"] as? String ?? "NO DATA")
                        self.memberNewDiaryID.append(documentData["diaryID"] as? String ?? "NO DATA")
                        self.memberNewDiaryContent1.append(documentData["ここが良かった！今日の自分"] as? String ?? "NO DATA")
                        self.memberNewDiaryContent2.append(documentData["こんな練習してみたい"] as? String ?? "NO DATA")
                        self.memberNewDiaryContent3.append(documentData["メンバーのここを褒めたい"] as? String ?? "NO DATA")
                        self.memberNewDiaryContent4.append(documentData["今日のタイトル"] as? String ?? "NO DATA")
                        self.memberNewDiaryContent5.append(documentData["考えました明日の課題"] as? String ?? "NO DATA")
                        
                        self.diaryData.append(DiaryData(title: self.memberNewDiaryTitle[i] as! String, diaryID: self.memberNewDiaryID[i] as! String, content1: self.memberNewDiaryContent1[i] as! String, content2: self.memberNewDiaryContent2[i] as! String, content3: self.memberNewDiaryContent3[i] as! String, content4: self.memberNewDiaryContent4[i] as! String, content5: self.memberNewDiaryContent5[i] as! String))
                        i += 1
                    }
                    let propertylistSongs = self.diaryData.map{ $0.propertyListRepresentation }
                    self.userDefaults.set(propertylistSongs, forKey: "MyDiaryData")
                    self.userDefaults.synchronize()
                }
            })
        }
    }
    func getNewSubmitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let now = Date()
        return formatter.string(from: now)
    }
}

////structで定義したプロパティをdictionaryとして保管
//private extension NSDictionary{
//    convenience init(_ data: DiaryData){
//        let dic = [
//                   "title": data.title,
//                   "diaryID": data.diaryID,
//                   "content1": data.content1,
//                   "content2": data.content2,
//                   "content3": data.content3,
//                   "content4": data.content4,
//                   "content5": data.content5,
//                   ]
//        self.init(dictionary: dic as [AnyHashable : Any])
//    }
//}
//
////dictionaryとして保管したstructのデータを次は、dictionarydataとしてstructのextensionプロパティに保管
//private extension DiaryData{
//    init(_ dic:NSDictionary){
//        let title = dic["title"] as? String ?? "NO DATA"
//        let diaryID = dic["diaryID"] as? String ?? "NO DATA"
//        let content1 = dic["content1"] as? String ?? "NO DATA"
//        let content2 = dic["content2"] as? String ?? "NO DATA"
//        let content3 = dic["content3"] as? String ?? "NO DATA"
//        let content4 = dic["content4"] as? String ?? "NO DATA"
//        let content5 = dic["content5"] as? String ?? "NO DATA"
//        self.init(
//                  title: title,
//                  diaryID: diaryID,
//                  content1: content1,
//                  content2: content2,
//                  content3: content3,
//                  content4: content4,
//                  content5: content5
//                  )
//    }
//}
//
//
//extension UserDefaults {
//    var logDataArray:[DiaryData]{
//        set(datas){
//            let newDatas:[NSDictionary] = datas.map{ NSDictionary.init($0) }
//            self.set(newDatas,forKey:"MyDiaryData")
//        }
//        get{
//            // NSDictionaryの配列として、データを取得
//            let datas = self.object(forKey: "MyDiaryData") as? [NSDictionary] ?? []
//            return datas.map{ DiaryData.init($0) }
//        }
//    }
//}
