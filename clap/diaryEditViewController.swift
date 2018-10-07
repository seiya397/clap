import UIKit

class diaryEditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefaults: UserDefaults = UserDefaults.standard
        let draft: String = (userDefaults.object(forKey: "goDraft")! as? String)!
        
        print("!!!!!!!!!!!!!!")
        print(draft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
