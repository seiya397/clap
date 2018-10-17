import UIKit

struct scrollViewDataStruct {
    let title: String?
    let placeHolder: String?
}

class testScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollData = [scrollViewDataStruct]()
    
    var viewTagValue = 100
    var tagValue = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.gray
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        scrollData = [
            scrollViewDataStruct(title: "今日のタイトル", placeHolder: "textview1"),
            
            scrollViewDataStruct(title: "仲間へ一言", placeHolder: "textview2"),
            scrollViewDataStruct(title: "監督へのメッセージ", placeHolder: "textview3"),
            scrollViewDataStruct(title: "明日の課題", placeHolder: "textview4"),
            scrollViewDataStruct(title: "今日の成果", placeHolder: "textview5"),
            scrollViewDataStruct(title: "今後の課題", placeHolder: "textview6"),
        ]
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(scrollData.count)
        
        var i = 0
        
        for data in scrollData {
            let view = CustomView(frame: CGRect(x: 5 + (self.scrollView.frame.width * CGFloat(i)), y: 0, width: self.scrollView.frame.width - 10, height: self.scrollView.frame.height))
            view.textView.text = data.placeHolder
            view.tag = i + viewTagValue
            self.scrollView.addSubview(view)
            
            let label = UILabel(frame: CGRect.init(origin: CGPoint.init(x: view.center.x, y: 20), size: CGSize.init(width: 0, height: 40)))
            label.text = data.title
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.sizeToFit()
            label.tag = i + tagValue
            if i == 0 {
                label.center.x = view.center.x
            } else {
                label.center.x = view.center.x - self.scrollView.frame.width / 2
            }
            label.textColor = UIColor.gray
            self.scrollView.addSubview(label)
            
            i += 1
        }
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            for i in 0 ..< scrollData.count {
                let label = scrollView.viewWithTag(i + tagValue) as! UILabel
                let view = scrollView.viewWithTag(i + viewTagValue) as! CustomView
                
                let scrollContentOffset = scrollView.contentOffset.x + self.scrollView.frame.width
                let viewOffset = (view.center.x - scrollView.bounds.width / 4) - scrollContentOffset
                label.center.x = scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}



class CustomView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 100).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

