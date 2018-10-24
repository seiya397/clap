import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var schedule: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func commonInit(start: String, end: String, schedule: String) {
        
        self.startTime.text = start
        self.endTime.text = end
        self.schedule.text = schedule
    }
}
