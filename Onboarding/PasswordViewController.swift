//
//  PasswordViewController.swift
//  Xpert
//
//  Created by Darius on 26/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

struct CharacterCheck {
    var hasUpperCase : Bool
    var hasLowerCase : Bool
    var hasNumber : Bool
    var hasSpecialCharacter : Bool
}

class PasswordViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {

    // MARK :- Init
    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: Localization.shared.sign_up_to_dynarisk.doubleBracketReplace(with: "Dynarisk"), subtitle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle

    var passwordInputField : SquareTextView?
    var confirmPasswordInputField : SquareTextView?
    var nextButton : SquareButton?
    var highlightRangeArray : [NSRange] = []
    var iconDetailView : IconDetailView?
    var header : HeaderLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setupHeader()
        setupPasswordInputField()
        setupPasswordConfirmField()
        setupNextButton()
        setupMainStack()
        setupIconDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultValues()
    }
    
    // MARK:- Setup UI
    
    func setupHeader() {
        header = HeaderLabel(text: Localization.shared.password_choose_your_password, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        if view.isSmallScreenSize == false { header!.textAlignment = .center }
    }
    
    func setupMainStack() {
        _ = [header!, passwordInputField!, confirmPasswordInputField!, nextButton!].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(14, 14, 14)
        mainStack.setCustomSpacing(view.getCorrectSize(25, 25, 25), after: header!)
        mainStack.setCustomSpacing(24, after: confirmPasswordInputField!)
        
        mainScrollView.addSubview(mainStack)

        if view.isSmallScreenSize == true {
            mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: mainStack)
        } else {
            mainScrollView.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: view.getCorrectSize(48, 140, 200)).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        self.view.layoutIfNeeded()
    }
    
    func setupIconDetailView() {
        let highlightData = getHighlightData()
        highlightRangeArray = highlightData.wordsToUnderline.compactMap{ let range = highlightData.text.range(of: $0); return NSRange(location: highlightData.text.distance(from: highlightData.text.startIndex, to: range!.lowerBound), length: $0.count) }
        iconDetailView = IconDetailView(icon: #imageLiteral(resourceName: "lock_ic"), text: highlightData.text, margins : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), highlightedRangeArray : highlightRangeArray)
        let colorArray : [UIColor] = highlightRangeArray.map{ _ in return iconDetailView!.infoTextView.highlightedTextColor }
        iconDetailView!.infoTextView.colorListArray = colorArray
        mainStack.addArrangedSubview(iconDetailView!)
    }
    
    func setupNextButton() {
        nextButton = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        nextButton!.titleLabel?.font = nextButton!.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 15))
        nextButton!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        nextButton!.translatesAutoresizingMaskIntoConstraints = false
        nextButton!.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    func setupPasswordConfirmField() {
        confirmPasswordInputField = SquareTextView(placeholderText: Localization.shared.confirm_password)
        confirmPasswordInputField!.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordInputField!.textField.font = confirmPasswordInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        confirmPasswordInputField!.placeholderLabel.font = confirmPasswordInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        confirmPasswordInputField!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        confirmPasswordInputField!.textField.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            confirmPasswordInputField!.textField.passwordRules = UITextInputPasswordRules(descriptor: "")
        }
    }
    
    func setupPasswordInputField() {
        passwordInputField = SquareTextView(placeholderText: Localization.shared.password)
        passwordInputField!.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        passwordInputField!.textField.font = passwordInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        passwordInputField!.placeholderLabel.font = passwordInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        passwordInputField!.textField.addTarget(self, action: #selector(textViewDidChange(textField:)), for: .editingChanged)
        passwordInputField!.textField.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            passwordInputField!.textField.passwordRules = UITextInputPasswordRules(descriptor: "")
        }
    }
    
    func setDefaultValues() {
        passwordInputField?.textField.text = ""
        confirmPasswordInputField?.textField.text = (self.navigationController as? XpertNavigationController)?.registrationData?.password
        if passwordInputField?.textField.text?.count ?? 0 > 0 { passwordInputField?.setPlaceholder(on: false, animated: false) }
        if confirmPasswordInputField?.textField.text?.count ?? 0 > 0 { confirmPasswordInputField?.setPlaceholder(on: false, animated: false) }
        passwordInputField?.textField.insertText((self.navigationController as? XpertNavigationController)?.registrationData?.password ?? "")
    }
    
    func getHighlightData() -> (text: String, wordsToUnderline : [String]) {
        var text = Localization.shared.password_guidelines_with_tags
        var wordsToUnderline : [String] = []
        var stop = false
        var fixedUnderlinedWords : [String] = []

        while stop == false {
            let text_beg : [String] = text.components(separatedBy: "{{highlight}}")
            if text_beg.count < 2 { stop = true; continue }
               
            var b = text_beg
            b.removeFirst()
            text = text_beg[0]+"\u{00a0}"+b.joined(separator: "{{highlight}}")
                 
            let text_end : [String] = text.components(separatedBy: "{{/highlight}}")
            var c = text_end
            c.removeFirst()
            text = text_end[0]+"\u{00a0}"+c.joined(separator: "{{/highlight}}")
                 
            var wordToHighlight = text_beg[1].components(separatedBy: "{{/highlight}}")[0]
            wordToHighlight = "\u{00a0}"+wordToHighlight+"\u{00a0}"
                 
            wordsToUnderline.append(wordToHighlight)
        }
                       
        for word in wordsToUnderline {
            let replaceWord = word.replacingOccurrences(of: " ", with: "\u{00a0}")
            text = text.replacingOccurrences(of: word, with: replaceWord)
            fixedUnderlinedWords.append(replaceWord)
        }
            
        return (text: text, wordsToUnderline : fixedUnderlinedWords)
    }
    
    @objc func nextButtonAction() {
        
        passwordInputField?.textField.text = passwordInputField?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        confirmPasswordInputField?.textField.text = confirmPasswordInputField?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let password1 = passwordInputField?.textField.text, let password2 = confirmPasswordInputField?.textField.text, password1.count > 0, password2.count > 0 else {
            presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.settings_password_can_t_be_empty]))
            return
        }
        
        var errors : [String] = []
                
        if password1 != password2 { errors.append(Localization.shared.passwords_doesn_t_match) }
        if password1.count < 8 { errors.append(Localization.shared.settings_password_too_short_add_number_chars_.doubleBracketReplace(with: "\(8-password1.count)")) }
        
        let data = password1.check()
        if data.hasLowerCase == false { errors.append(Localization.shared.password_password_must_contain_lower_case_letters) }
        if data.hasUpperCase == false { errors.append(Localization.shared.password_password_must_contain_upper_case_letters) }
        if data.hasSpecialCharacter == false { errors.append(Localization.shared.password_add_at_least_one_special_character) }
        if data.hasNumber == false { errors.append(Localization.shared.password_add_at_least_one_digit) }
        
        if errors.count == 0 {
            presentError(viewModel: ErrorViewModel(errorText: nil))
            (self.navigationController as? XpertNavigationController)?.registrationData?.password = passwordInputField?.textField.text
            self.navigationController?.pushViewController(TermsViewController(), animated: true)
        } else {
            presentError(viewModel: ErrorViewModel(errorText: errors))
        }
    
    }
    
    // MARK:- Delegates


    @objc func textViewDidChange(textField : UITextField) {
        presentError(viewModel: ErrorViewModel(errorText: nil))
                
        let text = textField.text ?? ""
        var tempRangeArray : [NSRange] = []
        if text.count > 8 { tempRangeArray.append(highlightRangeArray[0]) }
        let data = text.check()
        if data.hasLowerCase == true { tempRangeArray.append(highlightRangeArray[2]) }
        if data.hasUpperCase == true { tempRangeArray.append(highlightRangeArray[1]) }
        if data.hasSpecialCharacter == true { tempRangeArray.append(highlightRangeArray[4]) }
        if data.hasNumber == true { tempRangeArray.append(highlightRangeArray[3]) }
        
        iconDetailView?.changeColor(with: UIColor(named: "passwordCheckBgColor")!, andTextHighlitColor: UIColor(named: "passwordCheckTextColor")!, andRangeArray: highlightRangeArray)
        iconDetailView!.changeColor(andRangeArray: tempRangeArray)
    }
}




class IconDetailView : UIView {
    
    let infoTextView = SpacingTextView()
    var  textViewHeight : NSLayoutConstraint?
    
    init(icon : UIImage, text : String, margins : UIEdgeInsets = .zero, highlightedRangeArray : [NSRange] = [], lineSpacing : CGFloat = 0.75, highlightColor : UIColor? = UIColor(named: "passwordCheckBgColor")!, highlightedTextColor : UIColor? = UIColor(named: "passwordCheckTextColor")!) {
        super.init(frame: .zero)

        isUserInteractionEnabled = false
        
        infoTextView.highlightedTextColor = highlightColor ?? UIColor(red: 57/255, green: 67/255, blue: 76/255, alpha: 1)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineSpacing
        paragraphStyle.lineSpacing = 1
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont(name: "Muli-Regular", size: getCorrectSize(13, 13, 16))!, NSAttributedString.Key.foregroundColor : UIColor(named: "passwordCheckDefaultTextColor")!, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        for range in highlightedRangeArray {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightedTextColor!, range: range)
        }
        
        infoTextView.backgroundRangeArray = highlightedRangeArray
        infoTextView.attributedText = attributedText
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let infoIcon = UIImageView()
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        infoIcon.widthAnchor.constraint(equalToConstant: getCorrectSize(24, 24, 32)).isActive = true
        infoIcon.heightAnchor.constraint(equalToConstant: getCorrectSize(24, 24, 32)).isActive = true
        infoIcon.contentMode = .center
        infoIcon.backgroundColor = .clear
        infoIcon.image = icon
        
        addSubview(infoIcon)
        addSubview(infoTextView)
        addConstraintsWithFormat(format: "H:|-\(margins.left)-[v0]-16-[v1]-\(margins.right)-|", views: infoIcon, infoTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: infoTextView)
        addConstraintsWithFormat(format: "V:|-4-[v0]", views: infoIcon)
        
        textViewHeight = infoTextView.heightAnchor.constraint(equalToConstant: getCorrectSize(18, 18, 26))
        textViewHeight?.isActive = true

    }
    
    func changeColor(with newHighlightColor : UIColor = UIColor(named: "passwordCheckHighlightBgColor")!, andTextHighlitColor textHighlightColor : UIColor = UIColor(named: "passwordCheckHighlightTextColor")!, andRangeArray rangeArray : [NSRange]) {
        if infoTextView.colorListArray.count != infoTextView.backgroundRangeArray.count { return }
        for (i,_) in infoTextView.backgroundRangeArray.enumerated() { infoTextView.colorListArray[i] = infoTextView.highlightedTextColor }
        
        for range in rangeArray {
            if let index = infoTextView.backgroundRangeArray.firstIndex(of: range) {
                infoTextView.colorListArray[index] = newHighlightColor
                let attr = NSMutableAttributedString(attributedString: infoTextView.attributedText)
                attr.addAttribute(.foregroundColor, value: textHighlightColor, range: range)
                infoTextView.attributedText = attr
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textViewHeight?.constant = infoTextView.contentSize.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SpacingTextView: UITextView, NSLayoutManagerDelegate {
    
    private var textHolder: String?
    var spacing: CGFloat = 4.5
    var highlightedTextColor: UIColor = .defaultTextColor
    
    var backgroundRangeArray : [NSRange] = []
    var colorListArray : [UIColor] = []

    override var attributedText: NSAttributedString! {
        didSet {
            self.textHolder = self.attributedText.string
            self.setNeedsDisplay()
        }
    }

    override var text: String! {
        didSet {
            self.textHolder = self.attributedText.string
            self.setNeedsDisplay()
        }
    }

    init() {
        super.init(frame: .zero, textContainer: nil)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        self.layoutManager.delegate = self
        self.backgroundColor = .clear
        self.textContainer.lineBreakMode = .byCharWrapping
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let _ = self.textHolder else {
            return
        }

        for (index, range) in backgroundRangeArray.enumerated() {
            self.layoutManager.enumerateEnclosingRects(forGlyphRange: range, withinSelectedGlyphRange: range, in: textContainer) { (rect, _) in
                var newRect = rect
                newRect.origin.y += self.spacing
                newRect.size.height -= self.spacing + 3
                
                let bezierPath = UIBezierPath(roundedRect: newRect, cornerRadius: 2)
                if self.colorListArray.isEmpty == true {
                    self.highlightedTextColor.setFill()
                } else {
                    self.colorListArray[index].setFill()
                }
                bezierPath.fill()
                bezierPath.close()
            }
        }
    }


    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return rect.size.height
    }

    func layoutManager(_ layoutManager: NSLayoutManager, shouldUse action: NSLayoutManager.ControlCharacterAction, forControlCharacterAt charIndex: Int) -> NSLayoutManager.ControlCharacterAction {
        return .lineBreak
    }
}


