import UIKit

class memberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberTitle: UILabel!
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var WrappingImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func defaultColor() {
        WrappingImage.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

    override var isSelected: Bool {
        didSet {
            WrappingImage.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}
