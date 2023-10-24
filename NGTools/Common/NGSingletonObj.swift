//
//

import UIKit
import AVFoundation
import AssetsLibrary
import ContactsUI

class NGSingletoObj: NSObject {
    static let shared = NGSingletoObj()
    private override init() {
        
    }
    
    /// imagepicker
    var imagePicker:UIImagePickerController?
    var imagePickerCall: ((_ image: UIImage)->())?
    var secondNavigationController:UINavigationController?
    
    // addressbook
    @available(iOS 9.0, *)
    lazy var addressBook = CNContactPickerViewController()
    
    
}


// take picture
extension NGSingletoObj: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func setupImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.modalPresentationStyle = .popover
    }
    
    func TakeAPicture(_ viewController:UIViewController, call:@escaping (_ image: UIImage)->()){
        self.imagePickerCall = call
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pictureA = UIAlertAction(title: "拍照", style: .default) {[weak self] (_) in
            self?.imagePickerAction(viewController, .camera)
        }
        let cameraA = UIAlertAction(title: "从相册选取", style: .default) {[weak self] (_) in
            self?.imagePickerAction(viewController, .photoLibrary)
        }
        let cancelA = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(pictureA)
        alert.addAction(cameraA)
        alert.addAction(cancelA)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func pickDismiss(_ sender:UIView){
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissAction(_ sender:UIView){
        _ = secondNavigationController?.popViewController(animated: true)
    }
    
    // delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
//        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        secondNavigationController = navigationController
        
        if navigationController.viewControllers.count > 1{
            
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            btn.contentMode = .scaleAspectFit
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
            btn.setImage(UIImage(named: "navi_backBtn"), for: .normal)
            btn.setImage(UIImage(named: "navi_backBtn"), for: .highlighted)
            btn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
            
            let lb = UIBarButtonItem(customView: btn)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -10
            viewController.navigationItem.leftBarButtonItems = [negativeSpacer, lb]
            
        }
        
        viewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        //        let rightItem = UIBarButtonItem(title: "取消1", style: .plain, target: self, action: #selector(pickDismiss(_:)))
        //        viewController.navigationItem.rightBarButtonItem = rightItem
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    fileprivate func imagePickerAction(_ viewController: UIViewController, _ sourceType: UIImagePickerController.SourceType){
        guard let imageP = self.imagePicker else {
            return
        }
        
        switch sourceType {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if status == .restricted || status == .denied {
                let alert = UIAlertController(title: nil, message: "请在iPhone的设置选项中，允许 电商钱包 访问您的相机", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(action)
                viewController.present(alert, animated: true, completion: nil)
            }else {
                imageP.sourceType = sourceType
                viewController.present(imageP, animated: true, completion: nil)
            }
        case .photoLibrary:
            let status = ALAssetsLibrary.authorizationStatus()
            if status == .restricted || status == .denied {
                let alert = UIAlertController(title: nil, message: "请在iPhone的设置选项中，允许 电商钱包 访问您的相册", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(action)
                viewController.present(alert, animated: true, completion: nil)
            }else {
                imageP.sourceType = sourceType
                viewController.present(imageP, animated: true, completion: nil)
            }
        default:
            break
        }
        
    }
    
    
    /// delegate
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        printLog(info)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage,
            let call = self.imagePickerCall else {
                return
        }
        call(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension NGSingletoObj {
    
    func isNewVersion()-> Bool{
        var isNew = true
        let versionName = "CFBundleVersion"
        if let currentVersion = Bundle.main.infoDictionary?[versionName] as? String {
            if let lastVersion = UserDefaults.standard.string(forKey: "CFBundleVersion") {
                //                printLog(lastVersion)
                //                printLog(currentVersion)
                if lastVersion == currentVersion {
                    isNew = false
                }else {
                    UserDefaults.standard.set(currentVersion, forKey: versionName)
                }
            }else {
                UserDefaults.standard.set(currentVersion, forKey: versionName)
            }
        }
        return isNew
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}


extension NGSingletoObj {
    
    func addressBookAuthentication(){
        
        
    }
    
}
