import UIKit



class addDiaryViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        for i in 0 ..< 4 {
            
            let labelText = UILabel()
            labelText.text = "\(i + 1)番目"
            scrollView.addSubview(labelText)
            
            let xCoodinate = view.frame.midX + view.frame.width * CGFloat(i)
            
            contentWidth += view.frame.width
            
            labelText.frame = CGRect(x: xCoodinate - 50, y: view.frame.height / 2, width: 100, height: 100)
        }
        
        
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
    }
    
}
