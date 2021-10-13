//
//  ToDoMainDataCell.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoMainHeaderCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?

    var redLabelConstraints : [NSLayoutConstraint] = []
    var noRedLabelConstraints : [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        textLabel.font = textLabel.font.withSize(getCorrectSize(18, 18, 24))
        redLabel.font = redLabel.font.withSize(getCorrectSize(18, 18, 24))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(textLabel)
        contentView.addSubview(redLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        redLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0(\(getCorrectSize(39, 39, 50)))]-\(getCorrectSize(15, 15, 20))@777-[v1]-\(getCorrectSize(30, 30, 42))-|", views: iconImageView, textLabel)
        contentView.addConstraintsWithFormat(format: "V:|[v0(\(getCorrectSize(39, 39, 50)))]", views: iconImageView)
        contentView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(8, 8, 12))-[v0]-\(getCorrectSize(20, 20, 22))-[v1]", views: textLabel, redLabel)
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-15@777-|", views: redLabel)
        
        noRedLabelConstraints = [NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1, constant: 0)]
        noRedLabelConstraints.first?.isActive = true
        redLabelConstraints = [NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: redLabel, attribute: .bottom, multiplier: 1, constant: 0)]
        
    }
    
    func addHeaderView(header : String, icon: UIImage?, redText : String?) {
        textLabel.text = header
        iconImageView.image = icon
        redLabel.text = redText
        
        if redText == nil {
            redLabelConstraints.forEach({ $0.isActive = false })
            noRedLabelConstraints.forEach({ $0.isActive = true })
        } else {
            noRedLabelConstraints.forEach({ $0.isActive = false })
            redLabelConstraints.forEach({ $0.isActive = true })
        }
        
        redLabel.preferredMaxLayoutWidth = (widthConstraint?.constant ?? 200) - 60 + getCorrectSize(0, 0, 12)
        
        textLabel.sizeToFit()
        redLabel.sizeToFit()
        redLabel.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = ""
        iconImageView.image = nil
        redLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    let redLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}




class ToDoMainExposedAccountsCell: UICollectionViewCell {
    
    var accountsList : [String]? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let list = accountsList else { return }
        for accountText in list {
            let exposedLabel = ExposedAccountLabel(text: accountText)
            exposedLabel.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(exposedLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.arrangedSubviews.forEach({ ($0 as? ExposedAccountLabel)?.preferredMaxLayoutWidth = self.bounds.size.width - 60 })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    var widthConstraint : NSLayoutConstraint?
    let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(18, 18, 24))
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-30@777-|", views: container)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        
        container.addSubview(titleLabel)
        
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.priority = .init(777)
        topConstraint.isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        NSLayoutConstraint(item: stack, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stack, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: stack, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10)
        bottomConstraint.priority = .init(rawValue: 777)
        bottomConstraint.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.shared.to_accounts_exposed
        label.preferredMaxLayoutWidth = 300
        return label
    }()
    
    class ExposedAccountLabel: UILabel {
        init(text: String) {
            super.init(frame: .zero)
            self.text = text
            textColor = UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1)
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
            font = UIFont(name: "Muli-Regular", size: getCorrectSize(17, 17, 22))
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}


class ToDoMainExplainerTextCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        textLabel.font = textLabel.font.withSize(getCorrectSize(17, 17, 21))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        let container = UIView()
        container.addSubview(textLabel)
        contentView.addSubview(container)
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-30@777-|", views: container)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: textLabel)
        container.addConstraintsWithFormat(format: "V:|[v0]", views: textLabel)
        
        NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.preferredMaxLayoutWidth = self.bounds.size.width - 60
    }
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
}


class ToDoMainExposedChecklistCell: UICollectionViewCell {
    
    var dataListArray : [String]? { didSet{ updateUI() }}
    
    func updateUI() {
        guard let list = dataListArray else { return }
        for text in list {
            let checklistView = CheckListView(text: text)
            stack.addArrangedSubview(checklistView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.arrangedSubviews.forEach({ v in (v as? CheckListView)?.textLabel.preferredMaxLayoutWidth = contentView.bounds.size.width - 60 })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.shared.to_accounts_exposed
        return label
    }()
    
    let stack = UIStackView()
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        textLabel.font = textLabel.font.withSize(getCorrectSize(18, 18, 22))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        let container = UIView()
        addSubview(container)
        addConstraintsWithFormat(format: "H:|[v0]|", views: container)
        addConstraintsWithFormat(format: "V:|[v0]|", views: container)
        
        stack.axis = .vertical
        stack.spacing = 14
        
        container.addSubview(textLabel)
        container.addSubview(stack)
        
        container.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-30@777-|", views: textLabel)
        container.addConstraintsWithFormat(format: "V:|-10-[v0]-15@777-[v1]-15-|", views: textLabel, stack)
        container.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-30@777-|", views: stack)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class CheckListView: UIView {
        
        let textLabel : UILabel = {
            let label = UILabel()
            label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont(name: "Muli-Regular", size: 17)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let redIconImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "indicator_red")
            imageView.contentMode = .center
            return imageView
        }()
        
        init(text : String) {
            super.init(frame: .zero)
            
            redIconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(5, 5, 7)).isActive = true

            textLabel.font = textLabel.font.withSize(getCorrectSize(17, 17, 20))
            textLabel.text = text
            textLabel.sizeToFit()
            
            let container = UIView()
            container.addSubview(textLabel)
            addSubview(container)
            addConstraintsWithFormat(format: "H:|[v0]|", views: container)
            addConstraintsWithFormat(format: "V:|[v0]|", views: container)
            
            container.addSubview(textLabel)
            container.addSubview(redIconImageView)
            
            container.addConstraintsWithFormat(format: "H:|[v0(\(getCorrectSize(5, 5, 7)))]-\(getCorrectSize(15, 15, 18))-[v1]-(>=0)-|", views: redIconImageView, textLabel)
            NSLayoutConstraint(item: redIconImageView, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .top, multiplier: 1, constant: 10).isActive = true
            container.addConstraintsWithFormat(format: "V:|[v0]|", views: textLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
