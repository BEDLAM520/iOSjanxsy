//
//

import UIKit

class BaseViewController: UIViewController {
    
    fileprivate lazy var popTipLabel = { () -> UILabel in
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 64 - 40, width: UIScreen.main.bounds.width, height: 40)
        label.backgroundColor = UIColor.green
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.isHidden = true
        //        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate var haveAddTipLabel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


extension BaseViewController {
    
    func showTip(string: String){
        if haveAddTipLabel == false {
            haveAddTipLabel = true
            view.addSubview(popTipLabel)
        }
        
        popTipLabel.text = string
        
        var frame = popTipLabel.frame
        frame.origin.y = CGFloat(64)
        popTipLabel.isHidden = false
        
        
        UIView.animateKeyframes(withDuration: 1.6, delay: 0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                self.popTipLabel.frame = frame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15, animations: {
                frame.origin.y = 64 - frame.height
                self.popTipLabel.frame = frame
            })
            
        }) { (_) in
            self.popTipLabel.isHidden = true
        }
        
    }
    
}
