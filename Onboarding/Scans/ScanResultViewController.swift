//
//  ScanResultViewController.swift
//  Xpert
//
//  Created by Darius on 01/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

enum ScanType : String {
    case vulnerability = "Vulnerability Scan"
    case dataBreach = "Dark Web Scan"
    case security = "Security Scans"
    case router = "Router Scans"
    case scamEmails = "Scam Emails"
    
    func localized() -> String {
                
        switch self {
        case .vulnerability:
            return Localization.shared.vulnerability_scan
        case .dataBreach:
            return Localization.shared.data_breach_scanner
        case .security:
            return Localization.shared.dashboard_security_scans
        case .router:
            return Localization.shared.router_scan
        case .scamEmails:
            return Localization.shared.dashboard_scam_emails
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .vulnerability:
            return Localization.shared.dashboard_vulnerability_scans_popup_desc_missing
        case .dataBreach:
            return Localization.shared.dashboard_data_breach_popup_description_text_missing
        case .security:
            return Localization.shared.dashboard_security_popup_description_text_missing
        case .router:
            return Localization.shared.dashboard_router_popup_description_text_missing
        case .scamEmails:
            return Localization.shared.dashboard_scam_emails_desc_text_missing
        }
    }
    
    init?(name: String) {
        switch name {
        case "vulnerability_scan":
            self = .vulnerability
        case "data_breach_scanner":
            self = .dataBreach
        case "security_scan":
            self = .security
        case "router_scan":
            self = .router
        case "scan_emails":
            self = .scamEmails
        default:
            self = .vulnerability
        }
        
    }
}

class ScanResultViewController: UIViewController {
    
    struct ScanData {
        var scanType : ScanType
        var problemCount : Int
        var image : UIImage
        func fullProblemString() -> String {
            if scanType == .router { return "Router security scan scheduled" }
            if scanType == .scamEmails { return "Scam emails scheduled for sending" }
            return problemCount > 0 ? "\(problemCount) problems" : "No Problems found" }
        func hasProblems() -> Bool { return problemCount > 0 }
    }

    let dashboardButton = SquareButton(title: Localization.shared.continue_to_dashboard.uppercased(), image: nil, backgroundColor: UIColor.primaryButtonColor, textColor: .white)
    let scoreLabel : DefaultLabel
    let scanDetailsView : ScanDetailsView
    
    init(score : Int, scanDataArray : [ScanData]) {
        scoreLabel = DefaultLabel(text: String(score))
        scanDetailsView = ScanDetailsView(scanDataArray: scanDataArray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bgColor
        addNextButton()
        setupElements()
    }
    
    func setupElements() {
        scoreLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(62, 62, 86))
        
        let header = DefaultLabel(text: "Security Issues Found")
        header.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(17, 17, 24))
        let subHeader = IndicatorLabel(text: "Sign up and continue to your dashboard to get your Cyber Security Score and tailored improvement plan", attatchmentImage: #imageLiteral(resourceName: "indicator_red"), attachmentSpacing : 0)
        subHeader.font = subHeader.font.withSize(view.getCorrectSize(12.2, 13, 15))
        
        let infoStack = UIStackView(arrangedSubviews: [scoreLabel, header, subHeader])
        infoStack.axis = .vertical
        infoStack.spacing = view.getCorrectSize(0, 0, 10)
        infoStack.setCustomSpacing(view.getCorrectSize(10, 10, 16), after: header)
        
        view.addSubview(infoStack)
        view.addSubview(scanDetailsView)
        view.addConstraintsWithFormat(format: "V:|-\(view.getCorrectSize(80, 136, 160))-[v0]-\(view.getCorrectSize(50, 50, 84))-[v1]", views: infoStack, scanDetailsView)
        view.addConstraintsWithFormat(format: "H:|-(>=74,==74@900)-[v0(<=500)]-(>=74,==74@900)-|", views: infoStack)
        view.addConstraintsWithFormat(format: "H:|-(>=30,==30@900)-[v0(<=500)]-(>=30,==30@900)-|", views: scanDetailsView)
        NSLayoutConstraint(item: infoStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: view.getCorrectSize(0, 0, -80)).isActive = true
        NSLayoutConstraint(item: scanDetailsView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: view.getCorrectSize(0, 0, -80)).isActive = true

    }
    
    func addNextButton() {
        dashboardButton.addTarget(self, action: #selector(dashboardButtonAction), for: .touchUpInside)
        view.addSubview(dashboardButton)
        let guide = self.view.safeAreaLayoutGuide
        dashboardButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        dashboardButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(55, 55, 80)).isActive = true
        dashboardButton.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: view.getCorrectSize(15, 15, 21))
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: dashboardButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: dashboardButton)
        }
        NSLayoutConstraint(item: dashboardButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func dashboardButtonAction() {
        self.navigationController?.pushViewController(BeginAssessmentViewController(), animated: true)
    }

}



class ScanDetailsView : UIView {
    
    init(scanDataArray : [ScanResultViewController.ScanData]) {
        super.init(frame: .zero)
        var views : [SingleScanDetailView] = []
        for (index, scanData) in scanDataArray.enumerated() { views.append(SingleScanDetailView(scanData: scanData, isDotted: scanDataArray.count != index + 1)) }
        let mainStack = UIStackView(arrangedSubviews: views)
        mainStack.spacing = 10
        mainStack.axis = .vertical
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainStack)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class SingleScanDetailView: UIView {
    
    let path = UIBezierPath()

    let detailLabel : DefaultLabel
    let problemLabel : IndicatorLabel
    let dotted : Bool
    
    let iconImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(scanData : ScanResultViewController.ScanData, isDotted : Bool = true) {
        detailLabel = DefaultLabel(text: scanData.scanType.rawValue)
        detailLabel.font = UIFont(name: "Muli-Regular", size: 15)
        detailLabel.sizeToFit()
        problemLabel = IndicatorLabel(text: scanData.fullProblemString(), attatchmentImage: scanData.hasProblems() == true ? #imageLiteral(resourceName: "indicator_red") : #imageLiteral(resourceName: "indicator_green"), attachmentSpacing : 0)
        problemLabel.sizeToFit()
        detailLabel.sizeToFit()
        
        iconImageView.image = scanData.image
        dotted = isDotted
        super.init(frame: .zero)
        
        iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(26, 26, 32)).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: getCorrectSize(26, 26, 32)).isActive = true
        
        detailLabel.font = detailLabel.font.withSize(getCorrectSize(15, 15, 19))
        problemLabel.font = problemLabel.font.withSize(getCorrectSize(13, 13, 16))
        
        addSubview(iconImageView)
        addSubview(detailLabel)
        addSubview(problemLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: getCorrectSize(80, 80, 120)).isActive = true
        
        addConstraintsWithFormat(format: "H:|[v0]", views: iconImageView)
        addConstraintsWithFormat(format: "H:[v0]-\(getCorrectSize(24, 24, 34))-[v1]-10-|", views: iconImageView, detailLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: iconImageView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-8-[v1]-(>=\(getCorrectSize(10, 10, 50)))-|", views: detailLabel, problemLabel)
        NSLayoutConstraint(item: problemLabel, attribute: .left, relatedBy: .equal, toItem: detailLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        if dotted == false { return }
        path.move(to: CGPoint(x: 13, y: 36))
        path.addLine(to: CGPoint(x: 13, y: rect.size.height))
        UIColor(red: 110/255, green: 125/255, blue: 135/255, alpha: 1).setStroke()
        path.lineWidth = 1
        let dashPattern : [CGFloat] = [1, 4]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.lineCapStyle = CGLineCap.round
        path.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



