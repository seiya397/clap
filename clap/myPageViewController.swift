import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI


class myPageViewController: UIViewController{
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!
    @IBOutlet weak var userImge: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var selectedPhoto = UIImage()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImge.layer.cornerRadius = userImge.frame.size.width / 2
        userImge.clipsToBounds = true

        // Do any additional setup after loading the view.
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        self.teamIDLabel.text = teamID //チームID表示
        
        db.collection("teams").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(String(describing: error))")
                return
            }
            let data = document.data()
            print("このデータは \(String(describing: data!["belong"]))")
            self.teamName.text = data!["belong"] as? String //チーム名表示
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            let data = document2.data()
            print("この名前は \(String(describing: data!["name"]))")
            self.userName.text = data!["name"] as? String //ユーザー名表示
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            let data = document3.data()
            print("この名前は \(String(describing: data!["role"]))")
            self.userRole.text = data!["role"] as? String //ユーザー名表示
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(myPageViewController.selectPhoto(_:)))
        
        tap.numberOfTapsRequired = 1
        
        self.userImge.addGestureRecognizer(tap)
        
        let storageReference = Storage.storage().reference()
        print("ここまで動いている１＝＝＝＝＝＝＝＝＝＝＝")
        let profileImageDownloadedURLReference = storageReference.child("users/\(Auth.auth().currentUser?.uid ?? " ")/profileImage.jpg")
        print("ここまで動いている２＝＝＝＝＝＝＝＝＝＝＝")
        let placeholderImage = UIImage(named: "placeholder.jpg")
        userImge.sd_setImage(with: profileImageDownloadedURLReference, placeholderImage: placeholderImage)
        print("ここまで動いている３＝＝＝＝＝＝＝＝＝＝＝")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("ログアウトできました")
            let fireAuthUID2 = (Auth.auth().currentUser?.uid ?? "no data")
            print("ログアウト後\(fireAuthUID2)")
            let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginPage, animated: true, completion: nil)
        } catch {
            print("ログアウトできませんでした")
        }
    }
    
    @objc func selectPhoto(_ tap: UITapGestureRecognizer) {
        self.imagePicker.delegate = self
        self.imagePicker.isEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
        } else {
            self.imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension myPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selected = info[UIImagePickerControllerOriginalImage] as? UIImage, let optimizedImageData = UIImageJPEGRepresentation(selected, 0.8) {
            uploadFileImage(imageData: optimizedImageData)
            
            self.userImge.image = selected
        } else {
            print("error")
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadFileImage(imageData: Data) {
        let activeIndicater = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activeIndicater.startAnimating()
        activeIndicater.center = self.view.center
        self.view.addSubview(activeIndicater)
        let reference = Storage.storage().reference()
        let UidForPath = (Auth.auth().currentUser?.uid ?? "no data")
        let profileImageRef = reference.child("users").child(UidForPath).child("profileImage.jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        profileImageRef.putData(imageData, metadata: uploadMetadata) { (metaData, error) in
            activeIndicater.stopAnimating()
            activeIndicater.removeFromSuperview()
            if error != nil {
                print("画像のアップロードに失敗")
                return
            } else {
                print("画像のアップロードに成功\(String(describing: metaData))")
                
            }
        }
    }
    
    //アップした画像を引っ張る　永続化　firestoreはその次
    
}
