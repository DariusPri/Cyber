//
//  PreviewTutorialViewController.swift
//  Xpert
//
//  Created by Darius on 21/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PreviewTutorialViewController: UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle { return statusBarStyle }
    
    var statusBarStyle : UIStatusBarStyle = .default
        
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.bgColor
        return view
    }()
    
    let textContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        view.layer.borderWidth = 1 
        return view
    }()
    
    let tutorialImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let imageViewScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 2.5
        scrollView.zoomScale = 1
        scrollView.contentScaleFactor = 1
        scrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return scrollView
    }()
    
    let explainerTextView : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let redIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "indicator_red")
        imageView.contentMode = .center
        return imageView
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.secondaryButtonColor
        button.layer.cornerRadius = 3
        return button
    }()
    
    var initialRect : CGRect = .zero
    var hideImageView : UIView?
    
    init(image: UIImage, imageFrame: CGRect, text: String, imageView : UIImageView?, hidenImageView : UIView?) {
        super.init(nibName: nil, bundle: nil)
        explainerTextView.text = text
        tutorialImageView.image = image
        initialRect = imageFrame
        hideImageView = hidenImageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        explainerTextView.font = explainerTextView.font?.withSize(view.getCorrectSize(17, 17, 22))

        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
                
        view.addSubview(imageViewScrollView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: imageViewScrollView)
        
        view.addSubview(textContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: textContainerView)
        view.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: imageViewScrollView, textContainerView)
        
        imageViewScrollView.delegate = self
        imageViewScrollView.addSubview(tutorialImageView)
        imageViewScrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: tutorialImageView)
        imageViewScrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: tutorialImageView)

        let innerContainerView = UIView()
        textContainerView.addSubview(innerContainerView)
        if view.isHugeScreenSize == true {
            textContainerView.addConstraintsWithFormat(format: "H:[v0(\(view.bounds.size.width * 0.6))]", views: innerContainerView)
            NSLayoutConstraint(item: innerContainerView, attribute: .centerX, relatedBy: .equal, toItem: textContainerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        } else {
            textContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: innerContainerView)
        }
        textContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: innerContainerView)

        innerContainerView.addSubview(explainerTextView)
        innerContainerView.addSubview(redIconImageView)
        
        innerContainerView.addConstraintsWithFormat(format: "H:|-30-[v0(\(view.getCorrectSize(5, 5, 8)))]-\(view.getCorrectSize(15, 15, 20))-[v1]-30-|", views: redIconImageView, explainerTextView)
        innerContainerView.addConstraintsWithFormat(format: "V:|-\(view.getCorrectSize(35, 35, 42))-[v0(\(view.getCorrectSize(5, 5, 8)))]", views: redIconImageView)
        innerContainerView.addConstraintsWithFormat(format: "V:|-25-[v0]", views: explainerTextView)
        explainerTextView.bottomAnchor.constraint(equalTo: innerContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true

        view.addSubview(closeButton)
        closeButton.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "closeimg_ic_huge") : #imageLiteral(resourceName: "closeimg_ic"), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addConstraintsWithFormat(format: "H:[v0(\(view.getCorrectSize(30, 30, 42)))]-\(view.getCorrectSize(20, 20, 32))-|", views: closeButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(view.getCorrectSize(30, 30, 42)))]", views: closeButton)

        let guide = self.view.safeAreaLayoutGuide
        closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: view.getCorrectSize(14, 14, 20)).isActive = true
        
        explainerTextView.sizeToFit()
        explainerTextView.layoutIfNeeded()
        
        setScrollViewScale()
        
    }
    
    func setScrollViewScale() {
        let minScale = imageViewScrollView.frame.size.width / tutorialImageView.frame.size.width;
        imageViewScrollView.minimumZoomScale = minScale
        imageViewScrollView.maximumZoomScale = 3.0
        imageViewScrollView.contentSize = imageViewScrollView.frame.size
        imageViewScrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) { imageViewScrollView.automaticallyAdjustsScrollIndicatorInsets = false }
    }
    
    var textViewHeightConstraint : NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setZoomScale()
    }
    
    func setZoomScale() {
        let imageViewSize = tutorialImageView.bounds.size
        let scrollViewSize = imageViewScrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        imageViewScrollView.minimumZoomScale = min(widthScale, heightScale)
        imageViewScrollView.zoomScale = 1.0
        imageViewScrollView.setZoomScale(min(widthScale, heightScale), animated: false)
        imageViewScrollView.applyZoomToImageView()
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PreviewTutorialViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return tutorialImageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.applyZoomToImageView()
    }
}

extension PreviewTutorialViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(forTransitionType: .dismissing)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(forTransitionType: .presenting)
    }
    
}



enum TransitionType {
    case presenting, dismissing
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.4
    var isPresenting: Bool
    
    init(forTransitionType type: TransitionType) {
        self.isPresenting = type == .presenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func statusBarStyle(for presenting : Bool, with vc : UIViewController?) -> UIStatusBarStyle {
        if presenting == true {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        } else {
            if #available(iOS 12.0, *) {
                
                if vc?.traitCollection.userInterfaceStyle == .dark {
                    return .lightContent
                } else {
                    if #available(iOS 13.0, *) {
                        return .darkContent
                    } else {
                        return .default
                    }
                }
            }
        }
        return .default
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
                
        var previewTutorialVC : PreviewTutorialViewController?
        
        var centerBefore : CGPoint = .zero
        var centerAfter : CGPoint = .zero
                
        if self.isPresenting {
            containerView.addSubview(toVC.view)
            containerView.layoutIfNeeded()
            previewTutorialVC = (toVC as! PreviewTutorialViewController)
            centerBefore = CGPoint(x: previewTutorialVC!.initialRect.midX, y: previewTutorialVC!.initialRect.midY)
            centerAfter = previewTutorialVC!.imageViewScrollView.center
          } else {
            previewTutorialVC = (fromVC as! PreviewTutorialViewController)
            centerBefore = previewTutorialVC!.imageViewScrollView.center
            centerAfter = CGPoint(x: previewTutorialVC!.initialRect.midX, y: (previewTutorialVC!.initialRect.midY ))
          }
        
        previewTutorialVC?.hideImageView?.alpha = 1
                  
        previewTutorialVC?.statusBarStyle = statusBarStyle(for: self.isPresenting, with: previewTutorialVC)
        previewTutorialVC?.containerView.alpha = isPresenting == true ? 0 : 1
        previewTutorialVC?.closeButton.alpha = self.isPresenting == true ? 0 : 1
        previewTutorialVC?.textContainerView.transform = isPresenting == true ? CGAffineTransform(translationX: 0, y: previewTutorialVC?.textContainerView.frame.size.height ?? 0) : .identity
        previewTutorialVC?.imageViewScrollView.center = centerBefore
    
  
        let scale1 = previewTutorialVC!.initialRect.width / previewTutorialVC!.imageViewScrollView.bounds.size.width
        let scale2 = previewTutorialVC!.initialRect.height / previewTutorialVC!.imageViewScrollView.bounds.size.height
        let scale = max(scale1, scale2)
        previewTutorialVC!.imageViewScrollView.transform = isPresenting == true ? .init(scaleX: scale, y: scale) : .identity
    
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            previewTutorialVC?.setNeedsStatusBarAppearanceUpdate()
            previewTutorialVC?.imageViewScrollView.setZoomScale(previewTutorialVC!.imageViewScrollView.minimumZoomScale, animated: true)
            previewTutorialVC?.imageViewScrollView.center = centerAfter
            previewTutorialVC!.imageViewScrollView.transform = self.isPresenting != true ? .init(scaleX: scale, y: scale) : .identity
            previewTutorialVC?.containerView.alpha = self.isPresenting == true ? 1 : 0
            previewTutorialVC?.closeButton.alpha = self.isPresenting == true ? 1 : 0
            previewTutorialVC?.textContainerView.transform = self.isPresenting == true ? .identity : CGAffineTransform(translationX: 0, y: previewTutorialVC?.textContainerView.frame.size.height ?? 0)
        }) { (_) in
            if self.isPresenting == false { previewTutorialVC?.hideImageView?.alpha = 0 }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
