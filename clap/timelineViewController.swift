import UIKit

struct CellData {
    var image: UIImage
    var name: String
}

class timelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var arr = [CellData]()
    
    @IBOutlet weak var userTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTable.delegate = self
        userTable.dataSource = self
        userTable.register(UINib(nibName: "userTableViewCell", bundle: nil), forCellReuseIdentifier: "cellName")
        
        arr = [CellData(image: UIImage(named: "weight")!, name: "test1")]
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTable.dequeueReusableCell(withIdentifier: "cellName", for: indexPath) as! userTableViewCell
        cell.userImage.image = arr[indexPath.row].image
        cell.userName.text = arr[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    @IBAction func timeLineButton(_ sender: Any) {
        self.arr = [
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test1"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test2")
        ]
        userTable.reloadData()
    }
    
    @IBAction func subscribeButton(_ sender: Any) {
        self.arr = [
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test1"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test2"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test3")
        ]
        userTable.reloadData()
    }
    @IBAction func submitButton(_ sender: Any) {
        self.arr = [
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test1"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test2"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test3"),
            CellData(image: UIImage(named: "avatardefault_92824")!, name: "test4")
        ]
        userTable.reloadData()
    }
    
    @IBAction func addDiaryButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goDiary", sender: nil)
    }
    
}
