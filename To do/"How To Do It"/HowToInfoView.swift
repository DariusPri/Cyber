//
//  HowToInfoView.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PriorityImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 5).isActive = true
        heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func setupWith(priority : TaskPriority) {
        switch priority {
        case .low:
            image = #imageLiteral(resourceName: "grey_ic.png")
        case .medium:
            image = #imageLiteral(resourceName: "yellow_ic.png")
        case .high:
            image = #imageLiteral(resourceName: "indicator_red.png")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HowToInfoView: UIView {
    
    var data : TaskData? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let data = data else { return }
        titleLabel.sizeToFit()
        subtitleLabel.text = data.status.rawValue
        checkBoxButton.isSelected = data.status == .completed
        subtitleLabel.textColor = UIColor.lightGray
        
        checkBoxButton.isEnabled = true
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_ic"), for: .selected)
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_unchecked_ic_huge") : #imageLiteral(resourceName: "check_todo_unchecked_ic"), for: .normal)
        
        if data.status == .completed {
            checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_ic"), for: .normal)
            checkBoxButton.isEnabled = false
            let attrString = NSAttributedString(string: data.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attrString
            subtitleLabel.textColor = UIColor(red: 114/255, green: 204/255, blue: 90/255, alpha: 1)
        } else {
            if data.status == .overdue {
                subtitleLabel.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
            } else if data.status == .postponed {
                checkBoxButton.isEnabled = false
            }
            titleLabel.attributedText = nil
            titleLabel.text = data.name
        }
        
        switch data.device.type {
        case .personal:
            deviceImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_choice_ic_huge") : #imageLiteral(resourceName: "personalsec_choice_ic")
        case .desktop:
            deviceImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "pc_choice_ic_huge") : #imageLiteral(resourceName: "pc_choice_ic")
        case .laptop:
            deviceImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "laptop_choice_ic_huge") : #imageLiteral(resourceName: "laptop_choice_ic")
        case .phone:
            deviceImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "phone_choice_ic_huge") : #imageLiteral(resourceName: "phone_choice_ic")
        default :
            break
        }
        
        priorityImageView.setupWith(priority: data.priority)
    }
    
    let containerView = UIView()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    let checkBoxButton : UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var deviceImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    let priorityImageView = PriorityImageView(frame: .zero)
    
    let topBorderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 225/255, green: 231/255, blue: 236/255, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_ic"), for: .selected)
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_unchecked_ic_huge") : #imageLiteral(resourceName: "check_todo_unchecked_ic"), for: .normal)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(15, 15, 18))
        subtitleLabel.font = subtitleLabel.font.withSize(getCorrectSize(13, 13, 16))
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0(>=60)]", views: containerView)
        let bottomHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: bottomHeight == 0 ? -10 : 0).isActive = true
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(checkBoxButton)
        containerView.addSubview(deviceImageView)
        containerView.addSubview(topBorderView)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0(\(getCorrectSize(24, 24, 30)))]-20-[v1]-10-[v2(\(getCorrectSize(24, 24, 18)))]-\(getCorrectSize(21, 21, 30))-|", views: checkBoxButton, titleLabel, deviceImageView)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0(\(getCorrectSize(24, 24, 30)))]-20-[v1]-10-[v2(\(getCorrectSize(24, 24, 18)))]-\(getCorrectSize(21, 21, 30))-|", views: checkBoxButton, subtitleLabel, deviceImageView)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(14, 14, 19))-[v0(24)]", views: checkBoxButton)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(15, 15, 20))-[v0]-\(getCorrectSize(5, 5, 8))-[v1]-\(getCorrectSize(15, 15, 20))-|", views: titleLabel, subtitleLabel)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(15, 15, 20))-[v0(\(getCorrectSize(24, 24, 18)))]", views: deviceImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(1)]", views: topBorderView)
        
        addSubview(priorityImageView)
        addConstraintsWithFormat(format: "H:[v0]-10-|", views: priorityImageView)
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: priorityImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

