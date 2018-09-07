//
//  ImageViewMoveVC.swift
//  Drag&Drop
//
//  Created by  user on 2018/8/30.
//  Copyright © 2018  user. All rights reserved.
//

import UIKit

class ImageViewMoveVC: UINavigationController {
    
    var imagev: UIImageView!
    var dropImagev: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        guard let image = UIImage(named: "1688") else {
            return
        }
        imagev = UIImageView(image: image)
        imagev.isUserInteractionEnabled = true
        imagev.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: image.size)
        view.addSubview(imagev)
        
        let dragInter = UIDragInteraction(delegate: self)
        dragInter.isEnabled = true
        imagev.addInteraction(dragInter)
        
        let dropInter = UIDropInteraction(delegate: self)
        view.addInteraction(dropInter)
        
        dropImagev = UIImageView(frame: CGRect(origin: CGPoint(x: 100, y: 500), size: image.size))
        dropImagev.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        view.addSubview(dropImagev)
        
        let btn = UIButton(frame: CGRect(x: 200, y: 350, width: 40, height: 40))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func add() {
        dismiss(animated: true, completion: nil)
        
    }
}

extension ImageViewMoveVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let imageview = interaction.view as? UIImageView,
            let image = imageview.image {
            dropImagev.image = nil
            let itemProvider = NSItemProvider(object: image)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let param = UIDragPreviewParameters()
        param.visiblePath = UIBezierPath(roundedRect: imagev.bounds, cornerRadius: 20)
        let target = UIDragPreviewTarget(container: self.imagev.superview!, center: imagev.center)
        if let inview = interaction.view {
            let dragepreview = UITargetedDragPreview(view: inview, parameters: param, target: target)
            return dragepreview
        } else {
            return nil
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        animator.addCompletion { (finialPosition) in
            if finialPosition == UIViewAnimatingPosition.end {
                self.imagev.alpha = 0.5
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        UIView.animate(withDuration: 0.5) {
            self.imagev.alpha = 1
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        animator.addAnimations {
            self.imagev.alpha = 0.1
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        UIView.animate(withDuration: 0.5) {
            self.imagev.alpha = 1
        }
    }
}

extension ImageViewMoveVC: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if session.localDragSession == nil {
            return false
        }
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let opera = session.localDragSession == nil ? UIDropOperation.cancel : UIDropOperation.copy
        return UIDropProposal(operation: opera)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if session.localDragSession != nil {
            _ = session.loadObjects(ofClass: UIImage.self) { (arr) in
                for item in arr {
                    if let image = item as? UIImage {
                        self.dropImagev.image = image
                    }
                }
            }
        }
    }
}
