import UIKit

struct scrollViewDataStruct {
    let title: String?
    let placeHolder: String?
}

class testScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollData = [scrollViewDataStruct]()
    
    var viewTagValue = 100
    var tagValue = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        scrollData = [
            scrollViewDataStruct(title: "title1", placeHolder: "textview1"),
            
            scrollViewDataStruct(title: "title2", placeHolder: "textview2"),
            scrollViewDataStruct(title: "title3", placeHolder: "textview3"),
            scrollViewDataStruct(title: "title4", placeHolder: "textview4"),
            scrollViewDataStruct(title: "title5", placeHolder: "textview5"),
            scrollViewDataStruct(title: "title6", placeHolder: "textview6"),
        ]
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(scrollData.count)
        
        var i = 0
        
        for data in scrollData {
            let view = CustomView(frame: CGRect(x: 10 + (self.scrollView.frame.width * CGFloat(i)), y: 0, width: self.scrollView.frame.width - 20, height: self.scrollView.frame.height))
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
                
                var scrollContentOffset = scrollView.contentOffset.x + self.scrollView.frame.width
                var viewOffset = (view.center.x - scrollView.bounds.width / 4) - scrollContentOffset
                label.center.x = scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2)
            }
        }
    }
}


class CustomView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.gray
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

