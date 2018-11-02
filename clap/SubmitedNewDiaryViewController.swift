import UIKit

class SubmitedNewDiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var diary = String()
    
    @IBOutlet weak var contentView: UIView!
    
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
    
    @IBOutlet weak var commentUserCount: UILabel!
    @IBOutlet weak var commentUserImage: UIImageView!
    @IBOutlet weak var commentUserTextfield: UITextView!
    @IBOutlet weak var commentUserTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.white
        
        textView1.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView2.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView3.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView4.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView5.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView6.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        textView1.isEditable = false
        textView2.isEditable = false
        textView3.isEditable = false
        textView4.isEditable = false
        textView5.isEditable = false
        textView6.isEditable = false
        
        commentUserTableView.delegate = self
        commentUserTableView.dataSource = self
        
        let nibName = UINib(nibName: "commentTableViewCell", bundle: nil)
        
        commentUserTableView.register(nibName, forCellReuseIdentifier: "commentTableViewCell")
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let result = userDefaults.object(forKey: "MyDiaryData")
        print("=============")
        print(result ?? "aa")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentUserTableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! commentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


extension SubmitedNewDiaryViewController: CommentTableViewCellDelegate {
    func didButtonPressed(commentID: Int) {
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "goReply")
        
//        userDefaults.set(self.commentIdArr[commentID], forKey: "goReply")
        
        userDefaults.synchronize()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "commentReplyViewController") as! commentReplyViewController
        
        self.present(vc, animated: true, completion: nil)
    }
}
