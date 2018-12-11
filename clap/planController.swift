import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

enum StartAndEnd {
    case start
    case end
}

class planController: UIViewController {
    
    let db = Firestore.firestore()
    
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var teamIDFromFirebase: String = String()
    
    @IBOutlet weak var TodoTextField: UITextField!
    @IBOutlet weak var getStartDate: UITextField!
    @IBOutlet weak var getEndDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var ToolBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToolBar.clipsToBounds = true
        displayDate()
        setupUIForStart()
        setupUIForEnd()
        setupTimeUIForStart()
        setupTimeUIForEnd()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        save()
    }
}




private extension planController {
    func datePickerSet(type: StartAndEnd) -> UIDatePicker {
        var datePicker: UIDatePicker = UIDatePicker()
        switch type {
        case .start:
            datePicker = StartPicker()
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ja")
            datePicker.addTarget(self, action: #selector(startDateChanged(startDatePicker:)), for: .valueChanged)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture)
        case .end:
            datePicker = EndPicker()
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ja")
            datePicker.addTarget(self, action: #selector(endDateChanged(endDatePicker:)), for: .valueChanged)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture)
        }
        return datePicker
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int,String){
        let tmpCalendar = Calendar(identifier: .gregorian)
        //曜日追加
        let Component = tmpCalendar.component(.weekday, from: date)
        let weekName = Component - 1
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        return (year,month,day,formatter.shortWeekdaySymbols[weekName])
    }
}




fileprivate class StartPicker: UIDatePicker {}
fileprivate class EndPicker: UIDatePicker {}




private extension planController {
    func timePickerSet(type: StartAndEnd) -> UIDatePicker {
        var timePicker = UIDatePicker()
        switch type {
        case .start:
            timePicker = StartTimePicker()
            timePicker.datePickerMode = .time
            timePicker.locale = Locale(identifier: "ja")
            timePicker.addTarget(self, action: #selector(startTimeChanged(startTimePicker:)), for: .valueChanged)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture)
        case .end:
            timePicker = EndTimePicker()
            timePicker.datePickerMode = .time
            timePicker.locale = Locale(identifier: "ja")
            timePicker.addTarget(self, action: #selector(endTimeChanged(endTimePicker:)), for: .valueChanged)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
            view.addGestureRecognizer(tapGesture)
        }
        return timePicker
    }
}




fileprivate class StartTimePicker: UIDatePicker {}
fileprivate class EndTimePicker: UIDatePicker {}




extension planController {
    func save() {
        guard let todoText = TodoTextField.text, !todoText.isEmpty else {
            self.ShowMessage(messageToDisplay: "スケジュールを記入してください。")
            return
        }
        guard let startTime = startTime.text, !startTime.isEmpty else {
            self.ShowMessage(messageToDisplay: "開始時間を選択してください。")
            return
        }
        guard let endTime = endTime.text, !endTime.isEmpty else {
            self.ShowMessage(messageToDisplay: "終了時間を選択してください。")
            return
        }
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("erorr2 \(String(describing: error))")
                return
            }
            
            guard let data = document.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            
            let scheduleID = self.randomString(length: 20)
            
            let scheduleData = [
                "id": scheduleID,
                "date_start": self.getStartDate.text!,
                "date_end": self.getEndDate.text!,
                "time_start": self.startTime.text!,
                "time_end": self.endTime.text!,
                "event_title": self.TodoTextField.text!,
                ] as [String : Any]
            self.db.collection("teams").document(self.teamIDFromFirebase).collection("schedule").document(scheduleID).setData(scheduleData) { (err) in
                if err != nil {
                    print("scheduleを登録できません")
                    return
                }
                print("scheduleの登録に成功")
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupUIForStart() {
        getStartDate.inputView = datePickerSet(type: .start)
    }
    
    func setupUIForEnd() {
        getEndDate.inputView = datePickerSet(type: .end)
    }
    
    @objc func startDateChanged(startDatePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        getStartDate.text = dateFormatter.string(from: startDatePicker.date)
        view.endEditing(true)
    }
    
    @objc func endDateChanged(endDatePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        getEndDate.text = dateFormatter.string(from: endDatePicker.date)
        view.endEditing(true)
    }
    
    
    func setupTimeUIForStart() {
        startTime.inputView = timePickerSet(type: .start)
    }
    
    func setupTimeUIForEnd() {
        endTime.inputView = timePickerSet(type: .end)
    }
    
    @objc func startTimeChanged(startTimePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTime.text = dateFormatter.string(from: startTimePicker.date)
        view.endEditing(true)
    }
    
    @objc func endTimeChanged(endTimePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        endTime.text = dateFormatter.string(from: endTimePicker.date)
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    func displayDate() {
        let currentPickedDate = getDay(Date())
        
        getStartDate.text = "\(String(currentPickedDate.0))年\(String(currentPickedDate.1))月\(String(currentPickedDate.2))日"
        
        getEndDate.text = "\(String(currentPickedDate.0))年\(String(currentPickedDate.1))月\(String(currentPickedDate.2))日"
        
    }
}
