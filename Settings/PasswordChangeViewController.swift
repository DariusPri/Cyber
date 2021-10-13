//
//  PasswordChangeViewController.swift
//  Xpert
//
//  Created by Darius on 2020-01-15.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class PasswordChangeViewController : TextInputViewController {
    
    
    init() {
        let data = [TextInputCollectionViewController.TextInputData(inputType: .oldPass, placeholder: Localization.shared.settings_type_your_current_password+"...", value: "", isOptional: false, isEnabled: true),
                    TextInputCollectionViewController.TextInputData(inputType: .newPass, placeholder: Localization.shared.new_password+"...", value: "", isOptional: false, isEnabled: true),
                    TextInputCollectionViewController.TextInputData(inputType: .retypeNewPass, placeholder: Localization.shared.settings_retype_new_password+"...", value: "", isOptional: false, isEnabled: true)]
        super.init(data: data)
        headerLabel.text = Localization.shared.change_password
        textInputCompletionData = { data in
                        
            if (data[0].value.count == 0 || data[1].value.count == 0 || data[2].value.count == 0) {
                self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.settings_password_can_t_be_empty]))
                return
            }
                        
            let oldPassword = data[0].value
            let password1 = data[1].value
            let password2 = data[2].value
        
            var errors : [String] = []
                        
            if password1 != password2 { errors.append(Localization.shared.settings_password_doesn_t_match) }
            if password1.count < 8 { errors.append(Localization.shared.settings_password_too_short_add_number_chars_.doubleBracketReplace(with: "\(8-password1.count)")) }
            
            let data = self.check(text: password1)
            if data.hasLowerCase == false { errors.append(Localization.shared.password_password_must_contain_lower_case_letters) }
            if data.hasUpperCase == false { errors.append(Localization.shared.password_password_must_contain_upper_case_letters) }
            if data.hasSpecialCharacter == false { errors.append(Localization.shared.password_add_at_least_one_special_character) }
            if data.hasNumber == false { errors.append(Localization.shared.password_add_at_least_one_digit) }
            
            if errors.count == 0 {
                var tokenRequestAlreadyMade = false
                func updateToken() {
                    tokenRequestAlreadyMade = true
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            changePassword()
                        } else {
                            self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                        }
                    })
                }
                
                func changePassword() {
                    self.changePasswordRequest(passData: (oldPassword: oldPassword, password1: password1, password2: password2), completion: { (errorArray, isTokenExpired) in
                        if isTokenExpired == true {
                            if tokenRequestAlreadyMade == true {
                                self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                            } else {
                                updateToken()
                            }
                        }
                        if let errors = errorArray {
                            self.presentError(viewModel: ErrorViewModel(errorText: errors))
                        } else {
                            self.presentError(viewModel: ErrorViewModel(errorText: nil))
                            DispatchQueue.main.async {
                                self.presentSuccessfulCenterPopup(withIcon: UIImage(named: "donecheck_ill_dark"), andTitle: Localization.shared.success.capitalized, andSubtitle: Localization.shared.password_changed)
                            }

                        }
                    })
                }
                changePassword()
            } else {
                self.presentError(viewModel: ErrorViewModel(errorText: errors))
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var highlightRangeArray : [NSRange] = []
    var iconDetailView : IconDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        setHighlightData()
        setTextViewDelegate()

    }
    
    func setHighlightData() {
        let highlightData = getHighlightData()
        
        highlightRangeArray = highlightData.wordsToUnderline.compactMap{ let range = highlightData.text.range(of: $0); return NSRange(location: highlightData.text.distance(from: highlightData.text.startIndex, to: range!.lowerBound), length: $0.count) }
        iconDetailView = IconDetailView(icon: #imageLiteral(resourceName: "lock_ic"), text: highlightData.text, margins : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), highlightedRangeArray : highlightRangeArray, highlightColor: UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1), highlightedTextColor: UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1))
        let colorArray : [UIColor] = highlightRangeArray.map{ _ in return iconDetailView!.infoTextView.highlightedTextColor }
        iconDetailView!.infoTextView.colorListArray = colorArray

        mainStack.addArrangedSubview(iconDetailView!)
    }
    
    func setTextViewDelegate() {
        self.textInputCVController.collectionView.reloadData()
        self.textInputCVController.collectionView.layoutIfNeeded()

        for (i, ip) in [IndexPath(item: 0, section: 1)].enumerated() {
            if let cell = textInputCVController.collectionView?.cellForItem(at: ip) as? TextInputCell {
                if i == 0 { cell.inputTextField.addTarget(self, action: #selector(textViewDidChange(textField:)), for: .editingChanged) }
            }
        }
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
        

    
    func check(text: String) -> CharacterCheck {
        let lowerCase = CharacterSet.lowercaseLetters
        let upperCase = CharacterSet.uppercaseLetters
        let numbers = CharacterSet.decimalDigits
        
        let containsNumbers = text.unicodeScalars.contains(where: { numbers.contains($0) })
        let containsLowerCase = text.unicodeScalars.contains(where: { lowerCase.contains($0) })
        let containsUpperCase = text.unicodeScalars.contains(where: { upperCase.contains($0) })
        let containsSpecial = text.unicodeScalars.contains(where: { !lowerCase.contains($0) && !upperCase.contains($0) && !numbers.contains($0) })
        
        return CharacterCheck(hasUpperCase: containsUpperCase, hasLowerCase: containsLowerCase, hasNumber: containsNumbers, hasSpecialCharacter: containsSpecial)
    }
    
    @objc func textViewDidChange(textField : UITextField) {
        
        presentError(viewModel: ErrorViewModel(errorText: nil))
        
        let text = textField.text ?? ""
        var tempRangeArray : [NSRange] = []
        if text.count > 8 { tempRangeArray.append(highlightRangeArray[0]) }
        let data = check(text: text)
        if data.hasLowerCase == true { tempRangeArray.append(highlightRangeArray[2]) }
        if data.hasUpperCase == true { tempRangeArray.append(highlightRangeArray[1]) }
        if data.hasSpecialCharacter == true { tempRangeArray.append(highlightRangeArray[4]) }
        if data.hasNumber == true { tempRangeArray.append(highlightRangeArray[3]) }
        
        iconDetailView?.changeColor(with: UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1), andTextHighlitColor: UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), andRangeArray: highlightRangeArray)
        iconDetailView?.changeColor(with: UIColor(red: 32/255, green: 205/255, blue: 53/255, alpha: 0.1), andTextHighlitColor: UIColor(red: 32/255, green: 205/255, blue: 53/255, alpha: 1), andRangeArray: tempRangeArray)
    }
    
    
    func changePasswordRequest(passData: (oldPassword: String, password1 : String, password2 : String), completion: @escaping ([String]?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.changePassword.url() else { completion(["Uh-Oh! Something went wrong."], false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "old_password": passData.oldPassword,
            "new_password": passData.password2,
            "new_password_repeat": passData.password2
        ]
                
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                UserData.shared.password = passData.password1
                completion(nil, false)
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                completion(nil, true)
            } else {
                var errorList : [String] = []
                if let data = data, let json_object = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                    if let errors = json_object?["errors"] as? [String : Any] {
                        for (k, _) in errors {
                            for (_ ,v) in (errors[k] as? [String : Any] ?? [:]) {
                                if let errorString = v as? String {
                                    errorList.append(errorString)
                                }
                            }
                        }
                    }
                }
                completion(errorList.count == 0 ? [Localization.shared.error_occured] : errorList, false)
            }
        }
    }
}




