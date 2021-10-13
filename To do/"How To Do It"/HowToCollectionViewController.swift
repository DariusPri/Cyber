//
//  HowToCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 2020-02-12.
//  Copyright © 2020. All rights reserved.
//

import UIKit


class HowToCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        if #available(iOS 12.0, *) {
        } else {
            context.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: [originalAttributes.indexPath])
        }
        return context
    }
}

class HowToCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sections : [ToDoTaskSectionData] = []
    
    var instructions : ToDoInstructionsData?
    var mainData : TodoMainData?
    var stepData : [ToDoStepsData]?
    var recomendationData : [ToDoRecomendationData]?
    var additionalOptionData : [ToDoAdditionalOptionData]?
    var filteredAdditionalOptionData : [ToDoAdditionalOptionData]?
    var rawDataExposedData : RawDataExposedData?
    var toDoBlueInfoData : ToDoBlueInfoData?

    var buttonData : ToDoButtonData?
    
    var searchText : String?
    var searchIsEditing : Bool = false
    
    var blueViewExpanded : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = .clear
        self.collectionView?.contentInsetAdjustmentBehavior = .never
        self.collectionView!.register(ToDoInstructionsCell.self, forCellWithReuseIdentifier: "ToDoInstructionsCell")
        self.collectionView!.register(ToDoInstructionsCheckList.self, forCellWithReuseIdentifier: "ToDoInstructionsCheckList")
        self.collectionView!.register(MoreButtonViewCell.self, forCellWithReuseIdentifier: "MoreButtonViewCell")
        self.collectionView!.register(HowToRecommendCell.self, forCellWithReuseIdentifier: "HowToRecommendCell")
        self.collectionView?.register(ToDoSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionHeaderView")
        self.collectionView!.register(ToDoSectionStepsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionStepsHeaderView")
        self.collectionView!.register(HowToAdditionalOptionsCell.self, forCellWithReuseIdentifier: "HowToAdditionalOptionsCell")
        self.collectionView!.register(HowToAdditionalOptionsSearchCell.self, forCellWithReuseIdentifier: "HowToAdditionalOptionsSearchCell")
        self.collectionView?.register(ToDoMainHeaderCell.self, forCellWithReuseIdentifier: "ToDoMainHeaderCell")
        self.collectionView?.register(ToDoMainExposedAccountsCell.self, forCellWithReuseIdentifier: "ToDoMainExposedAccountsCell")
        self.collectionView?.register(ToDoMainExplainerTextCell.self, forCellWithReuseIdentifier: "ToDoMainExplainerTextCell")
        self.collectionView?.register(ToDoMainExposedChecklistCell.self, forCellWithReuseIdentifier: "ToDoMainExposedChecklistCell")
        self.collectionView?.register(HowToRawDataExposedCell.self, forCellWithReuseIdentifier: "HowToRawDataExposedCell")
        self.collectionView?.register(ToDoBlueInfoCell.self, forCellWithReuseIdentifier: "ToDoBlueInfoCell")
        self.collectionView?.register(ToDoStepCell.self, forCellWithReuseIdentifier: "ToDoStepCell")

        self.collectionView?.contentInset = .init(top: 54, left: 0, bottom: 30, right: 0)
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        self.hideKeyboardWhenTappedAround()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return sections.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section].section
        switch sectionType {
        case .instructions: return (instructions?.checklistData.count ?? 0) + (instructions?.text == nil ? 0 : 1)
        case .moreButton, .recomendations, .blueInfo: return 1
        case .additionalOptions: return 2
        case .rawDataExposed: return 1
        case .mainData: return 1 + (mainData?.accExposed == nil ? 0 : 1) + (mainData?.explainedText == nil ? 0 : 1) + (mainData?.checkListData == nil ? 0 : 1)
        case .steps: return stepData?.count ?? 1 }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section].section {
        case .instructions:
            if indexPath.item == 0 {
                let insets = insetForSection(at: indexPath.section)

                if let text = instructions?.text, let title = instructions?.title {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoInstructionsCell", for: indexPath) as! ToDoInstructionsCell
                    cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                    cell.textLabel.text = text
                    cell.titleLabel.text = title
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoInstructionsCheckList", for: indexPath) as! ToDoInstructionsCheckList
                    cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                    cell.data = instructions?.checklistData[indexPath.item]
                    return cell
                }
            }
            
           return UICollectionViewCell(frame: .zero)

        case .blueInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoBlueInfoCell", for: indexPath) as! ToDoBlueInfoCell
            let insets = insetForSection(at: indexPath.section)
            cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
            cell.data = toDoBlueInfoData
            cell.setupCollapse(on: !blueViewExpanded)
            cell.viewMoreButton.addTarget(self, action: #selector(expandBlueInfoView), for: .touchUpInside)
            return cell
        case .mainData:
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoMainHeaderCell", for: indexPath) as! ToDoMainHeaderCell
                let insets = insetForSection(at: indexPath.section)
                cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                cell.addHeaderView(header: mainData?.header ?? "", icon: mainData?.icon, redText: mainData?.redFlag)
                return cell
            } else {
                let index = indexPath.item - 1
                for i in index..<3 {
                    if i == 0 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoMainExposedAccountsCell", for: indexPath) as! ToDoMainExposedAccountsCell
                        let insets = insetForSection(at: indexPath.section)
                        cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                        cell.accountsList = mainData?.accExposed
                        return cell
                    }
                    if i == 1 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoMainExplainerTextCell", for: indexPath) as! ToDoMainExplainerTextCell
                        let insets = insetForSection(at: indexPath.section)
                        cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                        cell.textLabel.text = mainData?.explainedText
                        return cell
                    }
                    if i == 2 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoMainExposedChecklistCell", for: indexPath) as! ToDoMainExposedChecklistCell
                        let insets = insetForSection(at: indexPath.section)
                        cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                        cell.dataListArray = mainData?.checkListData
                        return cell
                    }
                }
            }
            return UICollectionViewCell()
        case .moreButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreButtonViewCell", for: indexPath) as! MoreButtonViewCell
            let insets = insetForSection(at: indexPath.section)
            cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
            cell.data = buttonData
            cell.actionButton.addTarget(self, action: #selector(moreInfoButtonAction(sender:)), for: .touchUpInside)
            return cell
        case .steps:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoStepCell", for: indexPath) as! ToDoStepCell
            cell.tapGestureRecognizer.addTarget(self, action: #selector(cellTextViewTappedAction(sender:)))
            let insets = insetForSection(at: indexPath.section)
            cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
            cell.reloadCellDelegate = self
            cell.updateCell(with: stepData?[indexPath.item], ip: indexPath, count: stepData?.count ?? 0)
            return cell
        case .recomendations:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToRecommendCell", for: indexPath) as! HowToRecommendCell
            let insets = insetForSection(at: indexPath.section)
            cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
            setupRecomendationCVIfNeededFor(cell)
            return cell
        case .additionalOptions:
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToAdditionalOptionsSearchCell", for: indexPath) as! HowToAdditionalOptionsSearchCell
                let insets = insetForSection(at: indexPath.section)
                cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                cell.searchTextField.addTarget(self, action: #selector(searchTextFieldChanged(textField:)), for: .editingChanged)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToAdditionalOptionsCell", for: indexPath) as! HowToAdditionalOptionsCell
                let insets = insetForSection(at: indexPath.section)
                cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
                setupAdditionalOptionsCVIfNeededFor(cell)
                return cell
            }
            
        case .rawDataExposed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToRawDataExposedCell", for: indexPath) as! HowToRawDataExposedCell
            let insets = insetForSection(at: indexPath.section)
            cell.widthConstraint?.constant = collectionView.bounds.size.width - insets.left - insets.right
            cell.rawData = rawDataExposedData
            return cell
        }
        
    }
    
    @objc func cellTextViewTappedAction(sender : UITapGestureRecognizer) {
        
        if let textView = sender.view as? UITextView {
                                    
            textView.attributedText.enumerateAttribute(NSAttributedString.Key.link, in: NSRange(location: 0, length: textView.attributedText.length), options: []) { (value, range, _) in
                
                if let link = value as? NSURL {
                    let start = textView.position(from: textView.beginningOfDocument, offset: range.location)
                    let end = textView.position(from: start!, offset: range.length)!
                    let tRange = textView.textRange(from: start!, to: end)
                    let recto = textView.firstRect(for: tRange!)
                  
                    if recto.contains(sender.location(in: sender.view)) == true {
                        UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
                    }
                }
            }
            
            textView.attributedText.enumerateAttribute(.attachment, in: NSRange(location: 0, length: textView.attributedText.length), options:[]) { (value, range, _) in
                if value is NSTextAttachment {
                    
                    let start = textView.position(from: textView.beginningOfDocument, offset: range.location)
                    let end = textView.position(from: start!, offset: range.length)!
                    let tRange = textView.textRange(from: start!, to: end)
                    let recto = textView.firstRect(for: tRange!)
                    
                    if recto.contains(sender.location(in: sender.view)) == true {
                        let attachment: NSTextAttachment? = (value as? NSTextAttachment)
                        
                        var image : UIImage?

                        if ((attachment?.image) != nil) {
                            image = attachment?.image
                        } else {
                            image = attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location)
                        }
                        
                        if let image = image, let ip = collectionView.indexPathForItem(at: sender.location(in: self.collectionView)), let cell = collectionView.cellForItem(at: ip) as? ToDoStepCell {
                            let frame = cell.textLabel.convert(recto, to: nil)
                            cell.hideImageView.frame = cell.textLabel.convert(recto, to: cell)
                            
                            let previewVC = PreviewTutorialViewController(image: image, imageFrame: frame, text: cell.textLabel.text, imageView: nil, hidenImageView: cell.hideImageView)
                            previewVC.modalPresentationStyle = .overCurrentContext
                            previewVC.modalPresentationCapturesStatusBarAppearance = true
                            previewVC.transitioningDelegate = previewVC
                            self.present(previewVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let data = sections[indexPath.section]
        var headerView : UICollectionReusableView!
        
        switch data.section {
        case .recomendations, .additionalOptions, .rawDataExposed:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionHeaderView", for: indexPath) as! ToDoSectionHeaderView
            (headerView as! ToDoSectionHeaderView).titleLabel.text = sections[indexPath.section].section.localized()
        case .mainData:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionHeaderView", for: indexPath) as! ToDoSectionHeaderView
            (headerView as! ToDoSectionHeaderView).titleLabel.text = mainData?.sectionName
        case .steps:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionStepsHeaderView", for: indexPath) as! ToDoSectionStepsHeaderView
        default:
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ToDoSectionHeaderView", for: indexPath) as! ToDoSectionHeaderView
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height : CGFloat = sections[section].section == .steps ? view.getCorrectSize(95, 95, 120) : (sections[section].visible == true ? 44 : CGFloat.leastNormalMagnitude)
        //let height : CGFloat = sections[section].section == .steps ? view.getCorrectSize(95, 95, 120) : (sections[section].visible == true ? 44 : CGFloat.leastNormalMagnitude)
        return CGSize(width: collectionView.bounds.size.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection(at: section)
    }
    
    func insetForSection(at section : Int) -> UIEdgeInsets {
        var bottomInset : CGFloat = 0
        var topInset : CGFloat = 0
        switch sections[section].section {
        case .instructions: bottomInset = 30
        case .blueInfo: bottomInset = 25
        case .mainData: bottomInset = 15
        case .recomendations: topInset = 6; bottomInset = 4
        case .additionalOptions: bottomInset = 15
        default: bottomInset = 0 }
        return UIEdgeInsets(top: topInset, left: 0, bottom: (sections.count - 1) == section ? 70 : bottomInset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (sections[section].section == .steps) ? 0 : 30
    }
    
    // MARK: - Setup Recommend CV
    
    func setupRecomendationCVIfNeededFor(_ cell : HowToRecommendCell) {
        if cell.howToRecommendCVController == nil {
            let cv = HowToRecommendCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            cv.recomendationData = recomendationData
            self.addChild(cv)
            cv.didMove(toParent: self)
            cell.howToRecommendCVController = cv
            cell.setupCV()
        }
        cell.howToRecommendCVController?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Setup Additional Options CV
    
    func setupAdditionalOptionsCVIfNeededFor(_ cell : HowToAdditionalOptionsCell) {
        if cell.howToAdditionalOptionsCVController == nil {
            let cv = HowToAdditionalOptionsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            cv.additionalOptionsData = filteredAdditionalOptionData ?? additionalOptionData ?? []
            self.addChild(cv)
            cv.didMove(toParent: self)
            cell.howToAdditionalOptionsCVController = cv
            cell.setupCV()
        } else {
            if let filteredData = filteredAdditionalOptionData {
                cell.howToAdditionalOptionsCVController?.additionalOptionsData = filteredData
                cell.howToAdditionalOptionsCVController?.collectionView?.reloadData()
                reloadAdditionalOptionsArray()
            }
        }
    }
}

extension HowToCollectionViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchIsEditing = true
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func searchTextFieldChanged(textField : UITextField) {
        searchText = textField.text
        if let text = searchText, text.count > 0 { filteredAdditionalOptionData = additionalOptionData?.filter({ $0.name.lowercased().contains(text.lowercased()) == true })
        } else { filteredAdditionalOptionData = additionalOptionData }
        reloadAdditionalOptionsArray()
    }
    
    func reloadAdditionalOptionsArray() {
        guard let index : Int = sections.firstIndex(where: { $0.section == .additionalOptions}) else { return }
        
        self.collectionView?.performBatchUpdates({
            self.collectionView?.reloadItems(at: [IndexPath(item: 1, section: index)])
            self.collectionView?.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.collectionViewLayout.invalidateLayout()
            self.collectionView?.layoutIfNeeded()
        })
    }
}


extension HowToCollectionViewController : ReloadCellProtocol {
    func setAttributedStepData(with attrString : NSAttributedString, ip : IndexPath) {
        stepData?[ip.item].attrString = attrString
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}



extension HowToCollectionViewController {
    @objc func expandBlueInfoView() {
        blueViewExpanded = !blueViewExpanded
        self.collectionView.reloadDataWithoutScroll()
    }
    
    
    @objc func moreInfoButtonAction(sender : UIButton) {
        let emailUsPopupVC = EmailUsPopupViewController(title: Localization.shared.email_us, rightButton: nil);
        emailUsPopupVC.modalPresentationStyle = .overFullScreen
        emailUsPopupVC.transitioningDelegate = emailUsPopupVC
        emailUsPopupVC.popupCloseCompletion = { }
        self.present(emailUsPopupVC, animated: true, completion: nil)
    }
}
