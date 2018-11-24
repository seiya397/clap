import UIKit
import FirebaseDatabase
import FirebaseFirestore
import MobileCoreServices

enum PickerAttributeType {
    case career
    case sports
}

class teamInfoRegisterViewController: UIViewController {
    
    @IBOutlet weak var belongTo: UITextField!
    @IBOutlet weak var kindOfPerson: UITextField!
    @IBOutlet weak var teamSports: UITextField!
    @IBOutlet weak var managerRegister: UIButton!
    
    
    var pickerForAttribute = ["学年を選んでください","社会人", "大学", "高校", "中学"]
    var pickerForSports = ["種目を選んでください","野球", "ラグビー", "柔道", "水泳", "サッカー"]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder(field: belongTo, string: "チーム名")
        placeholder(field: kindOfPerson, string: "学年")
        placeholder(field: teamSports, string: "競技")
        borderOnement(field: belongTo)
        borderOnement(field: kindOfPerson)
        borderOnement(field: teamSports)
        ornement()
        setupUI()
        setupUIForSports()
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) {
        confirm()
        Register()
        teamReplesentPage()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




private extension teamInfoRegisterViewController {
    var accessoryToolbarForCareer: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForCareer(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white.withAlphaComponent(0.2)
            return accessoryToolbar
        }
    }
    
    @objc func onDoneButtonTappedForCareer(sender: UIBarButtonItem) {
        if kindOfPerson.isFirstResponder {
            kindOfPerson.resignFirstResponder()
        }
    }
    
    var accessoryToolbarForSports: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForSports(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white.withAlphaComponent(0.2)
            return accessoryToolbar
        }
    }
    
    @objc func onDoneButtonTappedForSports(sender: UIBarButtonItem) {
        if teamSports.isFirstResponder {
            teamSports.resignFirstResponder()
        }
    }
    
    func setupUI() {
        kindOfPerson.inputView = getPickerView(type: .career)
        kindOfPerson.inputAccessoryView = accessoryToolbarForCareer
        kindOfPerson.text = pickerForAttribute[0]
    }

    func setupUIForSports() {
        teamSports.inputView = getPickerView(type: .sports)
        teamSports.inputAccessoryView = accessoryToolbarForSports
        teamSports.text = pickerForSports[0]
    }
    
    func getPickerView(type: PickerAttributeType) -> UIPickerView {
        var pickerView = UIPickerView()
        switch type {
        case .career:
            pickerView = CareerPickerView()
        case .sports:
            pickerView = SportsPickerView()
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return pickerView
    }
    
    func placeholder(field: UITextField, string: String) {
        field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        field.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func borderOnement(field: UITextField) {
        field.oBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func ornement() {
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        managerRegister.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        managerRegister.backgroundColor = rgba
        managerRegister.layer.cornerRadius = 22.0
        managerRegister.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func confirm() {
        guard let belongText = belongTo.text, !belongText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チーム名を記入してください。")
            return
        }
        guard let kindText = kindOfPerson.text, !kindText.isEmpty else {
            self.ShowMessage(messageToDisplay: "種別を記入してください。")
            return
        }
        guard let sportsText = teamSports.text, !sportsText.isEmpty else {
            self.ShowMessage(messageToDisplay: "競技項目を記入してください。")
            return
        }
    }
    
    func Register() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let randomStringToTeamID = self.randomString(length: 20)
        userDefaults.set(randomStringToTeamID, forKey: "teamID")
        userDefaults.synchronize()
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
        let teamData = ["belong": belongTo.text!, "kind": kindOfPerson.text!, "sports": teamSports.text!] as [String: Any]
        
        var _: DocumentReference? = nil
        
        db.collection("teams").document(teamID).setData(teamData)
        {
            err in
            if err != nil {
                print("fail")
            } else {
                print("success")
            }
        }
    }
    
    func teamReplesentPage() {
        let teamPeplesentRegister = self.storyboard?.instantiateViewController(withIdentifier: "teamReplesentRegisterViewController") as! teamReplesentRegisterViewController
        self.present(teamPeplesentRegister, animated: true, completion: nil)
    }
    
    func cancel() {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
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
    
    func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}




fileprivate class CareerPickerView: UIPickerView {}
fileprivate class SportsPickerView: UIPickerView {}




extension teamInfoRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case is CareerPickerView:
            return pickerForAttribute.count
        case is SportsPickerView:
            return pickerForSports.count
        default:
            return pickerForAttribute.count
        }
    }
}




extension teamInfoRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch pickerView {
        case is CareerPickerView:
            return pickerForAttribute[row]
        case is SportsPickerView:
            return pickerForSports[row]
        default:
            return pickerForAttribute[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
        case is CareerPickerView:
            return kindOfPerson.text = pickerForAttribute[row]
        case is SportsPickerView:
            return teamSports.text = pickerForSports[row]
        default:
            return kindOfPerson.text = pickerForAttribute[row]
        }
    }
}




extension UITextField {
    func oBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
