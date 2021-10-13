//
//  LanguageSelectCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 2019-11-14.
//  Copyright © 2019. All rights reserved.
//

import UIKit


class LanguageSelectCollectionViewController: UICollectionViewController, ErrorPresenter {
    
    struct LanguageData {
        var languageCode : String
        var languageFilename : String
        var termsCode : String
    }
    
    var languageDatas : [(data: LanguageData, isSelected: Bool)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        setupNav()

        self.collectionView!.register(LanguageCell.self, forCellWithReuseIdentifier: "LanguageCell")
        self.collectionView!.contentInset = .init(top: 30, left: 0, bottom: 30, right: 0)

        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        getLanguages { (success, datas) in
            
            let currentLanguage = UserData.shared.localUserData.language ?? "EN"
            
            let datas : [(data: LanguageData, isSelected: Bool)] = datas.map({ (d) in
                return (data: d, isSelected: d.languageCode == currentLanguage)
            })
            
            self.languageDatas = datas
            self.collectionView.reloadData()
            
            if let index = datas.firstIndex(where: { data in data.isSelected == true }) {
                self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            
        }
    }
    
    func getLanguages(completion: @escaping (Bool, [LanguageData]) -> ()) {
        guard let url =  CyberExpertAPIEndpoint.localization_get_languages.url() else { completion(false, []); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, _, error) in
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                var data : [LanguageData] = []
                for (key, value) in json ?? [:] {
                    let langCode = key.split(separator: "_")[0].uppercased()
                    data.append(LanguageSelectCollectionViewController.LanguageData(languageCode: langCode, languageFilename: ((value as? [String : Any])?["default"] as? [String])?[0] ?? "", termsCode:key))
                }
                
                data.sort { (a, b) -> Bool in
                    a.languageCode < b.languageCode
                }
                
                completion(true, data)
                return 
            }
            completion(false, [])
        }
    }
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Localization.shared.settings_change_language
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        return titleLabel
    }()
    
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.shared.save.uppercased(), style: .plain, target: self, action: #selector(saveButtonAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .highlighted)
        
        self.navigationItem.titleView = headerLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonAction() {
        let currentLanguage = UserData.shared.localUserData.language ?? "EN"
        let data = languageDatas.first(where: { data in data.isSelected == true })?.data
        let newLanguage = data?.languageCode ?? "EN"
                
        if currentLanguage != newLanguage {
            UserData.shared.localUserData.language = newLanguage
            UserData.shared.localUserData.languageFile = data?.languageFilename ?? "en_GB.json"
            UserData.shared.localUserData.termsLanguageCode = data?.termsCode ?? "en_GB"
            NetworkClient.shared.currentLanguage = data?.termsCode ?? "en_GB"
            
            presentSimpleOKError(withTitle: Localization.shared.language_changed_header, andSubtitle: Localization.shared.language_changed_subheader) {
                let rootNav = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! XpertNavigationController
                rootNav.presentedViewController?.dismiss(animated: true, completion: {
                    Localization.shared.getCurrentLanguage { (success) in
                        DispatchQueue.main.async {
                            let mainViewController = XpertNavigationController(rootViewController: LoginViewController())
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = mainViewController
                        }
                    }
                })
            }
        } else {
            closeViewController()
        }
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let data = languageDatas[indexPath.item]
        cell.widthConstraint?.constant = collectionView.bounds.size.width - 30
        cell.titleLabel.text = data.data.languageCode
        cell.iconEmojiLabel.text = flag(country: data.data.languageCode == "EN" ? "GB" : data.data.languageCode)
        cell.cellIs(selected: data.isSelected)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        languageDatas[indexPath.item].isSelected = true
        selectOrDecelectCell(at: indexPath, bool: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        languageDatas[indexPath.item].isSelected = false
        selectOrDecelectCell(at: indexPath, bool: false)
    }
    
    func selectOrDecelectCell(at indexPath: IndexPath, bool : Bool) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LanguageCell {
            cell.cellIs(selected: bool)
        }
    }
}


class LanguageCell: UICollectionViewCell {
    
    func cellIs(selected : Bool) {
        if selected == true {
            containerView.layer.borderColor = UIColor.mainBlue.cgColor
        } else {
            containerView.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var iconEmojiLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(40)
        return label
    }()
    
    var widthConstraint : NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(15, 15, 21))
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconEmojiLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0(\(getCorrectSize(45, 45, 64)))]-41@777-[v1]-\(getCorrectSize(17, 17, 22))-|", views: iconEmojiLabel, titleLabel)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(25, 25, 32))-[v0(\(getCorrectSize(45, 45, 64)))]-\(getCorrectSize(25, 25, 32))-|", views: iconEmojiLabel)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(25, 25, 32))-[v0]-(\(getCorrectSize(25, 25, 32))@777)-|", views: titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
