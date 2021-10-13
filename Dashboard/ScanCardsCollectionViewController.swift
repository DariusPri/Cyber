//
//  ScanCardsCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 16/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol ScanCardsProtocol : AnyObject {
    func didSelected(at index : Int)
}

class ScanCardsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var scanDatas : [ScanData] = []
    weak var scanCardsDelegate : ScanCardsProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(EnabledScanCell.self, forCellWithReuseIdentifier: "EnabledScanCell")
        self.collectionView!.register(DisabledScanCell.self, forCellWithReuseIdentifier: "DisabledScanCell")
        self.collectionView?.backgroundColor = .clear
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.collectionView?.contentInset = .init(top: 0, left: 15, bottom: 10, right: 15)
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 20
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 20
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return scanDatas.count }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return view.isSmallScreenSize == true ? CGSize(width: 300, height: 120) : CGSize(width: ((view.bounds.size.width / 2) - self.collectionView!.contentInset.left - 10), height: view.getCorrectSize(160, 160, 190)) }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = scanDatas[indexPath.item]
        var cell : CardCollectionViewCell
        
        if data.scanStatus == .enabled {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnabledScanCell", for: indexPath) as! EnabledScanCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisabledScanCell", for: indexPath) as! DisabledScanCell
        }
        cell.data = data
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    var selectedIP : IndexPath?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let completelyVisible = collectionView.bounds.contains(cell!.frame)

        if completelyVisible == true {
            scanCardsDelegate?.didSelected(at: indexPath.item)
        } else {
            selectedIP = indexPath
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let ip = selectedIP else { return }
        scanCardsDelegate?.didSelected(at: ip.item)
        collectionView?.deselectItem(at: ip, animated: false)
        selectedIP = nil
    }

}



// MARK:- Base Cell

class CardCollectionViewCell: UICollectionViewCell {
    
    var data : ScanData? { didSet{ updateUI() }}
    func updateUI() {
        guard let d = data else { return }
        switch d.scanType {
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
    }
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        return label
    }()
    
    lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    let statusButton : ScanStatusButton = {
        let button = ScanStatusButton()
        button.setStatus(toEnabled: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layoutElements()
    }
    
    func layoutElements() {
        contentView.addSubview(containerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        containerView.layer.cornerRadius = getCorrectSize(5, 5, 8)
        
        iconImageView.widthAnchor.constraint(equalToConstant: getCorrectSize(50, 50, 58)).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(50, 50, 58)).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func dateString(from unixtimeInterval : Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixtimeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}


//MARK:- Enabled Scan Cell

class EnabledScanCell : CardCollectionViewCell {
    
    override func updateUI() {
        super.updateUI()
        guard let data = data else { return }
        titleLabel.text = data.scanType.localized()
        let count = data.taskCount == 0 ? "No" : "\(data.taskCount)"
        setSubtitleLabel(with: Localization.shared.dashboard_last_scan_+" \(CardCollectionViewCell.dateString(from: data.lastScan)) \n"+Localization.shared.dashboard_issues_count_found.doubleBracketReplace(with: "\(count)"))
        
    }
    
    override func layoutElements() {
        super.layoutElements()
        statusButton.setStatus(toEnabled: true)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusButton)
        containerView.addSubview(subtitleLabel)
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(17, 17, 22))
        statusButton.titleLabel?.font = statusButton.titleLabel?.font.withSize(getCorrectSize(10, 10, 13))
        statusButton.heightAnchor.constraint(equalToConstant: getCorrectSize(20, 20, 24)).isActive = true
        subtitleLabel.font = subtitleLabel.font.withSize(getCorrectSize(13, 13, 18))
        
        if isSmallScreenSize == true {
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-20-[v1]-10-|", views: iconImageView, titleLabel)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-20-[v1]-10-|", views: iconImageView, subtitleLabel)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-20-[v1]-(>=10)-|", views: iconImageView, statusButton)
            containerView.addConstraintsWithFormat(format: "V:|-15-[v0]", views: iconImageView)
            containerView.addConstraintsWithFormat(format: "V:|-15-[v0(21)]-2-[v1(>=32)]-2-[v2(20)]-19-|", views: titleLabel, subtitleLabel, statusButton)
        } else {
            containerView.addConstraintsWithFormat(format: "H:[v0]-\(getCorrectSize(10, 10, 14))-|", views: statusButton)
            containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(10, 10, 14))-[v0]", views: statusButton)
            containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 18))-[v0]", views: iconImageView)
            containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 18))-[v0]", views: titleLabel)
            containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 18))-[v0]", views: subtitleLabel)
            containerView.addConstraintsWithFormat(format: "V:|-20-[v0]-[v1]-[v2]-(>=10)-|", views: iconImageView, titleLabel, subtitleLabel)
        }
    }
    
    func setSubtitleLabel(with text : String) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = -10
        style.minimumLineHeight = 0
        attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        subtitleLabel.attributedText = attrString
    }
}


//MARK:- Disabled Scan Cell

class DisabledScanCell : CardCollectionViewCell {
    
    override func updateUI() {
        super.updateUI()
        titleLabel.text = data?.scanType.rawValue
    }
    
    let enableScanButton = SquareButton(title: Localization.shared.enable_scan.uppercased(), image: nil, backgroundColor: UIColor(named: "dashScanActionButtonColor")!, textColor: UIColor(named: "dashScanActionButtonTextColor")!)
    
    override func layoutElements() {
        super.layoutElements()
        statusButton.setStatus(toEnabled: false)
        enableScanButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 10)

        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusButton)
        containerView.addSubview(enableScanButton)
        
        if isSmallScreenSize == true {
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-20-[v1]-10-|", views: iconImageView, titleLabel)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-20-[v1]-(>=10)-|", views: iconImageView, statusButton)
            containerView.addConstraintsWithFormat(format: "V:|-15-[v0]", views: iconImageView)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: enableScanButton)
            containerView.addConstraintsWithFormat(format: "V:|-15-[v0(21)]-7-[v1]", views: titleLabel, statusButton)
            containerView.addConstraintsWithFormat(format: "V:[v0(26)]-15-|", views: enableScanButton)
        } else {
            containerView.addConstraintsWithFormat(format: "H:[v0]-10-|", views: statusButton)
            containerView.addConstraintsWithFormat(format: "V:|-10-[v0]", views: statusButton)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: enableScanButton)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: iconImageView)
            containerView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: titleLabel)
            containerView.addConstraintsWithFormat(format: "V:|-20-[v0]-[v1]-[v2(26)]-16-|", views: iconImageView, titleLabel, enableScanButton)
        }
    }
}


//MARK:- Scan Status Button

class ScanStatusButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 2
        titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 10)
    }
    
    func setStatus(toEnabled enabled : Bool) {
        if enabled == true {
            
            setTitle("  \(Localization.shared.enabled.uppercased())   ", for: .normal)
            setTitleColor(UIColor(red: 114/255, green: 204/255, blue: 87/255, alpha: 1), for: .normal)
            backgroundColor = UIColor(red: 234/255, green: 246/255, blue: 237/255, alpha: 1)
        } else {
            setTitle("  \(Localization.shared.disabled.uppercased())   ", for: .normal)
            setTitleColor(UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1), for: .normal)
            backgroundColor = UIColor(red: 247/255, green: 233/255, blue: 245/255, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
