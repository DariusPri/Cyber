//
//  ScanCell.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ScanCell: SettingsCell {
    
    var scanCardsCV : ScanCardsCollectionViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    func setupScanCV() {
        scanCardsCV = ScanCardsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        scanCardsCV?.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scanCardsCV!.view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: scanCardsCV!.view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: scanCardsCV!.view )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
