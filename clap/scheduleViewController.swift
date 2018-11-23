import UIKit
import Firebase
import FSCalendar
import CalculateCalendarLogic


struct StartEvent {
    var event: String?
    var startTime: String?
    var endTime: String?
}




struct EndEvent {
    var event: String?
    var startTime: String?
    var endTime: String?
}




class scheduleViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var pickedDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newDiaryLabel: UILabel!
    
    //開始日タップ用
    var startEvents = [StartEvent]()
    var startTimeArrForStart = [Any]()
    var endTimeArrForStart = [Any]()
    var scheduleArrForStart = [Any]()
    //終了日タップ用
    var endEvents = [EndEvent]()
    var startTimeArrForEnd = [Any]()
    var endTimeArrForEnd = [Any]()
    var scheduleArrForEnd = [Any]()
    
    let db = Firestore.firestore()
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    var teamIDFromFirebase: String = String()
    var timeIntervalArray: [String] = []
    var dotDisplayArr = [String]()
    var newSubmitDiaryForToday = [Any]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.removeSuite(named: "arrForDotDisplay")
        
        mustSubscribeCalendar()
        mustSbscribeTableView()
        currentDate(pickedDate)
        beginAlert()
        navColor()
        getTodayDiary()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }()
    
    @IBAction func TapApp(_ sender: Any) {
        let eventShare = self.storyboard?.instantiateViewController(withIdentifier: "planController") as! planController
        self.present(eventShare, animated: true, completion: nil)
    }
}




extension scheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func mustSbscribeTableView() {
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "scheduleCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleArrForStart.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleTableViewCell
        
        if startEvents.count > 0 {
            
            let startEvent = startEvents[indexPath.row].event
            
            let startTime = startEvents[indexPath.row].startTime
            
            let endTime = startEvents[indexPath.row].endTime
            
            cell.commonInit(schedule: startEvent as! String, startTime: startTime as! String, endTime: endTime as! String)
            
        } else if endEvents.count > 0 {
            
            let startEvent = endEvents[indexPath.row].event
            
            let startTime = endEvents[indexPath.row].startTime
            
            let endTime = endEvents[indexPath.row].endTime
            
            cell.commonInit(schedule: startEvent as! String, startTime: startTime as! String, endTime: endTime as! String)
            
        } else {
            
            cell.commonInit(schedule: "スケジュールがありません", startTime: "", endTime: "")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
}




extension scheduleViewController: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func mustSubscribeCalendar() {
        
        calendar.dataSource = self
        
        calendar.delegate = self
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        let selectDay = getDay(date)
        
        pickedDate.text = "\(String(selectDay.1))月\(String(selectDay.2))日\(String(selectDay.3))曜日"
        
        let scheduleForDate = "\(String(selectDay.0))年\(String(selectDay.1))月\(String(selectDay.2))日"
        print(scheduleForDate)
        
        getStartScheduleDate(date: scheduleForDate)
        
        tableView.reloadData()
        
    }
    
    
    func judgeHoliday(_ date : Date) -> Bool {
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        
        let month = tmpCalendar.component(.month, from: date)
        
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        
    }
    
    func getDay(_ date:Date) -> (Int,Int,Int,String){
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let Component = tmpCalendar.component(.weekday, from: date)
        
        let weekName = Component - 1
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ja")
        
        let year = tmpCalendar.component(.year, from: date)
        
        let month = tmpCalendar.component(.month, from: date)
        
        let day = tmpCalendar.component(.day, from: date)
        
        return (year,month,day,formatter.shortWeekdaySymbols[weekName])
        
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        return tmpCalendar.component(.weekday, from: date)
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if self.judgeHoliday(date){
            
            return UIColor.red
            
        }
        
        let weekday = self.getWeekIdx(date)
        
        if weekday == 1 {
            
            return UIColor.red
            
        }
            
        else if weekday == 7 {
            
            return UIColor.blue
        }
        
        return nil
        
    }
    
    func getNextMonth(date:Date)->Date {
        
        return  Calendar.current.date(byAdding:.month, value: 1, to:date)!
        
    }
    
    func getPreviousMonth(date:Date)->Date {
        
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var dateForDot = dateFormatter.string(from: date)
        
            self.getScheduleDot(date: dateForDot)
        
                let dotArr = self.userDefaults.array(forKey: "arrForDotDisplay") as? [String] ?? [""]
        
            for dateString in dotArr {
                
                if dateForDot == dateString {
                    
                    return 1
                    
                }
            }
        
        return 0
        
    }
}




private extension scheduleViewController {
    
    func currentDate(_ currentTet: UILabel) {
        
        let currentPickedDate = getDay(Date())
        
        currentTet.text =  "\(String(currentPickedDate.1))月\(String(currentPickedDate.2))日\(String(currentPickedDate.3))曜日"
        
    }
    
    func navColor() {
        //ナビゲーションバーの背景、タイトル色指定
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 82/255, blue: 212/255, alpha: 100)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func beginAlert() {
        
        let alert: UIAlertController = UIAlertController(title: "ようこそ！", message: "マイページでチームIDを確認しよう！", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            print("OK")
            
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func generateTimeRange(startDate: String, endDate: String) -> [String]? {
        
        var result: [String] = []
        
        guard var start = dateFormatter.date(from: startDate) else { return nil }
        
        guard let end = dateFormatter.date(from: endDate) else { return nil }

        while start <= end {
            
            result.append(dateFormatter.string(from: start))
            
            start = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            
        }
        
        return result
        
    }
    
    func getScheduleDot(date: String) {
        
        self.db
            .collection("users")
            .document(fireAuthUID)
            .addSnapshotListener { (snapshot, error) in
                
            guard let document = snapshot else {
                
                print("erorr2 \(String(describing: error))")
                
                return
                
            }
                
            guard let data = document.data() else { return }
                
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            
            self.db
                .collection("teams")
                .document(self.teamIDFromFirebase)
                .collection("schedule")
                .whereField("date_start", isEqualTo: date)
                .getDocuments() { (querySnapshot, err) in
                    
                if err != nil {
                    
                    print("scheduleを取得できませんでした")
                    
                    return
                    
                } else {
                    
                    var i = 0
                    
                    for document in querySnapshot!.documents {
                        
                        let dataFromFirebase: [String : Any] = document.data()
                        
                        let startDateFromFirebase = dataFromFirebase["date_start"] ?? ""
                        
                        let endDateFromFirebase = dataFromFirebase["date_end"] ?? ""
                        
                        self.dotDisplayArr.append(startDateFromFirebase as! String)
                        
                        self.dotDisplayArr.append(endDateFromFirebase as! String)
                        
                        i += 1
                        
                    }
                    
                    self.dotDisplayArr as NSArray
                    
                    self.userDefaults.set(self.dotDisplayArr, forKey: "arrForDotDisplay")
                    
                    self.userDefaults.synchronize()
                    
                }
            }
        }
    }
    
    func getStartScheduleDate(date: String) {
        
        startEvents = []
        startTimeArrForStart = []
        endTimeArrForStart = []
        scheduleArrForStart = []
        
        endEvents = []
        startTimeArrForStart = []
        endTimeArrForStart = []
        scheduleArrForStart = []
        
        self.db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot, error) in
            
            guard let document = snapshot else {
                
                print("erorr2 \(String(describing: error))")
                
                return
                
            }
            
            guard let data = document.data() else { return }
            
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            
            self.db
                .collection("teams")
                .document(self.teamIDFromFirebase)
                .collection("schedule")
                .whereField("date_start", isEqualTo: date)
                .getDocuments() { (querySnapshot, err) in
                    
                if err != nil {
                    
                    print("scheduleを取得できませんでした")
                    
                    return
                    
                } else {
                    
                    var i = 0
                    
                    for document in querySnapshot!.documents {
                        
                        let dataFromFirebase: [String : Any] = document.data()
                        
                        let startTimeFromFirebase = dataFromFirebase["time_start"] ?? ""
                        
                        let endTimeFromFirebase = dataFromFirebase["time_end"] ?? ""
                        
                        let scheduleFromFirebase = dataFromFirebase["event_title"] ?? ""
                        self.startTimeArrForStart.append(startTimeFromFirebase)
                        
                        self.endTimeArrForStart.append(endTimeFromFirebase)
                        
                        self.scheduleArrForStart.append(scheduleFromFirebase as! String)
                        
                        self.startEvents.append(StartEvent(event: self.scheduleArrForStart[i] as! String, startTime: self.startTimeArrForStart[i] as! String, endTime: self.endTimeArrForStart[i] as! String))
                        
                        self.tableView.reloadData()
                        
                        i += 1
                    }
                }
            }
        }
    }
    
    func getScheduleDate(date: Any, completion: @escaping ([Any], [Any])-> Void) {
        
        self.db
            .collection("users")
            .document(fireAuthUID)
            .addSnapshotListener { (snapshot, error) in
            
            guard let document = snapshot else {
                
                print("erorr2 \(String(describing: error))")
                
                return
                
            }
            guard let data = document.data() else { return }
                
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
                
            self.db
                .collection("teams")
                .document(self.teamIDFromFirebase)
                .collection("schedule")
                .whereField("date_start", isEqualTo: date)
                .getDocuments() { (querySnapshot, err) in
                    
                    var startTime = [Any]()
                    
                    var endTime = [Any]()
                    
                    if err != nil {
                        
                        print("scheduleを取得できませんでした")
                        
                        return
                        
                    } else {
                        
                        for document in querySnapshot!.documents {
                            
                            guard let dataFromFirebase: [String : Any] = document.data() else { return }
                            
                            let startTimeFromFirebase = dataFromFirebase["date_start"] ?? ""
                            
                            let endTimeFromFirebase = dataFromFirebase["date_end"] ?? ""
                            
                            let scheduleFromFirebase = dataFromFirebase["event_title"] ?? ""
                            
                            startTime.append(startTimeFromFirebase)
                            
                            endTime.append(endTimeFromFirebase)
                            
                            self.tableView.reloadData()
                            
                        }
                    }
                    
                    completion (startTime, endTime)
                    
            }
        }
    }
    
    func getTodayDiary() {
        self.db
            .collection("users")
            .document(fireAuthUID)
            .addSnapshotListener { (snapshot, error) in
                
                guard let document = snapshot else {
                    
                    print("erorr2 \(String(describing: error))")
                    
                    return
                    
                }
                guard let data = document.data() else { return }
                
                self.teamIDFromFirebase = data["teamID"] as? String ?? ""
                
                let today = self.getNewSubmitDate()
                self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("submit", isEqualTo: true).whereField("userID", isEqualTo: self.fireAuthUID).whereField("date", isEqualTo: today).getDocuments(completion: { (query, err) in
                    if err != nil {
                        return
                    } else {
                        var i = 0
                        for document in query!.documents {
                            guard var documentData: [String: Any] = document.data() else { return }
                            self.newSubmitDiaryForToday.append(documentData["title"] as? String ?? "新着なし")
                            i += 1
                        }
                        if self.newSubmitDiaryForToday.isEmpty {
                            self.newDiaryLabel.text = "新着なし"
                        } else {
                            self.newDiaryLabel.text = self.newSubmitDiaryForToday[0] as! String
                        }
                        
                    }
                })
        }
    }
    
    func getNewSubmitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let now = Date()
        return formatter.string(from: now)
    }
}




