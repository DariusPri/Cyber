//
//  TutorialViewController.swift
//  Xpert
//
//  Created by Darius on 20/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - Explainer Popup for Assesment 

class ExplainerViewController: CardViewController, UIPopoverPresentationControllerDelegate {
    
    let rect : CGRect
    let fromVC : UIViewController
    
    init(forTextExplainer data: TutorialViewController.TutorialCardData, rect : CGRect, present from : UIViewController) {
        self.rect = rect
        self.fromVC = from
        super.init(forTextExplainer: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceRect = rect
        popoverPresentationController?.sourceView = fromVC.view
        popoverPresentationController?.backgroundColor = .white
        popoverPresentationController?.passthroughViews = nil

        nextButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}




class TutorialViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    struct TutorialCardData {
        var title : String
        var subtitle : String
        var highlightFrames : [CGRect]
        var arrowView : UIView?
    }
    
    var tutorialDataArray : [TutorialCardData] = []
    var currentIndex : Int = 0
    
    let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor =  UIColor(named: "tutorialContainerBgColor")
        
        self.containerView.alpha = 0

        view.backgroundColor = .clear
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
    }
    
    var highlightImageViews : [UIImageView] = []
    
    func setupData() {
        var scoreLabel : UILabel!
        
        var frames1 : [CGRect] = []
        
        if let dashboardVC = (((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UINavigationController)?.viewControllers.first as? DashboardTabBarController)?.dashboardVC {
            let scoreCell = dashboardVC.dashboardCollectionViewController.collectionView!.cellForItem(at: IndexPath(item: 0, section: 0)) as! SecurityScoreCell
            var frame = dashboardVC.dashboardCollectionViewController.collectionView!.convert(scoreCell.loader!.frame, to: self.view)
            frame.origin.x = (self.view.bounds.width / 2) - (frame.size.width / 2)
            frames1.append(frame.insetBy(dx: 0, dy: 0))
            var frame2 = dashboardVC.dashboardCollectionViewController.collectionView!.convert(scoreCell.explainerLabel.frame.insetBy(dx: -20, dy: 0), to: self.view)
            frame2.origin.x = (self.view.bounds.width / 2) - (frame2.size.width / 2)
            frames1.append(frame2.insetBy(dx: -6, dy: -6))
            scoreLabel = scoreCell.explainerLabel
        }
        
        let tabBar = (((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! UINavigationController).viewControllers.first as! DashboardTabBarController).tabBar
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
        let items : [UIView] = interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
        
        let itemFrames = items.map({ tabBar.convert($0.frame, to: self.view) })
        
        tutorialDataArray = [TutorialCardData(title: Localization.shared.tour_mobile_title_1, subtitle: Localization.shared.tour_mobile_description_1, highlightFrames: frames1, arrowView: scoreLabel),
                             TutorialCardData(title: Localization.shared.tour_mobile_title_4, subtitle: Localization.shared.tour_mobile_description_4, highlightFrames: [itemFrames[3]], arrowView: items[3]),
                             TutorialCardData(title: Localization.shared.tour_mobile_title_2, subtitle: Localization.shared.tour_mobile_description_2, highlightFrames: [itemFrames[0]], arrowView: items[0]),
                             TutorialCardData(title: Localization.shared.tour_mobile_title_3, subtitle: Localization.shared.tour_mobile_description_3, highlightFrames: [itemFrames[1]], arrowView: items[1]),
                             TutorialCardData(title: Localization.shared.forgot_our_support_is_always_there_in_case_you_need_help_, subtitle: Localization.shared.forgot_get_in_touch_with_our_team_of_cyber_security_exper, highlightFrames: [itemFrames[4]], arrowView: items[4])]
        setupNextCardIfNeeded()
    }
    
    var card : CardViewController?

    func setupNextCardIfNeeded() {
        
        if currentIndex >= tutorialDataArray.count { skipTutorial(); return }
        let data = tutorialDataArray[currentIndex]
        
        func presentCard() {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
            
            card = CardViewController(data: data, isLast: ((tutorialDataArray.count == (currentIndex + 1)) == true))
            card?.nextButton.addTarget(self, action: #selector(showNextCard), for: .touchUpInside)
            card?.skipButton.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
            card!.modalPresentationStyle = UIModalPresentationStyle.popover
            card!.popoverPresentationController?.permittedArrowDirections = currentIndex == 0 ? [.up] : [.up, .down]
            card!.popoverPresentationController?.delegate = self
            card!.popoverPresentationController?.sourceView = data.arrowView
            card!.popoverPresentationController?.sourceRect = currentIndex == 0 ? data.arrowView!.bounds.offsetBy(dx: 0, dy: 20) : data.arrowView!.bounds
            card!.popoverPresentationController?.backgroundColor = .white
            card!.popoverPresentationController?.passthroughViews = nil
            self.present(card!, animated: true, completion: nil)
            
            let layer = CALayer()
            layer.frame = data.highlightFrames.first!
            layer.fillMode = CAMediaTimingFillMode.forwards
            let path : UIBezierPath = UIBezierPath()
            for f in data.highlightFrames {
                if f.width == f.height || currentIndex > 0 {
                    let newRect = f.width == f.height ? f : CGRect(x: f.origin.x, y: f.origin.y, width: f.width, height: f.width)
                    path.append(UIBezierPath(roundedRect: newRect, cornerRadius: newRect.height/2))
                    let circle = UIImageView(image: #imageLiteral(resourceName: "circle_gradient"))
                    circle.contentMode = .scaleToFill
                    circle.backgroundColor = .clear
                    circle.frame = newRect
                    view.addSubview(circle)
                    highlightImageViews.append(circle)
                } else {
                    path.append(UIBezierPath(roundedRect: f, cornerRadius: 20))
                    let rectangle = UIImageView(image: #imageLiteral(resourceName: "rectangle_gradient"))
                    rectangle.contentMode = .scaleToFill
                    rectangle.backgroundColor = .clear
                    rectangle.frame = f
                    view.addSubview(rectangle)
                    highlightImageViews.append(rectangle)
                }
            }
            path.append(UIBezierPath(rect: self.view.bounds))
            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path.cgPath
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            
            containerView.layer.mask = maskLayer
        }
        
        
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                if #available(iOS 12.0, *) {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.containerView.alpha = 0.6
                    } else {
                        self.containerView.alpha = 1
                    }
                } else {
                    self.containerView.alpha = 1
                }
            }, completion: { _ in presentCard()})
        } else { presentCard() }
    }
    
    @objc func skipTutorial() {
        func dismiss() {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.alpha = 0
                self.containerView.layer.sublayers?.forEach({ $0.opacity = 0 })
                self.highlightImageViews.forEach({ $0.alpha = 0 })
            }) { (_) in
                self.containerView.layer.sublayers = []
                for i in self.highlightImageViews { i.removeFromSuperview() }
                self.highlightImageViews = []
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if let _ = card {
            card?.dismiss(animated: true, completion: {
                dismiss()
            })
        } else { dismiss() }
    }

    @objc func showNextCard() {
        
        card?.dismiss(animated: true, completion: {
            self.card = nil
            self.currentIndex += 1
            self.containerView.layer.sublayers = []
            for i in self.highlightImageViews { i.removeFromSuperview() }
            self.highlightImageViews = []
            self.setupNextCardIfNeeded()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.isUserTourDone != true {
            tutorialShownRequest { (success) in }
        }
        
        if card == nil { DispatchQueue.main.asyncAfter(deadline: .now()+3) { self.setupData() } }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func tutorialShownRequest(completion : @escaping ((Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.userTourShown.url() else { completion(false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "PATCH"
        
        let parameters: [String: Any] = ["value" : true]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())

        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                if let isTutorialShown = json_object["value"] as? Bool {
                    (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.isUserTourDone = isTutorialShown
                    completion(true)
                    return
                }
            } catch {}
            completion(false)
        }
    }
}

class CardViewController: UIViewController {
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let nextButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), textColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        return button
    }()
    
    lazy var skipButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.skip_tour.uppercased(), image: nil, backgroundColor: UIColor(red: 227/255, green: 241/255, blue: 249/255, alpha: 1), textColor: UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        return button
    }()
    
    let data : TutorialViewController.TutorialCardData
    
    init(forTextExplainer data : TutorialViewController.TutorialCardData) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        setupView()
        nextButton.setTitle("OK", for: .normal)
    }
    
    init(data : TutorialViewController.TutorialCardData, isLast last : Bool = false) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        setupView()
        if last != true {
            mainStack.addArrangedSubview(skipButton)
        } else {
            nextButton.setTitle(Localization.shared.finish.uppercased(), for: .normal)
        }
    }
    
    let mainStack = UIStackView()

    func setupView() {
        
        var width : CGFloat = view.isSmallScreenSize == true ? 340 : 420
        
        if width > view.bounds.size.width {
            width = view.bounds.size.width - 20
        }

        containerView.addSubview(subtitleLabel)
        mainStack.addArrangedSubview(nextButton)
        containerView.addSubview(mainStack)
        
        subtitleLabel.text = data.subtitle
        subtitleLabel.frame.size.width = 310
        subtitleLabel.sizeToFit()
        
        mainStack.axis = .horizontal
        mainStack.spacing = 15
        mainStack.sizeToFit()
        
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0(<=\(width))]-(0@600)-|", views: containerView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)

        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: subtitleLabel)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: mainStack)
        
        heightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        heightConstraint?.priority = .init(rawValue: 777)
        heightConstraint?.isActive = true
        
        if self.data.title != "" {
            titleLabel.text = data.title
            titleLabel.frame.size.width = 310
            titleLabel.sizeToFit()
            containerView.addSubview(titleLabel)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: titleLabel)
            containerView.addConstraintsWithFormat(format: "V:|-25-[v0]-15-[v1]-25-[v2]", views: titleLabel, subtitleLabel, mainStack)
            view.layoutIfNeeded()
            heightConstraint?.constant = 25 + 15 + 25 + 15 + 26 + titleLabel.frame.size.height + subtitleLabel.frame.size.height
        } else {
            containerView.addConstraintsWithFormat(format: "V:|-25-[v0]-25-[v1]-15-|", views: subtitleLabel, mainStack)
            view.layoutIfNeeded()
            heightConstraint?.constant = 25 + 25 + 15 + 26 + subtitleLabel.frame.size.height
        }
    }
    
    var heightConstraint : NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width : CGFloat = view.isSmallScreenSize == true ? 340 : 420
        self.preferredContentSize = CGSize(width: width, height: heightConstraint?.constant ?? 100)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


