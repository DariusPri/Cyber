//
//  FinishedAssessmentViewController.swift
//  Xpert
//
//  Created by Darius on 14/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class FinishedAssessmentViewController: UIViewController {
    
    let detailedView = DetailedView(image: #imageLiteral(resourceName: "donecheck_ill_dark"), header: Localization.shared.assessment_all_done+"!", subheader: Localization.shared.assessment_your_assessment_is_now_complete_we_will_generate_a)

    let bottomInfoButton = TextButton(title: Localization.shared.assessment_redirecting_to+" "+Localization.shared.dashboard)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        detailedView.headerLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        detailedView.headerLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(26, 26, 34))
        detailedView.subheaderLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(17, 17, 22))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = detailedView.subheaderLabel.textAlignment
        
        let attrString = NSMutableAttributedString(string: detailedView.subheaderLabel.text!)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: detailedView.subheaderLabel.text!.count))
        detailedView.subheaderLabel.attributedText = attrString
        
        detailedView.mainStack.setCustomSpacing(58, after: detailedView.mainImageView)
        detailedView.mainStack.setCustomSpacing(25, after: detailedView.headerLabel)
        detailedView.mainImageViewWidthContraint.constant = view.getCorrectSize(126, 126, 160)
        detailedView.mainImageViewHeightConstraint.constant = view.getCorrectSize(126, 126, 160)
        
        bottomInfoButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        bottomInfoButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(17, 17, 22))
        bottomInfoButton.setTitleColor(UIColor(named: "finishedAssessmentVCBottomButtonTextColor"), for: .normal)

        let mainStack = UIStackView(arrangedSubviews: [detailedView, bottomInfoButton])
        mainStack.spacing = view.getCorrectSize(15, 15, 25)
        mainStack.alignment = .center
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(min(view.calculatedNewScreenWidth, 520)))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: view.getCorrectSize(-18, -68, -140)).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.showDashboardAction()
        }
    }
    
    var nextViewController : UIViewController?
    
    func showDashboardAction() {
        let daashboardVC = nextViewController ?? DashboardTabBarController()
        self.navigationController?.setViewControllers([daashboardVC], animated: true)
    }

}
