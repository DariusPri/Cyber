//
//  PaidPlansPageController.swift
//  Xpert
//
//  Created by Darius on 23/10/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PaidPlansPageController: UIPageViewController, ErrorPresenter {
        
    var slides : [UIViewController] = []
    var index = 0
    var timer : Timer?
    
    var paidPlans : [PaidPlan]

    init(plans : [PaidPlan]) {
        paidPlans = plans
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setupSlideViewControllers()
    }
    
    @objc func setupSlideViewControllers() {
        
        for paidPlan in paidPlans {
            if paidPlan.type == .vip {
                let vipCVC = paidPlan.isAppStorePlan == true ? IAPVIPPlanCollectionViewController(plan: paidPlan) : VIPPlanCollectionViewController(plan: paidPlan)
                vipCVC.numberOfPlans = paidPlans.count
                slides.append(vipCVC)
            } else {
                let paidPlansCVC = paidPlan.isAppStorePlan == true ? IAPPaidPlansCollectionViewController(plan: paidPlan) : PaidPlansCollectionViewController(plan: paidPlan)
                paidPlansCVC.numberOfPlans = paidPlans.count
                slides.append(paidPlansCVC)
            }
        }
      
        for (i, slide) in slides.enumerated() {
            (slide as? PaidPlansCollectionViewController)?.indicatorIndex = i
        }
        
        if let slide = slides.first {
            setViewControllers([slide], direction: .forward, animated: true, completion: nil)
        } else {
            self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
}


extension PaidPlansPageController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = slides.firstIndex(of: viewController ) {
            switch index {
            case 0:
                return slides[slides.count - 1]
            default:
                return slides[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = slides.firstIndex(of: viewController ) {
            switch index {
            case slides.count - 1:
                return slides[0]
            default:
                return slides[index + 1]
            }
        }
        return nil
    }
    
}
