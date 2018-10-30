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
}

class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    var teamIDFromFirebase: String = ""
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var groupData = [GroupData]()
    var groupImageArr = [Any]()
    var groupTextArr = [Any]()
    var groupUserIDArr = [Any]()
    
    var diaryData = [DiaryData]()
    var memberNewDiaryTitle = [Any]()
    var memberNewDiaryID = [Any]()
    
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
        getDiaryData(userID: userID!)
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
                        self.memberNewDiaryTitle.append(documentData["今日のタイトル"] as? String ?? "未提出")
                        self.memberNewDiaryID.append(documentData["diaryID"] as? String ?? "")
                        self.diaryData.append(DiaryData(title: self.memberNewDiaryTitle[i] as! String, diaryID: self.memberNewDiaryID[i] as! String))
                        i += 1
                    }
                    
                    print("==================")
                    print(self.diaryData)
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

