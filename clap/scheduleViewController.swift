
import UIKit
import Firebase
import FSCalendar
import CalculateCalendarLogic

class scheduleViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var pickedDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func nextTapped(_ sender:UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
    }
    @IBAction  func previousTapped(_ sender:UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectDay = getDay(date)
        
        
        //PickedDateラベルにカレンダーでタップした日付を表示
        //        pickedDate.text = "\(String(selectDay.0))年\(String(selectDay.1))月\(String(selectDay.2))日" //タプル
        pickedDate.text = "\(String(selectDay.1))月\(String(selectDay.2))日\(String(selectDay.3))曜日" //タプル
        
        print(pickedDate.text!) //日付のコンソールプリント
    }
    
    
    
    //UITableView、numberOfRowsInSectionの追加(表示するcell数を決める)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //戻り値の設定(表示するcell数)l
        return TodoKobetsunonakami.count
    }
    
    //UITableView、cellForRowAtの追加(表示するcellの中身を決める)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //変数を作る
        let TodoCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        //変数の中身を作る
        TodoCell.textLabel!.text = TodoKobetsunonakami[indexPath.row]
        //戻り値の設定（表示する中身)
        return TodoCell
    }
    
    //予定を追加ボタンで遷移先へ日付の受け渡し
    @IBAction func TapApp(_ sender: Any) {
        performSegue(withIdentifier: "nextSegue", sender: nil)
    }
    
    /// セグエ実行前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as? planController
        let _ = next?.view
        next?.getStartDate.text = pickedDate.text
        next?.getEndDate.text = pickedDate.text
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        //ログイン後の処理
        let alert: UIAlertController = UIAlertController(title: "ようこそ！", message: "マイページでチームIDを確認しよう！", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
        
        
        //追加画面で入力した内容を取得する
        if UserDefaults.standard.object(forKey: "TodoList") != nil {
            TodoKobetsunonakami = UserDefaults.standard.object(forKey: "TodoList") as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd(EEE)"
        return formatter
    }()
    
    
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
    
    //    //曜日判定(日曜日 〜 土曜日)
    //    func getWeekName(_ date: Date) -> String{
    //        let tmpCalendar = Calendar(identifier: .gregorian)
    //        let component = tmpCalendar.component(.weekday, from: date)
    //        let weekName = component - 1
    //        let formatter = DateFormatter()
    //        formatter.locale = Locale(identifier: "ja")
    //        return formatter.shortWeekdaySymbols[weekName]
    //    }
    
    
    //
    //    let weekName = self.getWeekName(date)
    //    print(weekName) // 2018-06-29 10:35:57 +0000
    
    
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
    
}
