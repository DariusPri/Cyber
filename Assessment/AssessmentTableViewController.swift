//
//  AssessmentTableViewController.swift
//  Xpert
//
//  Created by Darius on 03/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class AssessmentTableViewController: UITableViewController {
    
    var assessmentAnswers : [AssessmentAnswer] = []
    var assessmentType : AssessmentType = .singleSelect { didSet{ setupTable() } }
    var singleSelectCompletion : ((Int)->())?
    var multipleSelectCompletion : (([Int])->())?
    var selectedItems : [Int] = []
    
    override func loadView() {
        super.loadView()
        let tv = CustomTableView()
        tv.dataSource = self;
        tv.delegate = self;
        self.view = tv;
        self.tableView = tv;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(AssessmentTableCell.self, forCellReuseIdentifier: "AssessmentTableCell")
        tableView.estimatedRowHeight = 76
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false 
    }
    
    func setupTable() {
        if assessmentType == .multipleSelect {
            tableView.allowsMultipleSelection = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return assessmentAnswers.count }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if assessmentType == .multipleSelect {
            
            if assessmentAnswers[indexPath.item].cancelsOutOtherAnswers == true {
                for i in selectedItems {
                    if i != indexPath.item {
                        tableView.deselectRow(at: IndexPath(item: i, section: indexPath.section), animated: false)
                    }
                }
                
                if selectedItems.contains(indexPath.item) == true {
                    selectedItems = [indexPath.item]
                } else {
                    selectedItems = []
                }

            } else {
                
                var removeUnneeded : [Int] = []
                for i in selectedItems {
                    if assessmentAnswers[i].cancelsOutOtherAnswers == true {
                        tableView.deselectRow(at: IndexPath(item: i, section: indexPath.section), animated: false)
                        removeUnneeded.append(i)
                    }
                }
                for i in removeUnneeded {
                    selectedItems.removeAll(where: { $0 == i })
                }
            }
                
            if selectedItems.contains(indexPath.item) {
                if let index = selectedItems.firstIndex(of: indexPath.item) { selectedItems.remove(at: index) }
                tableView.deselectRow(at: indexPath, animated: false)
            } else {
                selectedItems.append(indexPath.item)
            }
            
        }
        if assessmentType == .singleSelect {
            self.tableView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: { self.singleSelectCompletion?(indexPath.item) })
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if assessmentType == .multipleSelect && tableView.indexPathsForSelectedRows?.map({ $0.item }).contains(indexPath.item) == true { return nil }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentTableCell", for: indexPath) as! AssessmentTableCell
        cell.setup(cellData: assessmentAnswers[indexPath.item], cellType: assessmentType)
        return cell
    }
    
    // MARK:- Footer View
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return assessmentType == .multipleSelect ? 80 : CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if assessmentType == .singleSelect { return nil }
        let footerView = NextButtonFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
        footerView.nextButton.addTarget(self, action: #selector(nextQuestionAction(sender:)), for: .touchUpInside)
        return footerView
    }
    
    @objc func nextQuestionAction(sender : UIButton) {
        sender.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        multipleSelectCompletion?(selectedItems)
    }
  
}

class NextButtonFooterView: UIView {
    
    let nextButton = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor(named: "AssessmentNextQuestionBgColor")!, textColor: UIColor.white)
    
    let separatorLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 217/255, alpha: 1)
        return view
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        
        addSubview(separatorLine)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        addConstraintsWithFormat(format: "V:|[v0(\(1 / UIScreen.main.scale))]", views: separatorLine)

        addSubview(nextButton)
        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: nextButton)
        addConstraintsWithFormat(format: "V:|-14-[v0]-14-|", views: nextButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AssessmentTableCell : UITableViewCell {
    
    let mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        stack.spacing = 20
        return stack
    }()
    
    let questionLabel : DefaultLabel = {
        let label = DefaultLabel(text: "", edgeInsets: UIEdgeInsets.init(top: -2, left: 0, bottom: 0, right: 0))
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    var singleSelectView : SingleSelectView?
    var multipleSelectView : MultipleSelectView?
    
    func setup(cellData : AssessmentAnswer, cellType : AssessmentType) {
        switch cellType {
        case .singleSelect:
            singleSelectView = SingleSelectView()
            questionLabel.text = cellData.text
            [singleSelectView!, questionLabel].forEach({ mainStack.addArrangedSubview($0) })
            if let rightImage = cellData.rightImage { mainStack.addArrangedSubview(RightImageView(image : rightImage)) }
            break
        case .multipleSelect:
            multipleSelectView = MultipleSelectView()
            questionLabel.text = cellData.text
            [multipleSelectView!, questionLabel].forEach({ mainStack.addArrangedSubview($0) })
            if let rightImage = cellData.rightImage { mainStack.addArrangedSubview(RightImageView(image: rightImage)) }
            break
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        questionLabel.font = UIFont(name: "AvenirNext-Regular", size: getCorrectSize(16, 16, 20))
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        selectionStyle = .none
        contentView.addSubview(mainStack)
        mainStack.autoresizingMask = [.flexibleHeight]
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 32))-[v0]-\(getCorrectSize(20, 20, 32))-|", views: mainStack)
        contentView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(22, 22, 34))-[v0]-\(getCorrectSize(20, 20, 32))-|", views: mainStack)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        singleSelectView?.selectionState(isOn: selected)
        multipleSelectView?.selectionState(isOn: selected)
    }
    
    
}

class RightImageView : UIImageView {
    init(image : UIImage) {
        super.init(frame: .zero)
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 26)).isActive = true
        widthAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 26)).isActive = true
        contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SingleSelectView : UIView {
    
    let outerCircle : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1).cgColor
        return view
    }()
    
    let innerCircle : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        outerCircle.heightAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 24)).isActive = true
        outerCircle.widthAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 24)).isActive = true
        outerCircle.layer.cornerRadius = getCorrectSize(8, 8, 12)
        outerCircle.layer.borderWidth = getCorrectSize(2, 2, 3)

        innerCircle.heightAnchor.constraint(equalToConstant: getCorrectSize(8, 8, 12)).isActive = true
        innerCircle.widthAnchor.constraint(equalToConstant: getCorrectSize(8, 8, 12)).isActive = true
        innerCircle.layer.cornerRadius = getCorrectSize(4, 4, 6)
        
        addSubview(outerCircle)
        addSubview(innerCircle)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: outerCircle)
        addConstraintsWithFormat(format: "V:|[v0]|", views: outerCircle)
        NSLayoutConstraint(item: innerCircle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: innerCircle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    }
    
    func selectionState(isOn on : Bool) {
        UIView.animate(withDuration: 0.3) {
            self.innerCircle.alpha = on == true ? 1 : 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MultipleSelectView : UIView {

    let outerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let innerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    let innerImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 80/255, green: 172/255, blue: 235/255, alpha: 1)
        view.image = #imageLiteral(resourceName: "checkbox_tick")
        view.tintColor = .white
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        outerView.widthAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 24)).isActive = true
        outerView.heightAnchor.constraint(equalToConstant: getCorrectSize(16, 16, 24)).isActive = true
        outerView.layer.cornerRadius = getCorrectSize(4, 4, 24/4)
        outerView.layer.borderWidth = getCorrectSize(2, 2, 3)
        
        innerImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(10, 10, 15)).isActive = true
        innerImageView.widthAnchor.constraint(equalToConstant: getCorrectSize(10, 10, 15)).isActive = true
        innerImageView.contentMode = .scaleAspectFit
        
        addSubview(outerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: outerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: outerView)
        
        outerView.addSubview(innerView)
        outerView.addConstraintsWithFormat(format: "H:|[v0]|", views: innerView)
        outerView.addConstraintsWithFormat(format: "V:|[v0]|", views: innerView)
        
        innerView.addSubview(innerImageView)
        NSLayoutConstraint(item: innerImageView, attribute: .centerX, relatedBy: .equal, toItem: innerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: innerImageView, attribute: .centerY, relatedBy: .equal, toItem: innerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    }
    
    func selectionState(isOn on : Bool) {
        UIView.animate(withDuration: 0.3) {
            self.innerView.alpha = on == true ? 1 : 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
