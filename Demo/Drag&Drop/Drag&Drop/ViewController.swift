//
//  ViewController.swift
//  Drag&Drop
//
//  Created by  user on 2018/8/29.
//  Copyright © 2018  user. All rights reserved.
//

import UIKit
import TestFramework

//  两种移动
class CellLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        print(String.name())
        itemSize = CGSize(width: 80, height: 80)
        minimumLineSpacing = 15
        minimumInteritemSpacing = 15
        sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ViewController: UIViewController {
    var dataSource = [[String]]()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<20 {
            var arr = [String]()
            for itemSub in 0..<20 {
                arr.append(itemSub.description)
            }
            dataSource.append(arr)
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CellLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //        collectionView.dragDelegate = self
        //        collectionView.dropDelegate = self
        //        collectionView.dragInteractionEnabled = true
        //        collectionView.reorderingCadence = .immediate
        //        collectionView.isSpringLoaded = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "resi")
        view.addSubview(collectionView)
        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        collectionView.addGestureRecognizer(ges)
        
        
        let btn = UIButton(frame: CGRect(x: 200, y: 200, width: 40, height: 40))
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(nextmove), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func nextmove() {
        let vc = ImageViewMoveVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func longPress(ges: UILongPressGestureRecognizer) {
        switch ges.state {
        case .began:
         let touchPoint = ges.location(in: self.collectionView)
         if let selectIndexpath = collectionView.indexPathForItem(at: touchPoint) {
            collectionView.beginInteractiveMovementForItem(at: selectIndexpath)
            }
        case .changed:
            let touchPoint = ges.location(in: self.collectionView)
            collectionView.updateInteractiveMovementTargetPosition(touchPoint)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
            break
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resi", for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        if cell.contentView.subviews.count == 0 {
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = "\(indexPath.section) -- \(indexPath.row)"
            label.textAlignment = .center
            cell.contentView.addSubview(label)
        }
        for item in cell.contentView.subviews {
            if let item = item as? UILabel {
                item.text = "\(indexPath.section) -- \(indexPath.row)"
            } 
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let name = dataSource[sourceIndexPath.section][sourceIndexPath.row]
        self.dataSource[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        self.dataSource[destinationIndexPath.section].insert(name, at: destinationIndexPath.item)
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let name = "\(indexPath.section) -- \(indexPath.row)"
        let itemProvider = NSItemProvider(object: name as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = name
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: String.self)
    }
    
    // 是否是同一个app
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: session.localDragSession == nil ? .copy : .move, intent: .insertAtDestinationIndexPath);
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexpath = coordinator.destinationIndexPath != nil ? coordinator.destinationIndexPath! : IndexPath(item: 0, section: 0)
        if coordinator.items.count == 1 && coordinator.items.first?.sourceIndexPath != nil {
            guard let sourceIndexpath = coordinator.items.first?.sourceIndexPath,
                let drapItem = coordinator.items.first?.dragItem else {
                    return
            }
            collectionView.performBatchUpdates({
                if let name = coordinator.items.first?.dragItem.localObject as? String {
                    self.dataSource[sourceIndexpath.section].remove(at: sourceIndexpath.item)
                    self.dataSource[destinationIndexpath.section].insert(name, at: destinationIndexpath.item)
                    collectionView.moveItem(at: sourceIndexpath, to: destinationIndexpath)
                }
            }, completion: nil)
            coordinator.drop(drapItem, toItemAt: destinationIndexpath)
        }
    }
}

