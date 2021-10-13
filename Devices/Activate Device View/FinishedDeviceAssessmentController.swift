//
//  FinishedDeviceAssessmentController.swift
//  Xpert
//
//  Created by Darius on 28/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol DeviceActivationProtocol : AnyObject {
    func activateDeviceAndAddAnotherDevice()
    func activateDeviceAndGoToDoList()
    func activateDevice()
}

class FinishedDeviceAssessmentController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    weak var deviceActivationDelegate : DeviceActivationProtocol?

    var addDeviceButton : DeviceAssessmentCompletionButton?
    var showToDoListButton : DeviceAssessmentCompletionButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg")) 
        
        let detailedView = DetailedView(image: #imageLiteral(resourceName: "donecheck_ill_dark"), header: Localization.shared.assessment_all_done+"!", subheader: Localization.shared.assessment_your_assessment_is_now_complete_we_will_generate_a)
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
        
        detailedView.mainStack.setCustomSpacing(view.getCorrectSize(58, 58, 78), after: detailedView.mainImageView)
        detailedView.mainStack.setCustomSpacing(view.getCorrectSize(25, 25, 34), after: detailedView.headerLabel)
        detailedView.mainImageViewWidthContraint.constant = view.getCorrectSize(126, 126, 160)
        detailedView.mainImageViewHeightConstraint.constant = view.getCorrectSize(126, 126, 160)
        
        addDeviceButton = DeviceAssessmentCompletionButton(title: Localization.shared.device_add_another_device, subtitle: nil, image: view.isHugeScreenSize == true ? #imageLiteral(resourceName: "add btn huge") : #imageLiteral(resourceName: "add btn"))
        addDeviceButton?.heightAnchor.constraint(equalToConstant: view.getCorrectSize(60, 60, 80)).isActive = true
        addDeviceButton?.translatesAutoresizingMaskIntoConstraints = false
        showToDoListButton = DeviceAssessmentCompletionButton(title: Localization.shared.device_go_to_do_list, subtitle: nil, image: view.isHugeScreenSize == true ? #imageLiteral(resourceName: "check_endactivate_ic_huge") : #imageLiteral(resourceName: "check_endactivate_ic"))
        showToDoListButton?.heightAnchor.constraint(equalToConstant: view.getCorrectSize(60, 60, 80)).isActive = true
        showToDoListButton?.translatesAutoresizingMaskIntoConstraints = false
        
        addDeviceButton?.addTarget(self, action: #selector(addAnotherDevice), for: .touchUpInside)
        showToDoListButton?.addTarget(self, action: #selector(goToDoList), for: .touchUpInside)
        
        let mainStack = UIStackView(arrangedSubviews: [detailedView, addDeviceButton!, showToDoListButton!])
        mainStack.spacing = view.getCorrectSize(25, 25, 32)
        mainStack.alignment = .center
        mainStack.axis = .vertical
        
        NSLayoutConstraint(item: detailedView, attribute: .width, relatedBy: .equal, toItem: mainStack, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: addDeviceButton!, attribute: .width, relatedBy: .equal, toItem: mainStack, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: showToDoListButton!, attribute: .width, relatedBy: .equal, toItem: mainStack, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth * 0.9))]", views: mainStack)
            detailedView.subheaderLabel.preferredMaxLayoutWidth = view.calculatedNewScreenWidth * 0.6
        }
        
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: view.getCorrectSize(-49, -49, -300)).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func addAnotherDevice() {
        self.navigationController?.dismiss(animated: true, completion: { self.deviceActivationDelegate?.activateDeviceAndAddAnotherDevice() })
    }
    
    @objc func goToDoList() {
        self.navigationController?.dismiss(animated: true, completion: { self.deviceActivationDelegate?.activateDeviceAndGoToDoList() })
    }
}


class DeviceAssessmentCompletionButton: UIButton {
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "deviceAssessmentFinishedViewButtonTitleColor")
        label.font = UIFont(name: "Muli-Regular", size: 15)
        return label
    }()
    
    lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "deviceAssessmentFinishedViewButtonSubtitleColor")
        label.font = UIFont(name: "Muli-Italic", size: 13)
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    init(title : String, subtitle : String?, image : UIImage) {
        super.init(frame: .zero)
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(15, 15, 18))
        subtitleLabel.font = subtitleLabel.font.withSize(getCorrectSize(13, 13, 15))
        
        iconImageView.image = image
        backgroundColor = UIColor(named: "deviceAssessmentFinishedViewButtonBgColor")
        layer.cornerRadius = 5
        
        headerLabel.text = title
        if let sub = subtitle { subtitleLabel.text = sub }
        let mainStack = UIStackView(arrangedSubviews: subtitle == nil ? [headerLabel] : [headerLabel, subtitleLabel])
        mainStack.axis = .vertical
        mainStack.isUserInteractionEnabled = false
        
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 44))-[v0]-(>=80)-|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addSubview(iconImageView)
        addConstraintsWithFormat(format: "H:[v0(\(getCorrectSize(30, 30, 38)))]-15-|", views: iconImageView)
        iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(30, 30, 38)).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
