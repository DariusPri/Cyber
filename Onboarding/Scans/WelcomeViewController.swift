//
//  WelcomeViewController.swift
//  Xpert
//
//  Created by Darius on 31/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    let startScanButton = SquareButton(title: "START SCAN", image: nil, backgroundColor: UIColor.primaryButtonColor, textColor: .white)
    
    let headerTitle : String
    
    init(isTrial : Bool) {
        if isTrial == true {
            headerTitle = Localization.shared.welcome_to_dynarisk
        } else {
            headerTitle = "Your trial has Started!"
        }
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        let header = HeaderLabel(text: headerTitle, edgeInsets : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), lineSpacing: 1.1, textSize: view.getCorrectSize(26, 26, 34))
        let headerDetail = HeaderDetailLabel(text: "We'll now run a vulnerability scan on your device and check whether your personal information has been stolen and shared on the Dark Web.", edgeInsets: .zero, lineSpacing: 1.1, textSize: view.getCorrectSize(17, 17, 23))
        let dottedLineView = DottedLineView(size: CGSize(width: view.getCorrectSize(12, 12, 18), height: view.getCorrectSize(12, 12, 18)))
        
        let containerView = UIView()
        containerView.addSubview(header)
        containerView.addSubview(headerDetail)
        containerView.addSubview(dottedLineView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0(10)]-(\(view.getCorrectSize(28, 69, 69)))-[v1]-40-|", views: dottedLineView, header)
        containerView.addConstraintsWithFormat(format: "H:|[v0(10)]-(\(view.getCorrectSize(28, 69, 69)))-[v1]|", views: dottedLineView, headerDetail)
        containerView.addConstraintsWithFormat(format: "V:|-10-[v0]|", views: dottedLineView)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-25-[v1]", views: header, headerDetail)

        view.addSubview(containerView)
        addNextButton()

        view.addConstraintsWithFormat(format: "V:|-\(view.getCorrectSize(140, 140, 180))-[v0]", views: containerView)
        
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=460)]-(>=15,==15@900)-|", views: containerView)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.getCorrectSize(view.calculatedNewScreenWidth, view.calculatedNewScreenWidth, 612)))]", views: containerView)
        }
        
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: startScanButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
    }
    
    private func addNextButton() {
        view.addSubview(startScanButton)
        startScanButton.titleLabel?.font = startScanButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 21))

        let guide = self.view.safeAreaLayoutGuide
        startScanButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(\(view.getCorrectSize(50, 50, 80)))]", views: startScanButton)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=512)]-(>=15,==15@900)-|", views: startScanButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.getCorrectSize(view.calculatedNewScreenWidth, view.calculatedNewScreenWidth, 680)))]", views: startScanButton)
        }
        NSLayoutConstraint(item: startScanButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }


}


class DottedLineView: UIView {
    
    let path = UIBezierPath()
    
    let circleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 74/255, green: 160/255, blue: 211/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor(red: 74/255, green: 160/255, blue: 211/255, alpha: 1).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        return view
    }()
    
    init(size: CGSize = CGSize(width: 12, height: 12)) {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(circleView)
        circleView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        circleView.layer.cornerRadius = size.width/2
        addConstraintsWithFormat(format: "V:|[v0]", views: circleView)
        NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: ((rect.size.width / 2)), y: 0))
        path.addLine(to: CGPoint(x: ((rect.size.width / 2)), y: rect.size.height))
        UIColor(red: 74/255, green: 160/255, blue: 211/255, alpha: 1).setStroke()
        path.lineWidth = 1
        let dashPattern : [CGFloat] = [1, 10]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.lineCapStyle = CGLineCap.round
        path.stroke()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
