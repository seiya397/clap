import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

struct scrollViewDataStruct {
    let title: String?
    let placeHolder: String?
}

class testScrollViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var datePiclerField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var textViewData = [String]()
    
    var scrollData = [scrollViewDataStruct]()
    
    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")

    var firebaseUserImageURL = String()

    var teamIDFromFirebase: String = ""

    var userName: UILabel = UILabel()
    
    var textTagValue = 1000
    var viewTagValue = 100
    var tagValue = 10
    
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 5
        submitButton.tintColor = UIColor.gray
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
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
        pickerToolBar.barStyle = .default
        pickerToolBar.tintColor = UIColor.black
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
        
        scrollData = [
            scrollViewDataStruct(title: "よかった点", placeHolder: ""),
            scrollViewDataStruct(title: "今日の反省", placeHolder: ""),
            scrollViewDataStruct(title: "明日の課題", placeHolder: ""),
            scrollViewDataStruct(title: "こんな練習してみたい", placeHolder: ""),
            scrollViewDataStruct(title: "監督へのメッセージ", placeHolder: ""),
            scrollViewDataStruct(title: "今日のタイトル", placeHolder: ""),
        ]
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(scrollData.count)
        
        var i = 0
        
        for data in scrollData {
            let view = CustomView(frame: CGRect(x: 5 + (self.scrollView.frame.width * CGFloat(i)), y: 0, width: self.scrollView.frame.width - 10, height: self.scrollView.frame.height))
            view.textView.text = data.placeHolder
            view.textView.tag = i + textTagValue
            view.tag = i + viewTagValue
            self.scrollView.addSubview(view)
            
            let label = UILabel(frame: CGRect.init(origin: CGPoint.init(x: self.view.bounds.width, y: 20), size: CGSize.init(width: 0, height: 40)))
            label.text = data.title
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.sizeToFit()
            label.tag = i + tagValue
            if i == 0 {
                label.center.x = view.center.x
            } else {
                label.center.x = view.center.x - self.scrollView.frame.width / 7
            }
            label.textColor = UIColor.gray
            self.scrollView.addSubview(label)
            
            i += 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            for i in 0 ..< scrollData.count {
                let label = scrollView.viewWithTag(i + tagValue) as! UILabel
                let view = scrollView.viewWithTag(i + viewTagValue) as! CustomView
                let scrollContentOffset = scrollView.contentOffset.x + self.scrollView.frame.width
                let viewOffset = (view.center.x - scrollView.bounds.width / 4) - scrollContentOffset
                label.center.x = scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        for i in 0 ..< scrollData.count {
            let view = scrollView.viewWithTag(i + viewTagValue) as! CustomView
            guard let textViewIsEmpty = view.textView.text, !textViewIsEmpty.isEmpty else {
                self.ShowMessage(messageToDisplay: "項目\(i)を記入してください。")
                return
            }
            textViewData.append(view.textView.text)
        }
        let text6 = textViewData.removeLast()
        let text5 = textViewData.removeLast()
        let text4 = textViewData.removeLast()
        let text3 = textViewData.removeLast()
        let text2 = textViewData.removeLast()
        let text1 = textViewData.removeLast()

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
                "title": text6,
                "ここが良かった！今日の自分": text1,
                "メンバーのここを褒めたい": text2,
                "考えました明日の課題": text3,
                "こんな練習してみたい": text4,
                "監督へのメッセージ": text5,
                "今日のタイトル": text6,
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
        for i in 0 ..< scrollData.count {
            let view = scrollView.viewWithTag(i + viewTagValue) as! CustomView
            guard let textViewIsEmpty = view.textView.text, !textViewIsEmpty.isEmpty else {
                self.ShowMessage(messageToDisplay: "項目\(i)を記入してください。")
                return
            }
        }
        let text6 = textViewData.removeLast()
        let text5 = textViewData.removeLast()
        let text4 = textViewData.removeLast()
        let text3 = textViewData.removeLast()
        let text2 = textViewData.removeLast()
        let text1 = textViewData.removeLast()
        
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
                "title": text6,
                "ここが良かった！今日の自分": text1,
                "メンバーのここを褒めたい": text2,
                "考えました明日の課題": text3,
                "こんな練習してみたい": text4,
                "監督へのメッセージ": text5,
                "今日のタイトル": text6,
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


class CustomView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
//        textView.layer.borderColor = UIColor.gray.cgColor
//        textView.layer.borderWidth = 2
//        textView.layer.cornerRadius = 10
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 100).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




