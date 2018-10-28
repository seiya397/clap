import UIKit

class memberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberTitle: UILabel!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var userID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
