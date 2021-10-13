//
//  DeviceActivationViewController.swift
//  Xpert
//
//  Created by Darius on 27/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class DeviceActivationViewController : UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle { return .lightContent }
    
    weak var deviceActivationDelegate : DeviceActivationProtocol?

    let deviceData : DeviceData
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    var slides : [UIViewController] = []
    var index = 0
    
    let counterLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        return label
    }()
    
    init(deviceData: DeviceData) {
           self.deviceData = deviceData
           super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupPageController()
    }
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.text = Localization.shared.device_activating_device
        titleLabel.textColor = UIColor(named: "deviceAssessmentNavTitleColor")
        return titleLabel
    }()
    
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "deviceAssessmentNavLeftButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: counterLabel)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    }
    
    func setupPageController() {
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        
        let beginAssessmentViewController = ActivateDeviceViewController(deviceData: self.deviceData)
        pageViewController.setViewControllers([beginAssessmentViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        beginAssessmentViewController.activateDeviceButton.addTarget(self, action: #selector(setNextDeviceAssessmentQuestionViewController), for: .touchUpInside)
        
    }
    
    @objc func setNextDeviceAssessmentQuestionViewController() {
        let vc = DeviceAssessmentViewController(deviceData: self.deviceData)
        vc.counterLabel = self.counterLabel
        vc.presentNextQuestionCompletion = setNextDeviceAssessmentQuestionViewController
        vc.presentFinishedAssessmentCompletion = endAssessment
        pageViewController.setViewControllers([vc], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
    func endAssessment() {
        let finishedAssessmentVC = FinishedDeviceAssessmentController()
        finishedAssessmentVC.deviceActivationDelegate = self.deviceActivationDelegate
        pageViewController.setViewControllers([finishedAssessmentVC], direction: .forward, animated: true, completion: nil)
        
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "deviceAssessmentNavDoneButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: UIControl.State.highlighted)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @objc func closeViewController() {
        self.navigationController?.dismiss(animated: true, completion: { self.deviceActivationDelegate?.activateDevice() })
    }
    
    
    func resetIfNeeded() {
        if #available(iOS 13.0, *) {
            self.traitCollection.performAsCurrent {
               self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
               self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
               titleLabel.textColor = UIColor(named: "deviceAssessmentNavTitleColor")
                
                if traitCollection.userInterfaceStyle == .light {
                    self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                } else {
                    self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            resetIfNeeded()
        }
    }

    
}

extension DeviceActivationViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {  return nil}
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {  return nil }
}
