import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore



class addDiaryViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var datePiclerField: UITextField!
    
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var textLabel3: UILabel!
    @IBOutlet weak var textView3: UITextView!
    
    @IBOutlet weak var textLabel4: UILabel!
    @IBOutlet weak var textView4: UITextView!
    
    @IBOutlet weak var textLabel5: UILabel!
    @IBOutlet weak var textView5: UITextView!
    
    @IBOutlet weak var textLabel6: UILabel!
    @IBOutlet weak var textView6: UITextView!
    
    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var firebaseUserImageURL = String()
    
    var teamIDFromFirebase: String = ""
    
    @IBOutlet weak var userName: UILabel!
    
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel1.text = "ここが良かった！今日の自分"
        textLabel2.text = "メンバーのここを褒めたい"
        textLabel3.text = "考えました明日の課題"
        textLabel4.text = "こんな練習してみたい"
        textLabel5.text = "監督へのメッセージ"
        textLabel6.text = "今日のタイトル"
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy年MM月dd日"
        datePiclerField.text = dateFormat.string(from: nowDate as Date)
        datePiclerField.delegate = self
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.date
        datePiclerField.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.gray
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: Selector(""))
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(addDiaryViewController.toolBarBtnPush(_:)))
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        datePiclerField.inputAccessoryView = pickerToolBar
        
        //ユーザーの名前取得
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document2.data() else { return }
            self.userName.text = data["name"] as? String ?? ""
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let textView1IsEmpty = textView1.text, !textView1IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目2を記入してください。")
            return
        }
        guard let textView2IsEmpty = textView2.text, !textView2IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目2を記入してください。")
            return
        }
        guard let textView3IsEmpty = textView3.text, !textView3IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目3を記入してください。")
            return
        }
        guard let textView4IsEmpty = textView4.text, !textView4IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目4を記入してください。")
            return
        }
        guard let textView5IsEmpty = textView5.text, !textView5IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目5を記入してください。")
            return
        }
        guard let textView6IsEmpty = textView6.text, !textView6IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目6を記入してください。")
            return
        }
        

        
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.firebaseUserImageURL = data["image"] as? String ?? ""
            
            //submit or 保存ボタン押した時の時刻取得
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
                "title": self.textLabel6.text!,
                self.textLabel1.text!: self.textView1.text!,
                self.textLabel2.text!: self.textView2.text!,
                self.textLabel3.text!: self.textView3.text!,
                self.textLabel4.text!: self.textView4.text!,
                self.textLabel5.text!: self.textView5.text!,
                self.textLabel6.text!: self.textView6.text!,
                "date": self.datePiclerField.text!,
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
    
    @IBAction func overwriteButtonTapped(_ sender: Any) {
        guard let textView1IsEmpty = textView1.text, !textView1IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目2を記入してください。")
            return
        }
        guard let textView2IsEmpty = textView2.text, !textView2IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目2を記入してください。")
            return
        }
        guard let textView3IsEmpty = textView3.text, !textView3IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目3を記入してください。")
            return
        }
        guard let textView4IsEmpty = textView4.text, !textView4IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目4を記入してください。")
            return
        }
        guard let textView5IsEmpty = textView5.text, !textView5IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目5を記入してください。")
            return
        }
        guard let textView6IsEmpty = textView6.text, !textView6IsEmpty.isEmpty else {
            self.ShowMessage(messageToDisplay: "項目6を記入してください。")
            return
        }
        
        
        
        

        
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            self.firebaseUserImageURL = data["image"] as? String ?? ""
            //submit or 保存ボタン押した時の時刻取得
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
                "title": self.textLabel6.text!,
                self.textLabel1.text!: self.textView1.text!,
                self.textLabel2.text!: self.textView2.text!,
                self.textLabel3.text!: self.textView3.text!,
                self.textLabel4.text!: self.textView4.text!,
                self.textLabel5.text!: self.textView5.text!,
                self.textLabel6.text!: self.textView6.text!,
                "date": self.datePiclerField.text!,
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
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) { //認証用関数
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //diaryID用
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
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(_ sender: UIBarButtonItem){
        
        var pickerDate = inputDatePicker.date
        datePiclerField.text = dateFormat.string(from: pickerDate)
        self.view.endEditing(true)
    }
    
}
