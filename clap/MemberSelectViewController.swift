import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

struct MemberData {
    var image: URL?
    var text: String?
    var userID: String?
}

class MemberSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let statusBsr = UIApplication.shared.statusBarFrame.height
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var memberAddButton: UIButton!
    
    let db = Firestore.firestore()
    var teamIDFromFirebase: String = ""
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var memberData = [MemberData]()
    var bottomSafeAreaHeight: CGFloat = 0
    
    var memberImageArr = [Any]()
    var memberTextArr = [Any]()
    var memberUserIDArr = [Any]()
    var selectedCellData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        let nibName = UINib(nibName: "memberCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "memberCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        memberAddButton.isHidden = true
        getMemberData(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberData.count
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! memberCollectionViewCell
        if indexPath.row < memberData.count {
            let cellData = memberData[indexPath.row]
            cell.memberImage.sd_setImage(with: cellData.image)
            cell.memberTitle.text = cellData.text
            cell.userID.text = cellData.userID
            cell.memberSelectDefaultColor()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! memberCollectionViewCell
        selectedCellData.append(memberData[indexPath.row].userID as! String)
        memberAddButton.isHidden = false
        if selectedCellData.count > 1 {
            cell.isSelected = false
            return
        }
    }
    
    @IBAction func memberAddButtonTapped(_ sender: Any) {
        DispatchQueue.global(qos: .default).async {
            self.setMemberData(member: self.selectedCellData as! [String])
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


private extension MemberSelectViewController {
    private func getMemberData(collectionView: UICollectionView) {
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.db.collection("users").whereField("teamID", isEqualTo: self.teamIDFromFirebase).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        guard var documentData: [String: Any] = document.data() else { return }
                        self.memberImageArr.append((documentData["image"] as? String)!)
                        self.memberTextArr.append((documentData["name"] as? String)!)
                        self.memberUserIDArr.append((documentData["userID"] as? String)!)
                        self.memberData.append(MemberData(image: URL(string: self.memberImageArr[i] as! String), text: self.memberTextArr[i] as! String, userID: self.memberUserIDArr[i] as! String))
                        i += 1
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setMemberData(member: [String]) {
        let memberIDPerse = member[0]
        
        self.db.collection("users").document(memberIDPerse).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            let memberImage = data["image"] as? String ?? ""
            let memberName = data["name"] as? String ?? ""
            let setData = [
                "image": memberImage,
                "userID": memberIDPerse,
                "name": memberName,
            ]
            self.db.collection("group").document(self.teamIDFromFirebase).collection(self.fireAuthUID).document(memberIDPerse).setData(setData) { err in
                if err != nil {
                    return
                } else {
                    print("success")
                }
            }
        }
    }
}
