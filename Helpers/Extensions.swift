//
//  Extensions.swift
//  Xpert
//
//  Created by Darius on 18/06/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addConstraintsWithFormat(format: String, viewsArray: [UIView]) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in viewsArray.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



extension UIViewController {
    
    var currentUserObject : UserData { return (UIApplication.shared.delegate as! AppDelegate).userData }

    
    func getTopSafeAreaHeight() -> CGFloat {
        //if (@available(iOS 11.0, *)) {
        let window = UIApplication.shared.windows.first
        return window!.safeAreaInsets.top
        //UIWindow *currentwindow = UIApplication.sharedApplication.windows.firstObject;
        //return currentwindow.safeAreaLayoutGuide.owningView.frame.size.height - currentwindow.safeAreaLayoutGuide.layoutFrame.size.height - currentwindow.safeAreaLayoutGuide.layoutFrame.origin.y;
        // } else {
        //     return 0
        // }
    }
    
    func getBottomSafeAreaHeight() -> CGFloat {
        //if (@available(iOS 11.0, *)) {
        let window = UIApplication.shared.windows.first
        return window!.safeAreaInsets.bottom
        //UIWindow *currentwindow = UIApplication.sharedApplication.windows.firstObject;
        //return currentwindow.safeAreaLayoutGuide.owningView.frame.size.height - currentwindow.safeAreaLayoutGuide.layoutFrame.size.height - currentwindow.safeAreaLayoutGuide.layoutFrame.origin.y;
        // } else {
        //     return 0
        // }
    }
    
    func showSuccessPopup(title: String, subtitle : String, selector : Selector?) {
        let imageName = #imageLiteral(resourceName: "email_ill_light")
        let popup = CenterPopupViewController(icon: imageName, title: title, subtitle: subtitle)
        popup.modalPresentationStyle = .custom
        popup.transitioningDelegate = popup.animator
        if let selector = selector {
            popup.closeButton.addTarget(self, action: selector, for: .touchUpInside)
        }
        self.present(popup, animated: true, completion: nil)
    }
    
    func showFailPopup(title: String, subtitle : String, selector : Selector) {
         let imageName = #imageLiteral(resourceName: "trial_ended_logo")
         let popup = CenterPopupViewController(icon: imageName, title: title, subtitle: subtitle)
         popup.modalPresentationStyle = .custom
         popup.transitioningDelegate = popup.animator
         popup.closeButton.addTarget(self, action: selector, for: .touchUpInside)
         self.present(popup, animated: true, completion: nil)
     }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scaledToFitWidth(_ i : Int, max x: Int) -> Int {
  
        let x1 : CGFloat = 414 // 414
        let y1 : CGFloat = CGFloat(i)
        let x2 : CGFloat = 800 //1024
        let y2 : CGFloat = CGFloat(x)
        
       // let c : CGFloat = (y1 - ((y2 - y1) / (x2 - x1)) * UIScreen.main.bounds.size.width)
        let y : CGFloat = ((y2 - y1) / (x2 - x1)) * ( view.calculatedNewScreenWidth /*UIScreen.main.bounds.size.width*/ - x1) + y1
        
       // print("((", y2," - ",y1,") / (",x2, " - ", x1, ") * (",UIScreen.main.bounds.size.width, " - ",x1," ) + ",y2)
     //   print("ans :", i, y, x)
        
//        let calc = Int((view.calculatedNewScreenWidth / 414)) * i
//        calc = min(calc, x)
//        calc = max(calc, y)
//
        if y > CGFloat(x) { return x }
        if y < CGFloat(i) { return i }
        return Int(y)

        //return min(i * Int((UIScreen.main.bounds.size.width / 414)), y) //Int(UIScreen.main.bounds.size.width / 50) + i
    }
}





extension UIView {
    var isSmallScreenSize : Bool { return UIScreen.main.bounds.size.width < 700 }
    var calculatedNewScreenWidth : CGFloat { return UIScreen.main.bounds.size.width < 700 ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.width * 0.7 }
    var isHugeScreenSize : Bool { return UIScreen.main.bounds.size.width > 1000 }
    
    func getCorrectSize(_ iphone: CGFloat, _ ipad: CGFloat, _ ipadHuge: CGFloat) -> CGFloat {
        switch UIScreen.main.bounds.size.width {
        case 0...414:
            return iphone
        case 414...768:
            return ipad
        default:
            return ipadHuge
        }
    }
}


extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        
        let animation2 = CATransition()
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation2.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        
        let group = CAAnimationGroup()
        group.animations = [animation, animation2]
        group.duration = duration
        
        layer.add(animation2, forKey: convertFromCATransitionType(CATransitionType.push))
        //layer.add(animation, forKey: kCATransitionPush)
    }
}

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}



extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}


extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func check() -> CharacterCheck {
        let lowerCase = CharacterSet.lowercaseLetters
        let upperCase = CharacterSet.uppercaseLetters
        let numbers = CharacterSet.decimalDigits
        
        let containsNumbers = self.unicodeScalars.contains(where: { numbers.contains($0) })
        let containsLowerCase = self.unicodeScalars.contains(where: { lowerCase.contains($0) })
        let containsUpperCase = self.unicodeScalars.contains(where: { upperCase.contains($0) })
        let containsSpecial = self.unicodeScalars.contains(where: { !lowerCase.contains($0) && !upperCase.contains($0) && !numbers.contains($0) })
        
        return CharacterCheck(hasUpperCase: containsUpperCase, hasLowerCase: containsLowerCase, hasNumber: containsNumbers, hasSpecialCharacter: containsSpecial)
    }
}



extension UILabel {
    
        
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)
        let lines = Int(textSize.height/charSize)
        return lines
    }
    
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0, completion: @escaping (()->())) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
            queue.asyncAfter(deadline: .now() + Double(typedText.count) * 0.05) {
                completion()
            }
        }
    }
    
    func animateLastBlinkingDash(delay : TimeInterval) {
        var hasDash = false
        func addOrRemoveDash() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                if hasDash == false {
                    self.text?.append("_")
                    hasDash = true
                } else {
                    self.text?.removeLast()
                    hasDash = false
                }
                addOrRemoveDash()
            })
        }
        
        addOrRemoveDash()
    }
}


public extension UIDevice {
    
    static let hardwareModel: String = {
        var path = [CTL_HW, HW_MACHINE]
        var n = 0
        sysctl(&path, 2, nil, &n, nil, 0)
        var a: [UInt8] = .init(repeating: 0, count: n)
        sysctl(&path, 2, &a, &n, nil, 0)
        return .init(cString: a)
    }()
    
    static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
    
    static let deviceUniqueID : String = {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }()


    /// pares the deveice name as the standard name
    var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }

}



























// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}


import CommonCrypto

extension String {
    public var sha512: String {
        let data = self.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
}






extension UIScrollView {

    func applyZoomToImageView() {
        guard let imageView = delegate?.viewForZooming?(in: self) as? UIImageView else { return }
        guard let image = imageView.image else { return }
        guard imageView.frame.size.valid && image.size.valid else { return }
        let size = image.size ~> imageView.frame.size
        imageView.frame.size = size
        self.contentInset = UIEdgeInsets(
            x: self.frame.size.width ~> size.width,
            y: self.frame.size.height ~> size.height
        )
        imageView.center = self.contentCenter
        if self.contentSize.width < self.visibleSize.width {
            imageView.center.x = self.visibleSize.center.x
        }
        if self.contentSize.height < self.visibleSize.height {
            imageView.center.y = self.visibleSize.center.y
        }
    }

    private var contentCenter: CGPoint {
        return CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
    }

    private var visibleSize: CGSize {
        let size: CGSize = bounds.standardized.size
        return CGSize(
            width:  size.width - contentInset.left - contentInset.right,
            height: size.height - contentInset.top - contentInset.bottom
        )
    }
}

fileprivate extension CGFloat {

    static func ~>(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
        return lhs > rhs ? (lhs - rhs) / 2 : 0.0
    }
}

fileprivate extension UIEdgeInsets {

    init(x: CGFloat, y: CGFloat) {
        self.init()
        self.bottom = y
        self.left = x
        self.right = x
        self.top = y
    }
}

fileprivate extension CGSize {

    var valid: Bool {
        return width > 0 && height > 0
    }

    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }

    static func ~>(lhs: CGSize, rhs: CGSize) -> CGSize {
        switch lhs > rhs {
        case true:
            return CGSize(width: rhs.width, height: rhs.width / lhs.width * lhs.height)
        default:
            return CGSize(width: rhs.height / lhs.height * lhs.width, height: rhs.height)
        }
    }

    static func >(lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width / lhs.height > rhs.width / rhs.height
    }
}
