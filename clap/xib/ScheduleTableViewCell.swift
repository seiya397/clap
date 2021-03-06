import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func commonInit(schedule: String, startTime: String, endTime: String) {
        self.scheduleLabel.text = schedule
        self.startTime.text = startTime
        self.endTime.text = endTime
    }
}









