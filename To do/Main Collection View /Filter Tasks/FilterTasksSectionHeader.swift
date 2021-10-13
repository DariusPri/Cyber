//
//  FilterTasksSectionHeader.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class FilterTasksSectionHeader: UICollectionReusableView {
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(12, 12, 16))
        
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: titleLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
