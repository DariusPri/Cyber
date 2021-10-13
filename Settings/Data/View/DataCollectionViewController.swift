//
//  DataCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit





// MARK: - DataViewControllerInput

/// _DataViewControllerInput_ is a protocol for view controller input behaviours
protocol DataViewControllerInput: DataPresenterOutput {
    
}


// MARK: - DataViewControllerOutput

/// _DevicesViewControllerInput_ is a protocol for view controller output behaviours
protocol DataViewControllerOutput {
    
    
    
    /// Tells the output (interactor) to fetch albums for Data
    ///
    /// - parameter DataId: The Data identifier
//    func fetchDeviceDatas()

    
    
    /// Tells the output (interactor) to fetch all Data
    func fetchAllData()
    
    
    /// Tells the output (interactor) to add new Data
    ///
    /// - parameter data: The Data string
    func addNewEmail(withEmailString email : String, andIsFamily isFamily : Bool)
    func addNewPhone(withPhoneStringh phone : String, andCountryCode code : String)
    func addNewCreditCard(withCreditCardString card : String)
    
    /// Tells the output (interactor) to delete Data
    ///
    /// - parameter indexPath: data index from collectionView
    func deleteEmail(at indexPath : IndexPath)
    func deletePhone(at indexPath : IndexPath)
    func deleteCreditCard(at indexPath : IndexPath)
    
    /// Tells the output (interactor) to resend activation for Data
    ///
    /// - parameter indexPath: data index from collectionView
    func resendActivationLinkForEmail(at indexPath : IndexPath)
    func resendActivationLinkForPhone(at indexPath : IndexPath)
    func resendActivationLinkForCreditCard(at indexPath : IndexPath)
    
    /// Tells the output (interactor) to set a timer to prevent users from spamming
    ///
    /// - parameter indexPath: data index from collectionView
    func setActivationEmailTimerForEmail(at indexPath : IndexPath)
    func setActivationEmailTimerForPhone(at indexPath : IndexPath)
    func setActivationEmailTimerForCard(at indexPath : IndexPath)

}


// MARK: - EmailsCollectionViewController

/// _EmailsCollectionViewController_ is a view controller responsible for displaying Data details like a list of Data
class DataCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ErrorPresenter {
    
    var output: DataViewControllerOutput!
    var router: DataRouterProtocol!
    
    fileprivate var dataViewModel: DataViewModel = DataViewModel()
    
    var correctCollectionViewWidth : CGFloat = 300
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of _DataViewController_ with a configurator
    ///
    /// - parameter configurator: The configurator
    ///
    /// - returns: The instance of _DataViewController_
    init(configurator: DataConfigurator = DataConfigurator.sharedInstance) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(configurator: configurator)
    }
    
    /// Initializes an instance of _DatasViewController_
    ///
    /// - parameter coder: The coder
    ///
    /// - returns: The instance of _DatasViewController_
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(configurator: DataConfigurator.sharedInstance)
    }
    
    // MARK: - Configurator
    
    private func configure(configurator: DataConfigurator = DataConfigurator.sharedInstance) {
        configurator.configure(viewController: self)
    }
    
    var horizontalInset : CGFloat = 0
    
    // MARK: - View lifecycle
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.isScrollEnabled = true
        self.collectionView!.register(DataSectionCollectionViewCell.self, forCellWithReuseIdentifier: "DataSectionCollectionViewCell")
        self.collectionView!.register(DataInputCollectionViewCell.self, forCellWithReuseIdentifier: "DataInputCollectionViewCell")
        self.collectionView!.register(NoDataCollectionViewCell.self, forCellWithReuseIdentifier: "NoDataCollectionViewCell")
        self.collectionView!.register(ErrorCollectionViewCell.self, forCellWithReuseIdentifier: "ErrorCollectionViewCell")
        self.collectionView!.register(EmailCollectionViewCell.self, forCellWithReuseIdentifier: "EmailCollectionViewCell")
        self.collectionView!.register(TitleLabelSectionCell.self, forCellWithReuseIdentifier: "TitleLabelSectionCell")
        self.collectionView?.backgroundColor = .clear
        
        self.hideKeyboardWhenTappedAround()
        
        setupLayout()
        
        //self.collectionView?.reloadData()
        //output.fetchAllData()
    }
    
    // MARK: - Setup
    
    func setupLayout() {
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.sectionInset = .zero
        }
      
        horizontalInset = view.isSmallScreenSize == true ? 15 : (view.bounds.size.width - view.getCorrectSize(600, 600, 720)) / 2
        collectionView?.contentInset = .init(top: 0, left: horizontalInset, bottom: 100, right: horizontalInset)
    }
    
    func isNoData() -> Bool {
        switch dataViewModel.currentIndex {
        case 1: return dataViewModel.creditCardDatas.count == 0
        case 2: return dataViewModel.phoneDatas.count == 0
        default: return dataViewModel.emailDatas.count == 0
        }
    }
    
    func isErrors() -> Bool {
        return self.dataViewModel.errorViewModel?.errorText?.count ?? 0 > 0 ? true : false
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return isErrors() == true ? 4 : 3 }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2:
            if isErrors() == true { return 1 }
            return (dataViewModel.currentIndex == 0 ? dataViewModel.emailDatas.count + 1  : (dataViewModel.currentIndex == 1 ? dataViewModel.creditCardDatas.count + 1 : dataViewModel.phoneDatas.count + 1))
        case 3:
            if isNoData() == true { return 1 }
            return (dataViewModel.currentIndex == 0 ? dataViewModel.emailDatas.count + 1  : (dataViewModel.currentIndex == 1 ? dataViewModel.creditCardDatas.count + 1 : dataViewModel.phoneDatas.count + 1))
        default:
            return 1
        }
    }
    
    var radioView : RadioButtonView?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataSectionCollectionViewCell", for: indexPath) as! DataSectionCollectionViewCell
            self.radioView = cell.radioView
            cell.radioView.selectedOptionCompletion = {index in self.radioSelected(withIndex: index)}
            cell.widthConstraint?.constant = collectionView.bounds.size.width - (horizontalInset * 2)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataInputCollectionViewCell", for: indexPath) as! DataInputCollectionViewCell
            cell.widthConstraint?.constant = collectionView.bounds.size.width - (horizontalInset * 2)
            cell.emailInputView.emailTextField.keyboardType = dataViewModel.currentIndex == 0 ? .emailAddress : (dataViewModel.currentIndex == 1 ? .numberPad : .phonePad)
            cell.emailInputView.emailTextField.text = ""
            if dataViewModel.currentIndex == 1 {
                cell.emailInputView.emailTextField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
                cell.emailInputView.emailTextField.delegate = self
            } else {
                cell.emailInputView.emailTextField.removeTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
                cell.emailInputView.emailTextField.delegate = nil
            }
            cell.emailInputView.actionButton.addTarget(self, action: #selector(addNewEmailAction), for: .touchUpInside)
            return cell
        case 2:
            if isErrors() == true && indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ErrorCollectionViewCell", for: indexPath) as! ErrorCollectionViewCell
                cell.widthConstraint?.constant = collectionView.bounds.size.width - (horizontalInset * 2)
                cell.errorViewModel = self.dataViewModel.errorViewModel
                return cell
            }
        default:
            break
        }
            
        if isNoData() == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionViewCell", for: indexPath) as! NoDataCollectionViewCell
            cell.widthConstraint?.constant = collectionView.bounds.size.width - (horizontalInset * 2)
            cell.heightConstraint?.constant = self.view.getCorrectSize(380, 500, 500)
            cell.setText(forTitle: Localization.shared.data_no_data, andSubtitle: Localization.shared.data_no_data_is_available_right_now_new_data_will_show_)
            cell.layoutIfNeeded()
            return cell
        }
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleLabelSectionCell", for: indexPath) as! TitleLabelSectionCell
            cell.widthConstraint?.constant = self.view.bounds.size.width - (horizontalInset * 2)
            cell.titleLabel.text = dataViewModel.getCurrentCardName()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmailCollectionViewCell", for: indexPath) as! EmailCollectionViewCell
        switch dataViewModel.currentIndex {
        case 1:
            let data = dataViewModel.creditCardDatas[indexPath.item-1]
            cell.updateUI(with: data.creditCardNumber, isActive: data.isActive, isFamilyMember: false, infoButtonVisible: data.infoButtonVisible, activationButtonIsActive: data.isActivationButtonActive)
        case 2:
            let data = dataViewModel.phoneDatas[indexPath.item-1]
            cell.updateUI(with: data.phoneNumber, isActive: data.isActive, isFamilyMember: false, infoButtonVisible: data.infoButtonVisible, activationButtonIsActive: data.isActivationButtonActive)
        default:
            let data = dataViewModel.emailDatas[indexPath.item-1]
            cell.updateUI(with: data.email, isActive: data.isActive, isFamilyMember: data.isFamily, infoButtonVisible: data.infoButtonVisible, activationButtonIsActive: data.isActivationButtonActive)
        }
        cell.infoButton.tag = indexPath.item-1
        cell.infoButton.addTarget(self, action: #selector(deleteEmail(sender:)), for: .touchUpInside)
        cell.resendActivationLinkButton.tag = indexPath.item-1
        cell.resendActivationLinkButton.addTarget(self, action: #selector(resendActivationLink(sender:)), for: .touchUpInside)
        cell.layoutIfNeeded()
        cell.widthConstraint?.constant = self.view.bounds.size.width - (horizontalInset * 2)
        return cell
    }
    
    @objc func resendActivationLink(sender : UIButton) {
        switch dataViewModel.currentIndex {
        case 1:
            output.resendActivationLinkForCreditCard(at: IndexPath(item: sender.tag, section: 0))
        case 2:
            output.resendActivationLinkForPhone(at: IndexPath(item: sender.tag, section: 0))
        default:
            output.resendActivationLinkForEmail(at: IndexPath(item: sender.tag, section: 0))
        }
    }
    
    @objc func deleteEmail(sender : UIButton) {
        let index = sender.tag
        
        var title : String?

        switch dataViewModel.getCorrectName() {
        case Localization.shared.data_email:
            title = Localization.shared.delete_emails_warning
        case Localization.shared.credit_card:
            title = Localization.shared.delete_card_warning
        case Localization.shared.phone_number:
            title = Localization.shared.delete_phone_warning
        default:
            title = nil
        }
        
        let alertVC = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = sender
        alertVC.popoverPresentationController?.sourceRect = sender.bounds
        alertVC.addAction(UIAlertAction(title: Localization.shared.delete.capitalized, style: .destructive, handler: { (_) in
            switch self.dataViewModel.currentIndex {
            case 1:
                self.output.deleteCreditCard(at: IndexPath(item: index, section: 0))
            case 2:
                self.output.deletePhone(at: IndexPath(item: index, section: 0))
            default:
                self.output.deleteEmail(at: IndexPath(item: index, section: 0))
            }
        }))
        alertVC.addAction(UIAlertAction(title: Localization.shared.cancel.capitalized, style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func addNewEmail(withString email : String, isFamily : Bool) {
        output.addNewEmail(withEmailString: email, andIsFamily: isFamily)
    }
    
    func addNewPhone(withString phone : String, andCountryCode code : String) {
        output.addNewPhone(withPhoneStringh: phone, andCountryCode: code)
    }
    
    func addNewCard(withString card : String) {
        output.addNewCreditCard(withCreditCardString: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }

    func radioSelected(withIndex index : Int) {
        if let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 1)) as? DataInputCollectionViewCell {
            cell.emailInputView.setupView(forIndex: index)
        }
        setNewTabIndex(with: index)
        updateNavSubtitleCounter()
    }
    
    @objc func addNewEmailAction() {
        self.dataViewModel.errorViewModel = nil
        guard let emailInputView = (collectionView?.cellForItem(at: IndexPath(item: 0, section: 1)) as? DataInputCollectionViewCell)?.emailInputView else { return }
        emailInputView.emailTextField.resignFirstResponder()
        switch dataViewModel.currentIndex {
            case 1:
                addNewCard(withString: emailInputView.emailTextField.text ?? "")
                break
            case 2:
                addNewPhone(withString: emailInputView.phoneInputField.textField.text ?? "", andCountryCode: emailInputView.phoneInputField.textField.countrySelectView?.selectedCountryTextField.text ?? "")
                break
            default:
                addNewEmail(withString: emailInputView.emailTextField.text ?? "", isFamily: emailInputView.checkBoxButton.isSelected)
                break
        }
        emailInputView.checkBoxButton.isSelected = false
    }
}





extension DataCollectionViewController : DataPresenterOutput {
    
    func setNewTabIndex(with index : Int) {
        self.dataViewModel.errorViewModel = nil
        dataViewModel.currentIndex = index
        displayAllData(withDataModel: dataViewModel)
    }
    
    func getCurrentTabIndex() -> Int {
        return dataViewModel.currentIndex
    }
    
    func displayError(viewModel: ErrorViewModel) {
        self.dataViewModel.errorViewModel = viewModel
        self.collectionView?.reloadData()
    }
    
    func updateNavSubtitleCounter() {
        var count : Int = 0
        switch dataViewModel.currentIndex {
        case 1:
            count = dataViewModel.creditCardDatas.count
        case 2:
            count = dataViewModel.phoneDatas.count
        default:
            count = dataViewModel.emailDatas.count
        }
        (self.parent as? DataViewController)?.changeEmailCounter(with: count, andCurrentIndex: dataViewModel.currentIndex)
    }

    func displayAllData(withDataModel model : DataViewModel) {
        let currentIndex = dataViewModel.currentIndex
        self.dataViewModel = model
        self.dataViewModel.currentIndex = currentIndex
        self.collectionView?.reloadData()
        updateNavSubtitleCounter()
    }
    
    func displaySuccessfulEmailActivationSent(at indexPath : IndexPath) {
        resetInputField()
        self.output.setActivationEmailTimerForEmail(at: indexPath)
        self.showSuccessPopup(title: Localization.shared.data_activation_email_for_your_data_has_been_sent.doubleBracketReplace(with: dataViewModel.getCorrectName()), subtitle: Localization.shared.data_check_your_email_for_your_activation_link_it_could, selector: #selector(closePopup))
    }
    func displaySuccessfulPhoneActivationSent(at indexPath : IndexPath) {
        resetInputField()
        self.output.setActivationEmailTimerForPhone(at: indexPath)
        self.showSuccessPopup(title: Localization.shared.data_activation_email_for_your_data_has_been_sent.doubleBracketReplace(with: dataViewModel.getCorrectName()), subtitle: Localization.shared.data_check_your_email_for_your_activation_link_it_could, selector: #selector(closePopup))
    }
    func displaySuccessfulCardActivationSent(at indexPath : IndexPath) {
        resetInputField()
        self.output.setActivationEmailTimerForCard(at: indexPath)
        self.showSuccessPopup(title: Localization.shared.data_activation_email_for_your_data_has_been_sent.doubleBracketReplace(with: dataViewModel.getCorrectName()), subtitle: Localization.shared.data_check_your_email_for_your_activation_link_it_could, selector: #selector(closePopup))
    }
    
    func resetInputField() {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as? DataInputCollectionViewCell {
            cell.emailInputView.emailTextField.resignFirstResponder()
            cell.emailInputView.phoneInputField.textField.resignFirstResponder()
            cell.emailInputView.phoneInputField.textField.countryPicker?.resignFirstResponder()
            cell.emailInputView.emailTextField.text = ""
            cell.emailInputView.phoneInputField.textField.text = ""
        }
    }
    
    @objc func closePopup() { }
    
    func displaySuccessfulNewEmail(at indexPath : IndexPath) {
        self.output.fetchAllData()
        self.showSuccessPopup(title: Localization.shared.data_your_data_has_been_added_but_it_s_not_active_yet.doubleBracketReplace(with: dataViewModel.getCorrectName()), subtitle: Localization.shared.data_check_your_email_for_your_activation_link_it_could, selector: #selector(closePopup))
    }
    func displaySuccessfulNewPhone(at indexPath : IndexPath) {
        self.output.fetchAllData()
        self.showSuccessPopup(title: Localization.shared.success.capitalized, subtitle: Localization.shared.phone_added, selector: #selector(closePopup))
    }
    func displaySuccessfulNewCard(at indexPath : IndexPath) {
        self.output.fetchAllData()
        self.showSuccessPopup(title: Localization.shared.success.capitalized, subtitle: Localization.shared.credit_card_is_added, selector: #selector(closePopup))
    }
    
    func displaySuccessfulDeletedEmail(at indexPath : IndexPath) { self.output.fetchAllData() }
    func displaySuccessfulDeletedPhone(at indexPath : IndexPath) { self.output.fetchAllData() }
    func displaySuccessfulDeletedCard(at indexPath : IndexPath) { self.output.fetchAllData() }

    func displayLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
    }
}



extension DataCollectionViewController : UITextFieldDelegate {
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        return newLength <= 19
    }
}
