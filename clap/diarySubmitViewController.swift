import UIKit
import Firebase
import FirebaseFirestore

class diarySubmitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefaults: UserDefaults = UserDefaults.standard
        let submit: String = (userDefaults.object(forKey: "goSubmit")! as? String)!
        
        print("!!!!!!!!!!!!!!")
        print(submit)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
