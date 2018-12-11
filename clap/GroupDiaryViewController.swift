import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class GroupDiaryViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var titleLabel5: UILabel!
    @IBOutlet weak var titleLabel6: UILabel!
    
    @IBOutlet weak var diaryText1: UITextView!
    @IBOutlet weak var diaryText2: UITextView!
    @IBOutlet weak var diaryText3: UITextView!
    @IBOutlet weak var diaryText4: UITextView!
    @IBOutlet weak var diaryText5: UITextView!
    @IBOutlet weak var diaryText6: UITextView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var datePickerField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    let db = Firestore.firestore()
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var firebaseUserImageURL = String()
    var teamIDFromFirebase: String = ""
    var userName: UILabel = UILabel()
    
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.tintColor = UIColor.gray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        toolBar.clipsToBounds = true
        set(textField: diaryText1)
        set(textField: diaryText2)
        set(textField: diaryText3)
        set(textField: diaryText4)
        set(textField: diaryText5)
        set(textField: diaryText6)
        
        dateFormat.dateFormat = "yyyy年MM月dd日"
        datePickerField.text = dateFormat.string(from: nowDate as Date)
        datePickerField.delegate = self
        pickerContent()
        getUserName()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        save()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        overwrite()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension GroupDiaryViewController {
    func getUserName() {
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                return
            }
            guard let data = document2.data() else { return }
            self.userName.text = data["name"] as? String ?? ""
        }
    }
    
    func pickerContent() {
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        datePickerField.inputView = inputDatePicker
        
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .default
        pickerToolBar.tintColor = UIColor.black
        pickerToolBar.backgroundColor = UIColor.gray
        
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: Selector(""))
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(addDiaryViewController.toolBarBtnPush(_:)))
        
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        datePickerField.inputAccessoryView = pickerToolBar
    }
    
    @objc func toolBarBtnPush(_ sender: UIBarButtonItem){
        let pickerDate = inputDatePicker.date
        datePickerField.text = dateFormat.string(from: pickerDate)
        self.view.endEditing(true)
    }
    
    func set(textField: UITextView) {
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func save() {
        validate(textView: diaryText1, message: "項目1を記入してください。")
        validate(textView: diaryText2, message: "項目2を記入してください。")
        validate(textView: diaryText3, message: "項目3を記入してください。")
        validate(textView: diaryText4, message: "項目4を記入してください。")
        validate(textView: diaryText5, message: "項目5を記入してください。")
        validate(textView: diaryText6, message: "項目6を記入してください。")
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                return
            }
            guard let data = document3.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.firebaseUserImageURL = data["image"] as? String ?? ""
            
            let now = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let submitOrReplyTime = formatter.string(from: now as Date)
            
            let diaryRandomID = self.randomString(length: 20)
            
            let dataForDiary = [
                "diaryID": diaryRandomID,
                "userID":self.fireAuthUID,
                "userName": self.userName.text ?? "ダメでした",
                "submit": true,
                "title": self.diaryText6.text!,
                "ここが良かった！今日の自分": self.diaryText1.text!,
                "メンバーのここを褒めたい": self.diaryText2.text!,
                "考えました明日の課題": self.diaryText3.text!,
                "こんな練習してみたい": self.diaryText4.text!,
                "監督へのメッセージ": self.diaryText5.text!,
                "今日のタイトル": self.diaryText6.text!,
                "date": self.datePickerField.text!,
                "time": submitOrReplyTime,
                "commentCount": 0,
                "image": self.firebaseUserImageURL
                ] as [String : Any]
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").document(diaryRandomID).setData(dataForDiary) { (error) in
                if error != nil {
                    print("データの格納に失敗")
                } else {
                    print("データの格納に成功")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func overwrite() {
        validate(textView: diaryText1, message: "項目1を記入してください。")
        validate(textView: diaryText2, message: "項目2を記入してください。")
        validate(textView: diaryText3, message: "項目3を記入してください。")
        validate(textView: diaryText4, message: "項目4を記入してください。")
        validate(textView: diaryText5, message: "項目5を記入してください。")
        validate(textView: diaryText6, message: "項目6を記入してください。")
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                return
            }
            guard let data = document3.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.firebaseUserImageURL = data["image"] as? String ?? ""
            
            let now = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let submitOrReplyTime = formatter.string(from: now as Date)
            
            let diaryRandomID = self.randomString(length: 20)
            
            let dataForDiary = [
                "diaryID": diaryRandomID,
                "userID":self.fireAuthUID,
                "userName": self.userName.text ?? "ダメでした",
                "submit": false,
                "title": self.diaryText6.text!,
                "ここが良かった！今日の自分": self.diaryText1.text!,
                "メンバーのここを褒めたい": self.diaryText2.text!,
                "考えました明日の課題": self.diaryText3.text!,
                "こんな練習してみたい": self.diaryText4.text!,
                "監督へのメッセージ": self.diaryText5.text!,
                "今日のタイトル": self.diaryText6.text!,
                "date": self.datePickerField.text!,
                "time": submitOrReplyTime,
                "commentCount": 0,
                "image": self.firebaseUserImageURL
                ] as [String : Any]
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").document(diaryRandomID).setData(dataForDiary) { (error) in
                if error != nil {
                    print("データの格納に失敗")
                } else {
                    print("データの格納に成功")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

    }
    
    func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validate(textView: UITextView, message: String) {
        guard let todoText = textView.text, !todoText.isEmpty else {
            self.ShowMessage(messageToDisplay: message)
            return
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

