import UIKit

struct HeadLine {
    var date: Date
    var title: String
    var text: String
    var image: String
}

struct TableSection<SectionItem: Comparable&Hashable, RowItem>: Comparable {
    var sectionItem: SectionItem
    var rowItems: [RowItem]
    
    static func < (lhs: TableSection, rhs: TableSection) -> Bool {
        return lhs.sectionItem > rhs.sectionItem
    }
    
    
    static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        return lhs.sectionItem == rhs.sectionItem
    }
    
    static func group(rowItems : [RowItem], by criteria : (RowItem) -> SectionItem ) -> [TableSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rowItems, by: criteria)
        return groups.map(TableSection.init(sectionItem:rowItems:)).sorted()
    }
}

fileprivate func parseDate(_ str: String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat.date(from: str)!
}

fileprivate func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}

class testSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var testTableView: UITableView!
    
    var headlines = [HeadLine]()
    
    var sections = [TableSection<Date, HeadLine>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testTableView.delegate = self
        testTableView.dataSource = self
        
        headlines = [
            HeadLine(date: parseDate("2018-7-21"), title: "title1", text: "aaaaaaaaaaaaaaaa", image: "weight"),
            HeadLine(date: parseDate("2018-5-22"), title: "title2", text: "bbbbbbbbbbbbbbbb", image: "user"),
            HeadLine(date: parseDate("2017-5-23"), title: "title3", text: "cccccccccccccccc", image: "lock"),
            HeadLine(date: parseDate("2018-5-24"), title: "title4", text: "dddddddddddddddd", image: "manager"),
            HeadLine(date: parseDate("2018-5-25"), title: "title5", text: "eeeeeeeeeeeeeeee", image: "oka"),
            HeadLine(date: parseDate("2018-5-26"), title: "title6", text: "ffffffffffffffff", image: "omura"),
            HeadLine(date: parseDate("2018-5-22"), title: "title7", text: "ffffffffffffffff", image: "endo"),
        ]
        
        self.sections = TableSection.group(rowItems: self.headlines, by: { (headline) in
            firstDayOfMonth(date: headline.date)
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = section.sectionItem
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rowItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let section = self.sections[indexPath.section]
        let headline = section.rowItems[indexPath.row]
        cell.textLabel?.text = headline.title
        cell.detailTextLabel?.text = headline.text
        cell.imageView?.image = UIImage(named: headline.image)
        
        return cell
        
    }
    
    
}
