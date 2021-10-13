//
//  BeginAssessmentViewController.swift
//  Xpert
//
//  Created by Darius on 03/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


enum AssessmentType {
    case singleSelect
    case multipleSelect
    
    init(text : String) {
        if text.lowercased() == "radio" { self = .singleSelect }
        else if text.lowercased() == "checkbox" { self = .multipleSelect }
        else { self = .singleSelect }
    }
}

struct AssessmentAnswer {
    var text : String
    var isSelected : Bool
    var rightImage : UIImage?
    var answerUuid : String
    var cancelsOutOtherAnswers : Bool
}

struct AssessmentQuestionData {
    var type : AssessmentType
    var questionText : String
    var answers : [AssessmentAnswer]
    var explainers : [(word : String, explanation : String)]
    var questionUuid : String
}

struct AssessmentData {
    var questionIndex : Int
    var sessionUuid : String
    var questionDatas : [AssessmentQuestionData]
}


final class BeginAssessmentViewController: ScanSlideViewController {

    let beginAssessmentButton = SquareButton(title: Localization.shared.assessment_start.uppercased(), image: nil, backgroundColor: UIColor(named: "BeginAssessmentStartButtonBgColor")!, textColor: .white)

    init() {
        super.init(image: #imageLiteral(resourceName: "phone_activate_ill"), header: Localization.shared.assessment_almost_done, subheader: Localization.shared.general_assessment_subheader, animationName: nil, explainerText: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNextButton()
        verticalCenterLayout!.constant = view.getCorrectSize(-50, -108, -165)
        detailedView.mainImageView.contentMode = .scaleAspectFit
        detailedView.mainImageViewHeightConstraint.constant = 160 * view.getCorrectSize(1, 1, 1.6)
        detailedView.mainImageViewWidthContraint.constant = 149 * view.getCorrectSize(1, 1, 1.6)
    }

    func addNextButton() {
        beginAssessmentButton.addTarget(self, action: #selector(beginAssessmentButtonAction), for: .touchUpInside)
        view.addSubview(beginAssessmentButton)
        let guide = self.view.safeAreaLayoutGuide
        beginAssessmentButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : -12).isActive = true
        beginAssessmentButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        beginAssessmentButton.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 15)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: beginAssessmentButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: beginAssessmentButton)
        }
        NSLayoutConstraint(item: beginAssessmentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func beginAssessmentButtonAction() {
        self.navigationController?.pushViewController(AssessmentBaseViewController(), animated: true)

    }

}
