import UIKit
import SDWebImage

protocol CommentTableViewCellDelegate : class {
    func didButtonPressed(commentID: Int)
}

class commentTableViewCell: UITableViewCell {
    
    weak var delegate: CommentTableViewCellDelegate?
    var commentID = Int()
    
    @IBOutlet weak var commentedUserImage: UIImageView!
    @IBOutlet weak var commentedUserName: UILabel!
    @IBOutlet weak var commentedUserTextField: UITextView!
    @IBOutlet weak var commentedUserTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commentInit(image: URL?, name: String?, text: String?, time: String?) {
        
        self.commentedUserTextField.isEditable = false
        
        self.commentedUserImage.sd_setImage(with: image)
        
        self.commentedUserName.text = name
        
        self.commentedUserTextField.text = text
        
        self.commentedUserTime.text = time
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        delegate?.didButtonPressed(commentID: self.commentID)
    }
    
}
