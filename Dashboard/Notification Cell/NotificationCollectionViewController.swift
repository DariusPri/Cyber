//
//  NotificationCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NotificationInnerCell"

class NotificationCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .clear
        self.collectionView!.register(NotificationInnerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    var deviceDatas : [DeviceData] = []
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NotificationInnerCell
        cell.backgrountTintView.alpha = (CGFloat(indexPath.item) * 0.05)
        cell.updateUI(with: deviceDatas[indexPath.item])
        cell.layer.zPosition = CGFloat(deviceDatas.count) - CGFloat(indexPath.item)
        cell.actionButton.tag = indexPath.item
        cell.actionButton.isUserInteractionEnabled = false
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if let tabBarVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UINavigationController)?.viewControllers.first as? DashboardTabBarController, let data = deviceDatas.first {
            tabBarVC.selectedIndex = 0
            tabBarVC.devicesVC.selectDevice(with: data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: view.getCorrectSize(116, 116, 154))
    }

}



class NotificationInnerCell: SettingsCell {
    
    func updateUI(with deviceData : DeviceData) {
        mainLabel.text = Localization.shared.dashboard_device_not_active.doubleBracketReplace(with: deviceData.type)
                
        if deviceData.os == .ios {
            if deviceData.type == "phone" {
                iconImageView.image = #imageLiteral(resourceName: "phone_apple_ic")
            } else {
                iconImageView.image = #imageLiteral(resourceName: "tablet_apple_ic")
            }
        } else if deviceData.os == .android {
            if deviceData.type == "phone" {
                iconImageView.image = #imageLiteral(resourceName: "phone_android_ic")
            } else {
                iconImageView.image = #imageLiteral(resourceName: "laptop_android_ic")
            }
        } else if deviceData.os == .mac {
            iconImageView.image = #imageLiteral(resourceName: "pc_apple_ic")
        } else if deviceData.os == .windows {
            iconImageView.image =  #imageLiteral(resourceName: "pc_windows_ic")
        }
    }
    
    let backgrountTintView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 98/255, green: 106/255, blue: 113/255, alpha: 1)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.textInputBorderColor.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "laptop_apple_ic")
        return imageView
    }()
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "The laptop you added is not active yet"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "dashNotifActionButtonColor")
        button.imageView?.tintColor = UIColor(named: "dashNotifActionButtonTintColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrow_right_blue"), for: .normal)
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        return button
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        mainLabel.font = mainLabel.font.withSize(getCorrectSize(15, 15, 19))
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(mainLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(iconImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(10, 10, 18))-[v0(\(getCorrectSize(100, 100, 120)))]-\(getCorrectSize(10, 10, 18))-[v1]-40-|", views: iconImageView, mainLabel)
        containerView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: mainLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(30, 30, 40)))]-\(getCorrectSize(10, 10, 18))-|", views: actionButton)
        containerView.addConstraintsWithFormat(format: "H:[v0(\(getCorrectSize(30, 30, 40)))]-\(getCorrectSize(10, 10, 18))-|", views: actionButton)
        
        containerView.addSubview(backgrountTintView)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: backgrountTintView)
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: backgrountTintView)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        UIView.animate(withDuration: 0.6) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



