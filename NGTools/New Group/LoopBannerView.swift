//
//  LoopBannerView.swift
//

import UIKit

protocol LoopBannerViewDelegate: NSObjectProtocol {
    func loopBannerViewDidSelectIndex(_ index: Int)
}

class LoopBannerView: UIView {

    enum SliderViewState {
        case none
        case stopped
        case sliding
    }

    var delegate: LoopBannerViewDelegate?
    fileprivate let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var sliderArray = [String]()        // slider urls
    var currentPage = -1
    var interval = 4
    fileprivate var state = SliderViewState.none
    fileprivate var timer: Timer?
    fileprivate var placeholder: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        scrollView.delegate = nil
        timer?.invalidate()
        timer = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
    }
}

extension LoopBannerView {
    fileprivate func setupViews() {

        isUserInteractionEnabled = true
        backgroundColor = UIColor.white

        scrollView.frame = bounds
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.autoresizesSubviews = true
        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: 0xFF)
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentMode = .center
        scrollView.contentSize = CGSize(width: width, height: height)
        addSubview(scrollView)

        pageControl.frame = CGRect(x: (width - 120.0) * 0.5, y: height - 6 - 12, width: 120, height: 12)
        pageControl.currentPageIndicatorTintColor = UIColor.black.withAlphaComponent(0.5)
        pageControl.pageIndicatorTintColor = UIColor.yellow.withAlphaComponent(0.5)
        pageControl.isUserInteractionEnabled = false
        pageControl.isHidden = true
        addSubview(pageControl)

        let tapG = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapG)

        state = .none
    }
}

extension LoopBannerView {

    func setPlaceholder(_ str: String) {
        placeholder = str
        reloadViewUrls([str])
    }

    func reloadViewUrls(_ urlStrArray: [String]) {
        autoProofead()

        if urlStrArray.count > 0 {
            var tempArray = [String]()

            if urlStrArray.count == 1 {
                scrollView.isScrollEnabled = false

                tempArray = urlStrArray
            } else {
                scrollView.isScrollEnabled = true

                tempArray.append(urlStrArray.last!)
                for item in urlStrArray {
                    tempArray.append(item)
                }
                tempArray.append(urlStrArray.first!)
            }

            sliderArray = tempArray
            addScrollViews()
        } else {
            scrollView.isScrollEnabled = false
        }
    }

    private func addScrollViews() {
        scrollView.removeAllSubViews()

        scrollView.contentSize = CGSize(width: width * CGFloat(sliderArray.count), height: height)
        for item in sliderArray.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(item.offset) * width, y: 0, width: width, height: height))
//            let url = URL(string: sliderArray[item.offset])
//            if let holder = placeholder {
//                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: holder))
//            }else {
//                imageView.sd_setImage(with: url)
//            }
            scrollView.addSubview(imageView)
        }

        var pageCount = sliderArray.count
        if pageCount > 1 {
            pageCount -= 2
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        }

        if pageCount < 2 {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        currentPage = 0
    }

    @objc fileprivate func tapAction() {
        delegate?.loopBannerViewDidSelectIndex(currentPage)
    }
}

extension LoopBannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if sliderArray.count > 1 {

            // 偏移量 让滚动都是从第二张起始
            let offsetX = scrollView.contentOffset.x - scrollView.width
            let pageInt = Int(round(offsetX / scrollView.frame.size.width))

            var shouldCurrentPage = 0
            if pageInt == sliderArray.count - 2 {
                shouldCurrentPage = 0
            } else if pageInt == -1 {
                shouldCurrentPage = sliderArray.count - 2 - 1
            } else {
                shouldCurrentPage = Int(round(offsetX / scrollView.width))
            }

            if pageControl.currentPage != shouldCurrentPage {
                pageControl.currentPage = shouldCurrentPage
                currentPage = pageControl.currentPage
            }

            // 右移如果pageInt为－1 偏移量等于或小于一页的宽度scrollview就偏移到启示页（小于或等于浮点数是为了流畅度）
            if offsetX <= width * CGFloat(pageInt) && pageInt == -1 {
                scrollView.contentOffset = CGPoint(x: width * CGFloat(sliderArray.count - 2), y: 0)
            }
            // 左移
            if offsetX >= width * CGFloat(sliderArray.count - 2)
                && pageInt == sliderArray.count - 2 {
                scrollView.contentOffset = CGPoint(x: width, y: 0)
            }

            // 控制不能上下移动
            let tempPoint = scrollView.contentOffset
            scrollView.contentOffset = CGPoint(x: tempPoint.x, y: 0)

            // 如果有拖动的动作，重置计时器
            if state == .sliding && scrollView.isDragging {
                timer?.fireDate = Date.distantFuture
            }

        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isDragging == false {
            timer?.fireDate = Date.distantPast
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = nearestTargetOffset(targetContentOffset.pointee)
        targetContentOffset.pointee.x = targetOffset.x
        targetContentOffset.pointee.y = targetOffset.y
    }

    fileprivate func nearestTargetOffset(_ offset: CGPoint) -> CGPoint {
        let pageSize = width
        let page = round(offset.x / pageSize)
        let targetX = pageSize * page
        return CGPoint(x: targetX, y: offset.y)
    }
}

extension LoopBannerView {

    func startSliding() {
        if  sliderArray.count != 0 && sliderArray.count != 1 {
            timer = Timer(timeInterval: TimeInterval(interval), target: self, selector: #selector(sliding), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
            state = .sliding
        }
    }

    /// at viewdiddisappear use to deal with circle quote
    func cancelSliding() {
        timer?.invalidate()
        timer = nil
        state = .stopped
    }

    @objc fileprivate func sliding() {

        if state == .stopped {
            return
        }

        var offsetX = scrollView.contentOffset.x
        let page = Int(offsetX / width)

        // 可能会出现偏移不到一张的宽度倍数
        if (offsetX - CGFloat(page) * width) > 0 {
            let move = CGFloat(page + 1) * width - offsetX
            offsetX += move
        } else {
            offsetX += width
        }

        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }

    }

    /// 自动对齐，处理在页面切换过程中图片的偏移，适合在viewwillappear中使用
    func autoProofead() {
        if sliderArray.count != 0 && sliderArray.count != 1 {
            var offsetX = scrollView.contentOffset.x
            let page = Int(offsetX / width)

            // 可能会出现偏移不到一张的宽度倍数
            if (offsetX - CGFloat(page) * width) > 0 {
                let move = CGFloat(page + 1) * width - offsetX
                offsetX += move
                scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
            }
        }
    }
}
