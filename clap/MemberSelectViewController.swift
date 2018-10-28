import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

struct MemberData {
    var image: URL?
    var text: String?
}

class MemberSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let statusBsr = UIApplication.shared.statusBarFrame.height
    
    let db = Firestore.firestore()
    var teamIDFromFirebase: String = ""
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var memberData = [MemberData]()
    
    var memberImageArr = [Any]()
    var memberTextArr = [Any]()
    var memberUserIDArr = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: statusBsr, width: self.view.frame.width, height: self.view.frame.size.height - statusBsr), collectionViewLayout: UICollectionViewFlowLayout())
        
        let nibName = UINib(nibName: "memberCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "memberCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        getMemberData(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
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
            let cellData = memberData[indexPath.row]
            cell.memberImage.sd_setImage(with: cellData.image)
            cell.memberTitle.text = cellData.text
        return cell
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
                        self.memberData.append(MemberData(image: URL(string: self.memberImageArr[i] as! String), text: self.memberTextArr[i] as! String))
                        i += 1
                    }
                }
            }
        }
    }
}
