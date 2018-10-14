import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI


class myPageViewController: UIViewController{
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userRole: UITextField!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamIDLabel: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    
    var selectedPhoto = UIImage()
    
    let db = Firestore.firestore()
    
    var teamIDFromFirebase: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if let user = user {
            userEmail.text = user.email
        }

        // Do any additional setup after loading the view.
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            let data = document3.data()
            self.teamIDLabel.text = data!["teamID"] as? String //ユーザー名表示
            self.teamIDFromFirebase = (data!["teamID"] as? String)!
            
            self.db.collection("teams").document(self.teamIDFromFirebase).addSnapshotListener { (snapshot, error) in
                guard let document = snapshot else {
                    print("error \(String(describing: error))")
                    return
                }
                let data = document.data()
                print("このデータは \(String(describing: data!["belong"]))")
                self.teamName.text = data!["belong"] as? String //チーム名表示
            }
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(myPageViewController.selectPhoto(_:)) as Selector)
        
        tap.numberOfTapsRequired = 1
        
        self.userImage.addGestureRecognizer(tap)
        
        let storageReference = Storage.storage().reference()
        let profileImageDownloadedURLReference = storageReference.child("users/\(Auth.auth().currentUser?.uid ?? " ")/profileImage.jpg")
        let placeholderImage = UIImage(named: "placeholder.jpg")
//        userImage.sd_setImage(with: profileImageDownloadedURLReference, placeholderImage: placeholderImage)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        uploadObject(name: self.userName.text!, role: self.userRole.text!, email: self.userEmail.text!)
        ShowSaveAlert()
    }
    
    
    func uploadObject(name: String, role: String, email: String) {
        
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        
        db.collection("users").document(fireAuthUID).updateData(["name": name, "role": role]) { (error) in
            if let error = error {
                print("アップデートに失敗しました\(error.localizedDescription)")
                return
            } else {
                print("アップデートに成功しました")
            }
        }
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let _ = error {
                print("メールアドレスの更新に失敗しました")
                return
            } else {
                print("メールアドレスの更新に成功しました")
            }
        })
        
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
            
            self.userImage.image = selected
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
    
    public func ShowSaveAlert() {
        let alertController = UIAlertController(title: "Alert", message: "保存完了", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // から文字処理、画像最初デフォルト処理、なぜかその人の値が取れない問題
}

class CircleImageViewForMypage: UIImageView {
    @IBInspectable var borderColor :  UIColor = UIColor.black
    @IBInspectable var borderWidth :  CGFloat = 0.1
    
    override var image: UIImage? {
        didSet{
            layer.masksToBounds = false
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.cornerRadius = frame.height/2
            clipsToBounds = true
        }
    }
}
