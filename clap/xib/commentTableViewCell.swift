import UIKit

//protocol CommentTableViewCellDelegate {
//    func didButtonPressed()
//}

class commentTableViewCell: UITableViewCell {
    
//    var delegate: CommentTableViewCellDelegate?
    
    @IBOutlet weak var commentedUserImage: UIImageView!
    @IBOutlet weak var commentedUserName: UILabel!
    @IBOutlet weak var commentedUserTextField: UITextView!
    @IBOutlet weak var commentedUserTime: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commentInit(name: String?, text: String?, time: String?) {
        self.commentedUserName.text = name
        
        self.commentedUserTextField.text = text
        self.commentedUserTime.text = time
    }
    
//    @IBAction func replyButtonTapped(_ sender: Any) {
//        delegate?.didButtonPressed()
//
//    }
    
}
