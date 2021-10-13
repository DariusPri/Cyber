//
//  ToDoViewController.swift
//  Xpert
//
//  Created by Darius on 28/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class ToDoViewController: NavViewController {
    
    let toDoCollectionViewController = ToDoCollectionViewController()
    
    init() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        super.init(leftButton: nil, rightButton: button, title: Localization.shared.to_do, subtitle: Localization.shared.x_tasks.doubleBracketReplace(with: "0"))
        subtitleLabel.font = subtitleLabel.font.withSize(view.getCorrectSize(12, 12, 16))
        button.heightAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "settings ic_max") : #imageLiteral(resourceName: "settings_ic"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        view.addSubview(toDoCollectionViewController.view)
        addChild(toDoCollectionViewController)
        toDoCollectionViewController.didMove(toParent: self)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: toDoCollectionViewController.view)
        view.addConstraintsWithFormat(format: "V:[v0]-\(view.getCorrectSize(27, 27, 74))-[v1]|", views: customNavBar, toDoCollectionViewController.view)
    }

}

extension ToDoViewController : UserSelectableTab {
    func tabDeselected() {
    }
    
    func userDidSelectTab() {
        if toDoCollectionViewController.dataIsFiltered == true {
            toDoCollectionViewController.output.filterTasks(with: toDoCollectionViewController.output.filteredPirorityDataArray, statusDataArray: toDoCollectionViewController.output.filteredStatusDataArray, deviceDataArray: toDoCollectionViewController.output.filteredDeviceDataArray)
        } else {
            toDoCollectionViewController.fetchToDoTasks()
        }
    }
}
