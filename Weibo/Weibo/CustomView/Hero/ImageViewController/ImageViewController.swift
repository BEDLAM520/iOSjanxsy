// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Kingfisher

class ImageViewController: UICollectionViewController, StoryboardBased {
    var selectedIndex: IndexPath?
    var panGR = UIPanGestureRecognizer()
    var imageLibrary = [ImageNameModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.neverAdjustsScrollViewInsets()
        preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.width)

        view.layoutIfNeeded()
        collectionView!.reloadData()
        if let selectedIndex = selectedIndex {
            collectionView!.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        }

        panGR.addTarget(self, action: #selector(pan))
        panGR.delegate = self
        collectionView?.addGestureRecognizer(panGR)

        let saveBtn = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        saveBtn.backgroundColor = UIColor.red
        saveBtn.addTarget(self, action: #selector(savePicture), for: .touchUpInside)
        view.addSubview(saveBtn)
    }

    @objc private func savePicture() {
        guard let array = collectionView?.visibleCells,
            let cell = array.first as? ScrollingImageCell,
            let image = cell.imageView.image else {
                return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            UIView.windowAdddStatusTextHUD("保存失败")
        }else{
            UIView.windowAdddStatusTextHUD("保存成功")
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for v in (collectionView!.visibleCells as? [ScrollingImageCell])! {
            v.topInset = topLayoutGuide.length
        }
    }

    @objc func pan() {
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / collectionView!.bounds.height
        switch panGR.state {
        case .began:
            hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            if let cell = collectionView?.visibleCells[0]  as? ScrollingImageCell {
                let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: cell.imageView)
            }
        default:
            if progress + panGR.velocity(in: nil).y / collectionView!.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}

extension ImageViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLibrary.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? ScrollingImageCell)!
        var model = imageLibrary[indexPath.item]
        imageCell.imageView.hero.id = model.heroID

        imageCell.imageView.hero.modifiers = [.position(CGPoint(x: view.bounds.width/2,
                                                                y: view.bounds.height+view.bounds.width/2)),
                                              .scale(0.6),
                                              .fade]
        imageCell.topInset = topLayoutGuide.length
        imageCell.imageView.isOpaque = true

        switch model.type {
        case .name:
            imageCell.image = UIImage(named: model.name)
        case .url:
            let url = URL(string: model.name)
            imageCell.imageView.kf.setImage(with: url, placeholder: model.placeholder,
                                            options: [],
                                            progressBlock: nil,
                                            completionHandler: { (image, _, _, _) in
                                                image.flatMap {imageCell.image = $0}
                                                imageCell.indicator.stopAnimating()
                                                model.haveLoaded = true
            })

            imageCell.indicator.isHidden = model.haveLoaded
            if model.haveLoaded {
                imageCell.indicator.stopAnimating()
            } else {
                imageCell.indicator.startAnimating()
            }
        case .image:
            imageCell.image = model.image
        }

        return imageCell
    }
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
}

extension ImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let cell = collectionView?.visibleCells[0] as? ScrollingImageCell,
            cell.scrollView.zoomScale == 1 {
            let v = panGR.velocity(in: nil)
            return v.y > abs(v.x)
        }
        return false
    }
}
