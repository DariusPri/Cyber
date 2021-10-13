//
//  LoadingViewController.swift
//  Xpert
//
//  Created by Darius on 01/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
        
    var wasAnimated : Bool = false
    var animationView : AnimationView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.animationView = AnimationView(name: "splash_dark")
            } else {
                self.animationView = AnimationView(name: "splash_light")
            }
        } else {
            self.animationView = AnimationView(name: "splash_light")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        self.view.addSubview(animationView!)
        animationView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: animationView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animationView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func animate(completion : @escaping (()->())) {
        animationView!.play{ (finished) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                completion()
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if wasAnimated == true { return }
        wasAnimated = true
    }

  

}
