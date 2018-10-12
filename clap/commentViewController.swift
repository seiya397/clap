import UIKit

class commentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var textName: UITextField!
    
    var name = [String]()
    var userText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        cell.commonInit(name: name[indexPath.item], text: userText[indexPath.item], time: "20:10")
        return cell
    }

    @IBAction func buttonTapped(_ sender: Any) {
        name.append(String(textName.text!))
        userText.append(String(textfield.text!))
        tableView.reloadData()
    }
}

