import UIKit
import SDWebImage

class testViewController: UIViewController {

    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URLimage = URL(string: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")
        
        testImage.sd_setImage(with: URLimage)
    }
    
}
