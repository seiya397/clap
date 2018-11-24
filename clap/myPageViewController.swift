import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI
import SDWebImage


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
    var imageURL = [String: String]()
    var editFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ornement()
        
        userName.isEnabled = false
        teamIDLabel.isEnabled = false
        teamName.isEnabled = false
        userRole.isEnabled = false
        userEmail.isEnabled = false
        
        displayEmail()
        displayUserContent()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        edit()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        save()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        logout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




extension myPageViewController {
    func ornement() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 82/255, blue: 212/255, alpha: 100)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func displayEmail() {
        let user = Auth.auth().currentUser
        if let user = user {
            userEmail.text = user.email
        }
    }
    
    func displayUserContent() {
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDLabel.text = data["teamID"] as? String ?? ""
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            
            self.db.collection("teams").document(self.teamIDFromFirebase).addSnapshotListener { (snapshot, error) in
                guard let document = snapshot else {
                    print("error \(String(describing: error))")
                    return
                }
                guard let data = document.data() else { return }
                self.teamName.text = data["belong"] as? String ?? "" //チーム名表示
            }
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document2.data() else { return }
            self.userName.text = data["name"] as? String ?? "" //ユーザー名表示
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            self.userRole.text = data["role"] as? String ?? "" //ユーザー名表示
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(myPageViewController.selectPhoto(_:)) as Selector)
        
        tap.numberOfTapsRequired = 1
        
        self.userImage.addGestureRecognizer(tap)
        
        //display image
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(String(describing: error))")
                return
            }
            guard let data = document.data() else { return }
            let url = data["image"] as? String ?? ""
            let URLIMAGE = URL(string: url)
            self.userImage.sd_setImage(with: URLIMAGE)
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
    
    func edit() {
        userName.isEnabled = true
        userName.textColor = UIColor.gray
        userRole.isEnabled = true
        userRole.textColor = UIColor.gray
        userEmail.isEnabled = true
        userEmail.textColor = UIColor.gray
        self.editFlag = true
    }
    
    func save() {
        if editFlag == false {
            return
        } else {
            uploadObject(name: self.userName.text!, role: self.userRole.text!, email: self.userEmail.text!)
            ShowSaveAlert()
            userName.isEnabled = false
            userName.textColor = UIColor.black
            userRole.isEnabled = false
            userRole.textColor = UIColor.black
            userEmail.isEnabled = false
            userEmail.textColor = UIColor.black
            self.editFlag = false
        }
    }
    
    func uploadObject(name: String, role: String, email: String) {
        
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        
        db.collection("users").document(fireAuthUID).updateData(["name": name, "role": role]) { (error) in
            if error != nil {
                return
            } else {
                print("アップデートに成功しました")
            }
        }
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let _ = error {
                return
            } else {
                print("メールアドレスの更新に成功しました")
            }
        })
    }
    
    func logout() {
        let alert: UIAlertController = UIAlertController(title: "表示", message: "ログアウトしますか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            
            (action: UIAlertAction!) -> Void in
            
            print("OK")
            
            do {
                try Auth.auth().signOut()
                let fireAuthUID2 = (Auth.auth().currentUser?.uid ?? "no data")
                let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginPage, animated: true, completion: nil)
            } catch {
                print("ログアウトできませんでした")
            }
            
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            
            print("Cancel")
            
        })
        
        alert.addAction(cancelAction)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
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
                profileImageRef.downloadURL(completion: { (getURL, err) in
                    if err != nil {
                        return
                    }
                    
                    self.imageURL = ["image": getURL?.absoluteString ?? " "]
                    self.db.collection("users").document(UidForPath).updateData(self.imageURL) {
                        err in
                        if err != nil {
                            return
                        }
                        print("firestoreにURLをsetできました")
                    }
                })
                
            }
        }
    }
    
    public func ShowSaveAlert() {
        let alertController = UIAlertController(title: "Alert", message: "保存完了", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
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
