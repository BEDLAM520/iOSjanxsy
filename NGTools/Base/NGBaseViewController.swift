//
//

import UIKit


class NGBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 取消子视图中滚动视图的自动设置内边距
        if self.responds(to: #selector(getter: UIViewController.automaticallyAdjustsScrollViewInsets)) == true {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.backgroundColor = UIColor.white
        
        
        addBackButton()
    }
    
}


extension  UIViewController {
    
    
    /// 添加自定义返回按钮
     func addBackButton() -> (){
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.contentMode = .scaleAspectFit
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        btn.setImage(UIImage(named: "navi_backBtn"), for: .normal)
        btn.setImage(UIImage(named: "navi_backBtn"), for: .highlighted)
        btn.addTarget(self, action: #selector(UIViewController.backButtonAction), for: .touchUpInside)
        
        let lb = UIBarButtonItem(customView: btn)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        navigationItem.leftBarButtonItems = [negativeSpacer, lb]
    }
    
    
    /// 隐藏返回按钮
    open func hiddenBackBtn() -> (){
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        navigationItem.leftBarButtonItems = [negativeSpacer]
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc open func backButtonAction(){
        view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    

}
