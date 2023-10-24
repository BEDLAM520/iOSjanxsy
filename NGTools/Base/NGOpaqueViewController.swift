//
//

import UIKit

/*
 该控制器主要处理需要导航栏渐变
 */

class NGOpaqueViewController: NGBaseViewController {

    open var naviBar: UIView?
    open var titleLabel: UILabel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        naviBar = UIView()
        view.addSubview(naviBar!)
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: NaviBarTitleFontSize)
        label.textColor = NaviBarTitleColor
        titleLabel = label
        view.addSubview(label)
        
        view.addmoreEqualConstrain(item: naviBar!, toItem: view, attribute: .top, .left, .right)
        view.addConstraint(item: naviBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64)
        
        view.addmoreEqualConstrain(item: titleLabel!, toItem: naviBar!, attribute: .centerX)
        view.addConstraint(item: titleLabel!, attribute: .top, relatedBy: .equal, toItem: naviBar!, attribute: .top, multiplier: 1.0, constant: 20)
        view.addConstraint(item: titleLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navi = naviBar {
            view.bringSubviewToFront(navi)
        }
    }

}
