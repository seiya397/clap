
import UIKit

//変数の設置
var TodoKobetsunonakami = [String]()

class planController: UIViewController {
    
    var Date = "" //日付の取得
    
    
    //テキストフィールドの設定
    @IBOutlet weak var TodoTextField: UITextField!
    
    //タップした日付を取得する(開始日)
    @IBOutlet weak var getStartDate: UILabel!
    
    
    //タップした日付を取得する(終了日)
    @IBOutlet weak var getEndDate: UILabel!
    
    
    

    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
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
