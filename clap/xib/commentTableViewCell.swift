import UIKit

protocol CommentTableViewCellDelegate {
    func didButtonPressed(commentID: Int)
}

class commentTableViewCell: UITableViewCell {
    
    var delegate: CommentTableViewCellDelegate?
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
    
    func commentInit(name: String?, text: String?, time: String?) {
        self.commentedUserName.text = name
        
        self.commentedUserTextField.text = text
        self.commentedUserTime.text = time
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        delegate?.didButtonPressed(commentID: self.commentID)
    }
    
}
