import UIKit

class timelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{ //追加①
    
    let TODO = [
        "",
        "",
        ""
        ] //追加②
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //追加③ セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    //追加④ セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = TODO[indexPath.row]
        return cell
    }
}

//tableviewコード参照ページhttps://qiita.com/TD3P/items/cafa8e20029047993025
