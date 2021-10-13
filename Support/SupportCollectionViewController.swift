//
//  SupportCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 31/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SafariServices

class SupportCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    enum SupportType : String {
        case callUs = "Call us"
        case emailUs = "Email us"
        case hacked = "I've been Hacked"
        case faq = "Finding a solution by your own"
    }
    
    struct SupportData {
        var type : SupportType
        var title : String
        var subtitle : String
        var icon : UIImage
    }
    
    var supportDataArray : [SupportData] = [SupportData(type: SupportCollectionViewController.SupportType.faq, title: Localization.shared.faq.uppercased(), subtitle: Localization.shared.support_finding_a_solution_by_your_own, icon: #imageLiteral(resourceName: "support_faq_ic")),
                                            SupportData(type: SupportCollectionViewController.SupportType.hacked, title: Localization.shared.i_think_i_ve_been_hacked, subtitle: Localization.shared.support_call_us_now, icon: #imageLiteral(resourceName: "reason_hacekd_sml_ic")),
                                            SupportData(type: SupportCollectionViewController.SupportType.callUs, title: Localization.shared.call_us, subtitle: Localization.shared.support_working_hours_8_00__17_00, icon: #imageLiteral(resourceName: "talk_ic")),
                                            SupportData(type: SupportCollectionViewController.SupportType.emailUs, title: Localization.shared.email_us, subtitle: Localization.shared.replies_in_24, icon: #imageLiteral(resourceName: "email_suport_ic"))]
    var correctCollectionViewWidth : CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(SupportCell.self, forCellWithReuseIdentifier: "SupportCell")
        self.collectionView?.backgroundColor = .clear
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 720)) / 2
        collectionView?.contentInset = .init(top: view.getCorrectSize(0, 0, 48), left: horizontalInset, bottom: 50, right: horizontalInset)
        correctCollectionViewWidth = view.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        setCorrectImages()
    }
    
    func setCorrectImages() {
        if view.isHugeScreenSize == false { return }
        supportDataArray[0].icon = #imageLiteral(resourceName: "reason_hacekd_sml_ic_huge")
        supportDataArray[1].icon = #imageLiteral(resourceName: "chat_ic_huge")
        supportDataArray[2].icon = #imageLiteral(resourceName: "talk_ic_huge")
        supportDataArray[3].icon = #imageLiteral(resourceName: "email_suport_ic_huge")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return supportDataArray.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath) as! SupportCell
        cell.data = supportDataArray[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { takeActionFor(index: indexPath.item) }
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool { return false }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: correctCollectionViewWidth - 30, height: view.getCorrectSize(80, 80, 104))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.getCorrectSize(15, 15, 20)
    }

    //
    
    func takeActionFor(index : Int) {
        switch supportDataArray[index].type {
        case .hacked:
            let number = URL(string: "tel://02030868875")
            UIApplication.shared.open(number!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        case .emailUs:
            let emailUsPopupVC = EmailUsPopupViewController(title: Localization.shared.email_us, rightButton: nil); 
            emailUsPopupVC.modalPresentationStyle = .overCurrentContext
            emailUsPopupVC.transitioningDelegate = emailUsPopupVC
            emailUsPopupVC.popupCloseCompletion = { }
            self.present(emailUsPopupVC, animated: true, completion: nil)
        case .faq:
            let safariVC = SFSafariViewController(url: URL(string: "https://dynarisk.freshdesk.com/support/home/")!)
            safariVC.preferredControlTintColor = UIColor.mainBlue
            self.present(safariVC, animated: true, completion: nil)
        case .callUs:
            let number = URL(string: "tel://02030868875")
            UIApplication.shared.open(number!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        self.collectionView?.deselectItem(at: IndexPath(item: index, section: 0), animated: false)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
