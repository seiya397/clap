import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class planController: UIViewController {
    
    enum StartAndEnd {
        case start
        case end
    }
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var TodoTextField: UITextField!
    @IBOutlet weak var getStartDate: UITextField!
    @IBOutlet weak var getEndDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let getPickedDate = userDefaults.string(forKey: "pickedDateForSchedule")
        getStartDate.text = getPickedDate
        getEndDate.text = getPickedDate
        
        setupUIForStart()
        setupUIForEnd()
        setupTimeUIForStart()
        setupTimeUIForEnd()
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
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}


private extension planController {// enum, 関数名変更、#selector変更
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
