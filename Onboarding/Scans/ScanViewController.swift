//
//  ScanViewController.swift
//  Xpert
//
//  Created by Darius on 09/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Lottie

class ScanViewController: UIPageViewController {

    var slides : [UIViewController] = []
    var index = 0
    var timer : Timer?
    
    var isTrial = false
    var hasInitView : Bool
    
    init(isTrial : Bool, initView : Bool? = true) {
        self.isTrial = isTrial
        self.hasInitView = initView ?? true
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = false 
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setupStartAssessment()
    }
    
    @objc func setupSlideViewControllers() {
        let firstSlideViewController = ScanSlideViewController(image: #imageLiteral(resourceName: "breachscan_ill_light"), header: Localization.shared.data_breaches_scan_header+"...", subheader: Localization.shared.data_breaches_scan_subheader, animationName: "scanning", explainerText: Localization.shared.personal_data_scans_info.doubleBracketReplace(with: Localization.shared.email_address_for_breaches))
       // let secondSlideViewController = ScanSlideViewController(image: #imageLiteral(resourceName: "email_ill_light"), header: Localization.shared.scheduling_scam_emails, subheader: Localization.shared.we_are_scheduling_some_fake_email_scams+"...", animationName: "scanning", explainerText: Localization.shared.personal_data_scans_info.doubleBracketReplace(with: Localization.shared.email_address_for_breaches))
        let secondSlideViewController = ScanSlideViewController(image: #imageLiteral(resourceName: "secscan_ill_light"), header: Localization.shared.device_vulnerability_header+"...", subheader: Localization.shared.device_vulnerability_subheader, animationName: "scanning", explainerText: Localization.shared.personal_data_scans_info.doubleBracketReplace(with: Localization.shared.device_for_vulnerabilities))
        let thirdSlideViewController = ScanSlideViewController(image: #imageLiteral(resourceName: "routerscan_ill_light"), header: Localization.shared.performing_a_router_scan+"...", subheader: Localization.shared.performing_a_router_scan_subheader, animationName: "scanning", explainerText: Localization.shared.personal_data_scans_info.doubleBracketReplace(with: Localization.shared.router_for_vulnerabilities))

        slides = [firstSlideViewController, secondSlideViewController, thirdSlideViewController]
        timer = Timer.scheduledTimer(timeInterval: 5.9, target: self, selector: #selector(setupNextSlide), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func setupNextSlide() {
        guard let slide = slides.popLast() else { timer?.invalidate(); timer = nil; showScanResultsViewController(); return }
        
        setViewControllers([slide], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: { _ in
            (slide as! ScanSlideViewController).detailedView.startAnimating()
        })
        
    }
    
    @objc func setupStartAssessment() {
        if hasInitView == true {
            let beginAssessmentViewController = WelcomeViewController(isTrial: isTrial)
            setViewControllers([beginAssessmentViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
            beginAssessmentViewController.startScanButton.addTarget(self, action: #selector(setupSlideViewControllers), for: .touchUpInside)
        } else {
            setupSlideViewControllers()
        }
    }
    
    func showScanResultsViewController() {
        if let scanVC = scanResultsVC {
            setViewControllers([scanVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: scanCompletion)
        } else {
        let scanResults = [ScanResultViewController.ScanData(scanType: .dataBreach, problemCount: 3, image: #imageLiteral(resourceName: "breach_small_ic")),
                           ScanResultViewController.ScanData(scanType: .scamEmails, problemCount: 0, image: #imageLiteral(resourceName: "email_suport_ic")),
                           ScanResultViewController.ScanData(scanType: .vulnerability, problemCount: 1, image: #imageLiteral(resourceName: "security_small_ic")),
                           ScanResultViewController.ScanData(scanType: .router, problemCount: 0, image: #imageLiteral(resourceName: "routerscan_small_ic")),
                           ]
        let scanResultsViewController = ScanResultViewController(score: 4, scanDataArray: scanResults)
        setViewControllers([scanResultsViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: scanCompletion)
        }

    }
    
    var scanCompletion : ((Bool)->Void)?
    var scanResultsVC : UIViewController?
    
}


extension ScanViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
}
