import UIKit
import Firebase
import FSCalendar
import CalculateCalendarLogic

class scheduleViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var pickedDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        currentDate(pickedDate)
        
        beginAlert()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        return formatter
    }()
    
    
    @IBAction func nextTapped(_ sender:UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
    }
    
    @IBAction  func previousTapped(_ sender:UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    
    @IBAction func TapApp(_ sender: Any) {
        let eventShare = self.storyboard?.instantiateViewController(withIdentifier: "planController") as! planController
        self.present(eventShare, animated: true, completion: nil)
    }
}


extension scheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        TodoCell.textLabel!.text = ["1","1"][indexPath.row]
        return TodoCell
    }
}


extension scheduleViewController: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectDay = getDay(date)
        pickedDate.text = "\(String(selectDay.1))月\(String(selectDay.2))日\(String(selectDay.3))曜日" //タプル
    }
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
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
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
            
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
}


private extension scheduleViewController {
    
    func currentDate(_ currentTet: UILabel) {
        let currentPickedDate = getDay(Date())
        currentTet.text = "\(String(currentPickedDate.1))月\(String(currentPickedDate.2))日\(String(currentPickedDate.3))曜日"
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
    
    func getScheDuleDate() {
        
    }
}

//日付でfirebase探しに行って、その中のスケジュールデータを表示
