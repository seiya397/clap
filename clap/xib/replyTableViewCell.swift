import UIKit

class replyTableViewCell: UITableViewCell {

    @IBOutlet weak var replyUserImage: UIImageView!
    @IBOutlet weak var replyUserName: UILabel!
    @IBOutlet weak var replyUserText: UITextView!
    @IBOutlet weak var replyUserTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commentInit(image: URL?, name: String?, text: String?, time: String?) {
        
        self.replyUserText.isEditable = false
        self.replyUserImage.sd_setImage(with: image)
        self.replyUserName.text = name
        
        self.replyUserText.text = text
        self.replyUserTime.text = time
    }
}
