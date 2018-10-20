
import UIKit

//変数の設置
var TodoKobetsunonakami = [String]()

class planController: UIViewController {
    
    var Date = "" //日付の取得
    
    
    //テキストフィールドの設定
    @IBOutlet weak var TodoTextField: UITextField!
    
    //タップした日付を取得する(開始日)
    @IBOutlet weak var getStartDate: UITextField!
    
    
    //タップした日付を取得する(終了日)
    @IBOutlet weak var getEndDate: UITextField!
    
    private var datePicker: UIDatePicker = UIDatePicker()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
//        datePicker.locale =
        datePicker.addTarget(self, action: #selector(dateChanged(textField: datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        getStartDate.inputView = datePicker
        getStartDate.tag = 1
        getEndDate.inputView = datePicker
        getEndDate.tag = 2
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(textField: UITextField, datePicker: UIDatePicker) {
        if textField.tag == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            getStartDate.text = dateFormatter.string(from: datePicker.date)
            view.endEditing(true)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            getEndDate.text = dateFormatter.string(from: datePicker.date)
            view.endEditing(true)
        }
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //変数に入力内容を入れる
        TodoKobetsunonakami.append(TodoTextField.text!)
        //追加ボタンを押したらフィールドを空にする
        TodoTextField.text = ""
        //変数の中身をUDに追加
        UserDefaults.standard.set( TodoKobetsunonakami, forKey: "TodoList" )
    }
    
}
