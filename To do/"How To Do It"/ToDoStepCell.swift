//
//  ToDoStepCell.swift
//  Xpert
//
//  Created by Darius on 2020-01-28.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import CDMarkdownKit

class ToDoStepCell: UICollectionViewCell {
    
    let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideImageView.alpha = 0 
    }
        
    var reloadCellDelegate : ReloadCellProtocol?
    var ip : IndexPath?
        
    func updateCell(with stepData : ToDoStepsData?, ip : IndexPath, count : Int) {
        guard let data = stepData else { return }
        self.ip = ip
        counterLabel.text = "\(ip.item + 1)."
        bottomLine.alpha = max(((count) - 1), 0) == ip.item ? 0 : 1
                   
        if let attrString = data.attrString {
            self.loadingView.stopAnimating()
            textLabelHeight?.isActive = false
            
            self.textLabel.attributedText = attrString
        } else {
            self.layoutIfNeeded()
            self.markdownParser.image.size = CGSize(width:  self.widthConstraint!.constant - self.textLabel.frame.minX - 30 + 10, height: 100)
            self.textLabel.text = nil
            self.textLabel.attributedText = nil
            
            textLabelHeight?.isActive = true
            self.loadingView.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
                let attrText = self.markdownParser.parse(data.markdown)
                DispatchQueue.main.async {
                    if self.ip!.item == ip.item {
                        self.loadingView.stopAnimating()
                        self.textLabel.attributedText = attrText
                        self.reloadCellDelegate!.setAttributedStepData(with: self.textLabel.attributedText!, ip: self.ip!)
                        self.textLabelHeight?.isActive = false
                    }
                }
            }
  
        }
    }
    
    var textLabelHeight : NSLayoutConstraint?
    let loadingView : LoadingBakcgroundView = LoadingBakcgroundView()

    var widthConstraint : NSLayoutConstraint?
    
    let hideImageView : UIView = {
        let imageView = UIView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        imageView.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        return imageView
    }()
    
    let textLabel : UITextViewFixed = {
        let label = UITextViewFixed()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.backgroundColor = .clear
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isScrollEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.isUserInteractionEnabled = true
        label.tintColor = UIColor.mainBlue
        return label
    }()
    
    let markdownParser : CDMarkdownParser = {
        let hugeScreen = UIScreen.main.bounds.size.width > 500
        let parser = CDMarkdownParser(font: UIFont(name: "Muli-Regular", size: hugeScreen == true ? 18 : 16)!,
                                      boldFont: UIFont(name: "Muli-Bold", size: hugeScreen == true ? 18 : 16),
                                      italicFont: UIFont(name: "Muli-Italic", size: hugeScreen == true ? 18 : 16),
        fontColor: UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1),
        backgroundColor: UIColor.clear)
        parser.link.color = CDColor.mainBlue
        parser.automaticLink.color = UIColor.mainBlue
        return parser
    }()
   
    let counterLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: UIScreen.main.bounds.size.width > 500 ? 17 : 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    let bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 205/255, green: 222/255, blue: 236/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        textLabelHeight = NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        textLabelHeight?.isActive = true
   
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
       
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
       
        contentView.addSubview(textLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(bottomLine)
       
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
       
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(47, 47, 64))-[v0(1)]-38-[v1]-30@777-|", views: bottomLine, textLabel)
        contentView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(4, 4, 8))-[v0]-4-[v1]|", views: counterLabel, bottomLine)
        contentView.addConstraintsWithFormat(format: "V:[v0]-\(getCorrectSize(50, 50, 70))@777-|", views: textLabel)

        NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: counterLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        contentView.addSubview(hideImageView)
        
        textLabel.addGestureRecognizer(tapGestureRecognizer)
       
        NSLayoutConstraint(item: counterLabel, attribute: .centerX, relatedBy: .equal, toItem: bottomLine, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        contentView.addSubview(loadingView)
        contentView.addConstraintsWithFormat(format: "V:|[v0(50)]", views: loadingView)
        contentView.addConstraintsWithFormat(format: "H:[v0(50)]", views: loadingView)
        NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: textLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        loadingView.stopAnimating()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UITextViewFixed: UITextView, UITextViewDelegate {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
