//
//  ScanWidePopupViewController.swift
//  Xpert
//
//  Created by Darius on 08/10/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ScanWidePopupViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var scanCardViewController : ScanCardViewController?
    var scanData : ScanData
    let sourceView : UIView
    
    init(scanData : ScanData, sourceRect : CGRect) {
        self.sourceView = UIView(frame: sourceRect)
        self.scanData = scanData
        super.init(nibName: nil, bundle: nil)
    }
    
    var overlayView : UIView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if scanCardViewController == nil { animateAndSetup() }
    }
    
    func animateAndSetup() {
        scanCardViewController = ScanCardViewController(scanData: scanData)
        scanCardViewController!.modalPresentationStyle = UIModalPresentationStyle.popover
        scanCardViewController?.preferredContentSize = CGSize(width: 320, height: 600)
        scanCardViewController!.popoverPresentationController?.permittedArrowDirections = [.left, .right, .up, .down]
        scanCardViewController!.popoverPresentationController?.delegate = self
        scanCardViewController!.popoverPresentationController?.sourceView = sourceView
        scanCardViewController!.popoverPresentationController?.sourceRect = sourceView.bounds
        scanCardViewController!.popoverPresentationController?.backgroundColor = .white
        scanCardViewController!.popoverPresentationController?.passthroughViews = nil
        scanCardViewController?.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView!.alpha = 1
        }) { (_) in
            self.present(self.scanCardViewController!, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.overlayView = createOverlay(frame: view.frame, cutOutFrame: sourceView.frame, radius: 10)
        view.addSubview(overlayView!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: overlayView!)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: overlayView!)
        view.addSubview(sourceView)
    }
    
    func createOverlay(frame: CGRect,
                       cutOutFrame: CGRect,
                       radius: CGFloat) -> UIView {
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let path = CGMutablePath()
        path.addRoundedRect(in: cutOutFrame, cornerWidth: radius, cornerHeight: radius)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        overlayView.alpha = 0
        
        return overlayView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        dismissPopup()
    }
    
    func dismissPopup() {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            self.overlayView!.alpha = 0
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

class ScanCardViewController : UIViewController {
    
    let scanView : ScanView
    
    init(scanData : ScanData) {
        scanView = ScanView(scanData: scanData)
        super.init(nibName: nil, bundle: nil)
    }

    var topConstraint : NSLayoutConstraint?
    var bottomConstraint : NSLayoutConstraint?
    var leftConstraint : NSLayoutConstraint?
    var rightConstaint : NSLayoutConstraint?
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScanView()
    }
    
    func setupScanView() {
        view.addSubview(scanView)
        leftConstraint =  scanView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0)
        rightConstaint = scanView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0)
        topConstraint = scanView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        bottomConstraint = scanView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        [leftConstraint, rightConstaint, topConstraint, bottomConstraint].forEach{ $0?.isActive = true }
        scanView.translatesAutoresizingMaskIntoConstraints = false
        scanView.premiumButton?.addTarget(self, action: #selector(upgradeToPremiumAction), for: .touchUpInside)
        
        scanView.premiumButton?.isEnabled = ifScanAvailable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ifScanAvailable() -> Bool {
        
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        
        switch scanView.scanData.scanType {
        case .vulnerability:
            let dueTimestamp = UserData.shared.localUserData.lastScannedVulnerability
            return dueTimestamp ?? 0 < currentTimeStamp
        case .router:
            let dueTimestamp = UserData.shared.localUserData.lastScannedRouter
            return dueTimestamp ?? 0 < currentTimeStamp
        case .scamEmails:
            let dueTimestamp = UserData.shared.localUserData.lastScannedEmails
            return dueTimestamp ?? 0 < currentTimeStamp
        default:
            return true
        }
    }
    
    func setSaveScanTime() {
        
        let currentTimeStamp = Int(Date().timeIntervalSince1970) + (60 * 60 * 5)
        
        switch scanView.scanData.scanType {
        case .vulnerability:
            UserData.shared.localUserData.lastScannedVulnerability = currentTimeStamp
        case .router:
            UserData.shared.localUserData.lastScannedRouter = currentTimeStamp
        case .scamEmails:
            UserData.shared.localUserData.lastScannedEmails = currentTimeStamp
        default:
            break
        }
        
    }

    @objc func upgradeToPremiumAction() {
        
        setSaveScanTime()
        
        if scanView.scanData.scanStatus == .enabled {
            let loadingView = DimmedLoadingView()
            scanView.addSubview(loadingView)
            scanView.addConstraintsWithFormat(format: "H:|[v0]|", views: loadingView)
            scanView.addConstraintsWithFormat(format: "V:|[v0]|", views: loadingView)
            scanView.didMoveToSuperview()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                loadingView.dismissAnimationView {
                    loadingView.removeFromSuperview()
                    loadingView.didMoveToSuperview()
                    self.dismiss(animated: true) {}
                    (self.presentingViewController as? ScanWidePopupViewController)?.dismissPopup()
                }
            }
            
            
        }
    }
    
}



class ScanView: UIView {
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 26)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        return label
    }()
    
    lazy var lastScanLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        return label
    }()
    
    let statusButton = StatusButton()
    
    let detailedLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let scanData : ScanData
    
    var premiumButton : SquareButton?
    
    init(scanData : ScanData) {
        self.scanData = scanData
        super.init(frame: .zero)
        statusButton.setupButton(for: scanData.scanStatus)
        titleLabel.text = scanData.scanType.rawValue
        if scanData.scanStatus == .enabled {
            lastScanLabel.text = Localization.shared.dashboard_last_scan_+" "+CardCollectionViewCell.dateString(from: scanData.lastScan)
        }
        
        detailedLabel.text = scanData.scanType.getDescription()
        
        switch scanData.scanType {
        case .vulnerability:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "vulnerabilityscan_ill_light") : #imageLiteral(resourceName: "vulnerabilityscan_ill_light")
        case .dataBreach:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "breachscan_ill_light") : #imageLiteral(resourceName: "breachscan_ill_light")
        case .security:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "secscan_ill_light") : #imageLiteral(resourceName: "secscan_ill_light")
        case .router:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "routerscan_ill_light") : #imageLiteral(resourceName: "routerscan_ill_light")
        default:
            iconImageView.image = nil
        }
        
        let mainStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        mainStack.alignment = .center
        mainStack.axis = .vertical
        
        if scanData.scanStatus == .enabled {
            mainStack.addArrangedSubview(lastScanLabel)
            mainStack.setCustomSpacing(10, after: lastScanLabel)
            mainStack.setCustomSpacing(6, after: titleLabel)
        } else {
            mainStack.setCustomSpacing(10, after: titleLabel)
        }
        mainStack.addArrangedSubview(statusButton)
        mainStack.addArrangedSubview(detailedLabel)
        
        mainStack.setCustomSpacing(19, after: iconImageView)
        mainStack.setCustomSpacing(25, after: statusButton)
        
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(mainStack)
        containerView.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: mainStack)
        
        premiumButton = SquareButton(title:  scanData.scanStatus == .enabled ? Localization.shared.start_scan.uppercased() : Localization.shared.upgrade_plan.uppercased(), image: nil, backgroundColor: UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1), textColor: .white)
        containerView.addSubview(premiumButton!)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(55)]", views: premiumButton!)
        containerView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: premiumButton!)
        
        containerView.addConstraintsWithFormat(format: "V:|-30-[v0]-(>=60)-[v1]-10-|", views: mainStack, premiumButton!)
        
        containerView.bringSubviewToFront(premiumButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
