//
//  SettingsCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct PlanData {
    var uuid : String
    var name : String
    var slug : String
    var type : String
    var status : Bool
    var endDate : Int?
}

class SettingsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ErrorPresenter {
    
    enum SettingsCellType : String {
        case personalInfo = "Personal Information"
        case changePass = "Change Password"
        case paymentHistory = "Payment History"
        case dataBreach = "Data Breach Reports"
        case vulnerability = "Vulnerability Alerts"
        case securityNews = "Security News"
        case specialOffers = "Special offers"
        case changePlan = "Change Membership Plan"
        case deleteAcc = "Delete account"
        case logOut = "Log Out"
        case promo = ""
        case language = "Change Language"
        
        func localized() -> String {
            switch self {
            case .personalInfo:
                return Localization.shared.personal_information
            case .changePass:
                return Localization.shared.change_password
            case .paymentHistory:
                return Localization.shared.payment_history
            case .dataBreach:
                return Localization.shared.data_breach_reports
            case .vulnerability:
                return Localization.shared.vulnerability_alerts
            case .securityNews :
                return Localization.shared.security_news
            case .specialOffers:
                return Localization.shared.special_offers
            case .changePlan:
                return Localization.shared.change_plan
            case .deleteAcc:
                return Localization.shared.delete_account
            case .logOut:
                return Localization.shared.log_out.capitalized
            case .language:
                return Localization.shared.settings_change_language
            default:
                return ""
            }
        }
    }
    
    struct SettingsData {
        var cellType : [SettingsCellType]
        var isStacked : Bool
    }
    
    struct EmailRadioData {
        var cellType : SettingsCellType
        var isSelected : Bool
    }
    
    var settingsDataArray : [SettingsData] = [SettingsData(cellType: [.personalInfo, .changePass, .language, .changePlan], isStacked: false), SettingsData(cellType: [.dataBreach, .vulnerability, .securityNews, .specialOffers], isStacked: true), SettingsData(cellType: [.logOut, .deleteAcc], isStacked: false)]
    
    var emailRadios : [EmailRadioData] = [EmailRadioData(cellType: .dataBreach, isSelected: false), EmailRadioData(cellType: .vulnerability, isSelected: false), EmailRadioData(cellType: .securityNews, isSelected: false), EmailRadioData(cellType: .specialOffers, isSelected: false)]

    let horizontalSpacing : CGFloat = 15
    var correctCollectionViewWidth : CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.contentInsetAdjustmentBehavior = .never
        self.collectionView!.register(SettingsActionCell.self, forCellWithReuseIdentifier: "SettingsActionCell")
        self.collectionView!.register(SettingsRadioCell.self, forCellWithReuseIdentifier: "SettingsRadioCell")
        self.collectionView?.register(SettingsSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsSectionHeader")
        self.collectionView?.register(SettingsProfileSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsProfileSectionHeader")
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.contentInset = .init(top: view.getCorrectSize(35, 35, 55), left: 0, bottom: 35, right: 0)
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 15 : (view.bounds.size.width - view.getCorrectSize(600, 600, 740)) / 2
        collectionView?.contentInset = .init(top: view.getCorrectSize(35, 35, 55), left: 0, bottom: 50, right: 0)
        correctCollectionViewWidth = view.bounds.size.width - horizontalInset * 2
    
        getEmailRadios()
    }
    
    func getEmailRadios() {
        self.getEmailRadios { success, isTokenValid in
        
            if success == false {
                DispatchQueue.main.async {
                    self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {})
                }
                return 
            }
            
            if isTokenValid == false {
                   SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.getEmailRadios()
                        } else {
                            self.presentLogoutDueToBadToken()
                        }
                    })
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func presentLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return settingsDataArray.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return settingsDataArray[section].cellType.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = settingsDataArray[indexPath.section]
        
        if data.isStacked == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsRadioCell", for: indexPath) as! SettingsRadioCell
            cell.titleLabel.text = data.cellType[indexPath.item].localized()
            DispatchQueue.main.asyncAfter(deadline: .now()+(0.1 * Double(indexPath.item) + 0.1)) {
                cell.radioButton.setOn(self.emailRadios[indexPath.item].isSelected, animated: true)
            }
            cell.containerView.clipsToBounds = true
            cell.widthConstraint?.constant = correctCollectionViewWidth
            cell.setupCellRoundness(firstCell: indexPath.item == 0, lastCell: indexPath.item == (data.cellType.count - 1))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsActionCell", for: indexPath) as! SettingsActionCell
            cell.titleLabel.text = data.cellType[indexPath.item].localized()
            cell.widthConstraint?.constant = correctCollectionViewWidth
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return settingsDataArray[section].isStacked == true ? 0 : collectionView.getCorrectSize(15, 15, 20)
    }
 
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsProfileSectionHeader", for: indexPath) as! SettingsProfileSectionHeader
            header.titleLabel.text = UserData.shared.firstName+" "+UserData.shared.lastName
            header.currentPlanLabel.text = UserData.shared.currentPlan.name+" \(Localization.shared.plan)"
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsSectionHeader", for: indexPath) as! SettingsSectionHeader
            header.titleLabel.text = settingsDataArray[indexPath.section].isStacked == true ? Localization.shared.settings_email_notification.uppercased() : ""
            header.leftConstraint?.constant = ((self.view.bounds.size.width - correctCollectionViewWidth) / 2)
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 { return CGSize(width: correctCollectionViewWidth, height: collectionView.getCorrectSize(82, 82, 100)) }
        let stacked = settingsDataArray[section].isStacked
        return CGSize(width: correctCollectionViewWidth, height: stacked == true ? collectionView.getCorrectSize(56, 56, 82) : collectionView.getCorrectSize(15, 15, 24))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSettingsAction(at: indexPath)
    }

    func performSettingsAction(at indexPath : IndexPath) {
        let data = settingsDataArray[indexPath.section].cellType[indexPath.item]
        
        switch data {
        case .personalInfo:
            updatePersonalInfo(at: indexPath)
        case .changePass:
            updatePassword(at: indexPath)
        case .deleteAcc:
            deleteAccount(at: indexPath)
        case .changePlan:
            changePlan(at: indexPath)
        case .logOut:
            logOut(at: indexPath)
        case .language:
            pushLanguageVC(at: indexPath)
        default:
            break
        }
    }
    
    // MARK: Present language VC

    func pushLanguageVC(at indexPath : IndexPath) {
        if view.isSmallScreenSize == false {
            let personalVC = LanguageSelectPopupViewController(title: "", rightButton: nil)
            personalVC.modalPresentationStyle = .overCurrentContext
            personalVC.transitioningDelegate = personalVC
            personalVC.popupCloseCompletion = {}
            self.navigationController?.present(personalVC, animated: true, completion: nil)
        } else {
            let languageSelectVC = LanguageSelectCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.present(UINavigationController(rootViewController: languageSelectVC), animated: true) { self.collectionView!.deselectItem(at: indexPath, animated: false) }
        }
    }
    
    // MARK: Update personal info
    
    func updatePersonalInfo(at indexPath : IndexPath) {
        if view.isSmallScreenSize == false {
            let personalVC = PersonalInfoPopupViewController(title: "", rightButton: nil)
            personalVC.modalPresentationStyle = .overCurrentContext
            personalVC.transitioningDelegate = personalVC
            personalVC.popupCloseCompletion = {}
            self.navigationController?.present(personalVC, animated: true, completion: nil)
        } else {
            let personalInfoVC = PersonalInfoViewController()
            self.navigationController?.present(UINavigationController(rootViewController: personalInfoVC), animated: true) { self.collectionView!.deselectItem(at: indexPath, animated: false) }
        }
    }
    
    func updatePassword(at indexPath : IndexPath) {
        if view.isSmallScreenSize == false {
            let passwordVC = PasswordChangePopupViewController(title: "", rightButton: nil)
            passwordVC.modalPresentationStyle = .overCurrentContext
            passwordVC.transitioningDelegate = passwordVC
            passwordVC.popupCloseCompletion = {}
            self.navigationController?.present(passwordVC, animated: true, completion: nil)
        } else {
            let passwordChangeViewController = PasswordChangeViewController()
            self.present(UINavigationController(rootViewController: passwordChangeViewController), animated: true) { self.collectionView!.deselectItem(at: indexPath, animated: false) }
        }
       }
    
    func deleteAccount(at indexPath : IndexPath) {
        let deleteAccVC = DeleteAccountViewController()
        let nav = UINavigationController(rootViewController: deleteAccVC)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: {
            self.collectionView!.deselectItem(at: indexPath, animated: false)
        })
    }
    
    func changePlan(at indexPath : IndexPath) {
        let paymentViewController = IAPPaidPlansViewController()
        let nav = OpaqueNavigationBar(rootViewController: paymentViewController)
        self.navigationController?.present(nav, animated: true, completion: nil)
        self.collectionView?.deselectItem(at: indexPath, animated: false)
    }
    
    func logOut(at indexPath : IndexPath) {
        let confirmationVC = UIAlertController(title: Localization.shared.settings_are_you_sure_you_want_to_log_out_, message: nil, preferredStyle: UIAlertController.Style.alert)
        confirmationVC.addAction(UIAlertAction(title: Localization.shared.yes.capitalized, style: .destructive, handler: { _ in
            _ = DashboardViewController.logoutUserWithoutError()
            self.dismiss(animated: true, completion: nil)
        }))
        confirmationVC.addAction(UIAlertAction(title: Localization.shared.cancel.capitalized, style: .cancel, handler: { (_) in }))
        confirmationVC.view.tintColor = UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1)
        present(confirmationVC, animated: true, completion: nil)
    }
    
    func getEmailRadios(completion: @escaping (Bool, Bool) -> ()) {
        
        guard let url = CyberExpertAPIEndpoint.getEmailRadios.url() else { completion(false, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, r, error) in
    
            guard let data = data else { completion(false, true); return }
            
            do {
                if let jsonDatas  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    if let data = (jsonDatas["data"] as? [[String : Any]])?.first {
                        self.emailRadios[0].isSelected = (data["data_breach_report"] as? Int ?? 0 == 1)
                        self.emailRadios[1].isSelected = (data["vulnerability_alerts"] as? Int ?? 0 == 1)
                        self.emailRadios[2].isSelected = (data["security_news"] as? Int ?? 0 == 1)
                        self.emailRadios[3].isSelected = (data["special_offers"] as? Int ?? 0 == 1)
                        completion(true, true);
                        return
                    } else {
                         if let dataObj = jsonDatas["data"] as? [String : Any] {
                            if let name =  dataObj["code"] as? Int {
                                if name == 401 { completion(true, false); return }
                            }
                        }
                    }
                }
            } catch {}
            completion(false, true);
        }
    }
    
    func setEmailRadios(completion : @escaping ((Bool, Bool)->())) {
        
        let index = settingsDataArray.firstIndex(where: { $0.isStacked == true }) ?? 2
        
        func saveEmailRadios() {
            
            guard let counter = self.settingsDataArray.first(where: { $0.isStacked == true })?.cellType.count else { completion(false, true); return }
            
            var notifBoolArray : [Bool] = []
            
            for i in 0..<counter {
                if let value = (self.collectionView?.cellForItem(at: IndexPath(row: i, section: index)) as? SettingsRadioCell)?.radioButton.isOn {
                    notifBoolArray.append(value)
                } else {
                    completion(false, true); return
                }
            }
            
            guard let url = CyberExpertAPIEndpoint.editEmailSettings.url() else { completion(false, true); return }
            var request = URLRequest.jsonRequest(url: url)
            request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            request.httpMethod = "POST"
            
            let parameters: [String: Any] = [
                "data_breach_report" : notifBoolArray[0],
                "vulnerability_alerts" : notifBoolArray[1],
                "security_news" : notifBoolArray[2],
                "special_offers" : notifBoolArray[3]
            ]
                        
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
                        
            NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
                if let data = data, let jsonDatas  = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]) as [String : Any]??) {
                    if let dataObj = jsonDatas?["data"] as? [String : Any] {
                        if let name =  dataObj["code"] as? Int {
                            if name == 401 { completion(true, false); return }
                        }
                    }
                }
                
                if let code = response as? HTTPURLResponse, code.statusCode == 201 && error == nil {
                    completion(true, true)
                    return
                } else {
                    completion(false, true)
                    return
                }
            }
        }
        
        
        for (i, radio) in self.emailRadios.enumerated() {
            if let cellRadio = (self.collectionView?.cellForItem(at: IndexPath(row: i, section: index)) as? SettingsRadioCell)?.radioButton.isOn {
                if cellRadio != radio.isSelected { saveEmailRadios(); return }
            } else {
                saveEmailRadios()
                return
            }
        }
        
        completion(true, true)
    }
}

