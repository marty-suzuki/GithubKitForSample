//
//  UIFont+SwiftIconFont.swift
//  SwiftIconFont
//
//  Created by Sedat Ciftci on 18/03/16.
//  Copyright © 2016 Sedat Gokbek Ciftci. All rights reserved.
//

import UIKit

//func icon(from font: Fonts, code: String, iconColor: UIColor, imageSize: CGSize, ofSize size: CGFloat)

public struct SwiftIcon {
    let font: Fonts
    let code: String
    let color: UIColor
    let imageSize: CGSize
    let fontSize: CGFloat
}

public enum Fonts: String {
    case FontAwesome = "FontAwesome"
    case Iconic = "open-iconic"
    case Ionicon = "Ionicons"
    case Octicon = "octicons"
    case Themify = "themify"
    case MapIcon = "map-icons"
    case MaterialIcon = "MaterialIcons-Regular"
    
    var fontName: String {
        switch self {
        case .FontAwesome:
            return "FontAwesome"
        case .Iconic:
            return "Icons"
        case .Ionicon:
            return "Ionicons"
        case .Octicon:
            return "octicons"
        case .Themify:
            return "Themify"
        case .MapIcon:
            return "map-icons"
        case .MaterialIcon:
            return "Material Icons"
        }
    }
    
}
public extension UIFont{
    
    static func icon(from font: Fonts, ofSize size: CGFloat) -> UIFont {
        let fontName = font.rawValue
        if (UIFont.fontNames(forFamilyName: font.fontName).count == 0)
        {
            /*
            dispatch_once(&token) {
                FontLoader.loadFont(fontName)
            }
            */
            FontLoader.loadFont(fontName)
        }
        return UIFont(name: font.rawValue, size: size)!
    }
    
}

public extension UIImage
{
    public static func icon(from font: Fonts, iconColor: UIColor, code: String, imageSize: CGSize, ofSize size: CGFloat) -> UIImage
    {
        let drawText = String.getIcon(from: font, code: code)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        drawText!.draw(in: CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height), withAttributes: [NSAttributedStringKey.font : UIFont.icon(from: font, ofSize: size), NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.foregroundColor: iconColor])
        
		let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

public extension String {
    
    public static func getIcon(from font: Fonts, code: String) -> String? {
        switch font {
        case .FontAwesome:
            return fontAwesomeIcon(code)
        case .Iconic:
            return fontIconicIcon(code)
        case .Ionicon:
            return fontIonIcon(code)
        case .MapIcon:
            return fontMapIcon(code)
        case .MaterialIcon:
            return fontMaterialIcon(code)
        case .Octicon:
            return fontOcticon(code)
        case .Themify:
            return fontThemifyIcon(code)
        }
    }
    
    public static func fontAwesomeIcon(_ code: String) -> String? {
        if let icon = fontAwesomeIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontOcticon(_ code: String) -> String? {
        if let icon = octiconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontIonIcon(_ code: String) -> String? {
        if let icon = ioniconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontIconicIcon(_ code: String) -> String? {
        if let icon = iconicIconArr[code] {
            return icon
        }
        return nil
    }
    
    
    public static func fontThemifyIcon(_ code: String) -> String? {
        if let icon = temifyIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontMapIcon(_ code: String) -> String? {
        if let icon = mapIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontMaterialIcon(_ code: String) -> String? {
        if let icon = materialIconArr[code] {
            return icon
        }
        return nil
    }
}

func replace(withText string: NSString) -> NSString {
    if string.lowercased.range(of: "-") != nil {
        return string.replacingOccurrences(of: "-", with: "_") as NSString
    }
    return string
}



func getAttributedString(_ text: NSString, ofSize size: CGFloat) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: text as String)
    
    for substring in ((text as String).characters.split{$0 == " "}.map(String.init)) {  
        var splitArr = ["", ""]
        splitArr = substring.characters.split{$0 == ":"}.map(String.init)
        if splitArr.count < 2 {
            continue
        }
        
        
        let substringRange = text.range(of: substring)
        
        let fontPrefix: String  = splitArr[0].lowercased()
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString).replacingOccurrences(of: "_", with: "-")
        }
        
        var fontType: Fonts = Fonts.FontAwesome
        var fontArr: [String: String] = ["": ""]
        
        if fontPrefix == "fa" {
            fontType = Fonts.FontAwesome
            fontArr = fontAwesomeIconArr
        } else if fontPrefix == "ic" {
            fontType = Fonts.Iconic
            fontArr = iconicIconArr
        } else if fontPrefix == "io" {
            fontType = Fonts.Ionicon
            fontArr = ioniconArr
        } else if fontPrefix == "oc" {
            fontType = Fonts.Octicon
            fontArr = octiconArr
        } else if fontPrefix == "ti" {
            fontType = Fonts.Themify
            fontArr = temifyIconArr
        } else if fontPrefix == "mi" {
            fontType = Fonts.MapIcon
            fontArr = mapIconArr
        } else if fontPrefix == "ma" {
            fontType = Fonts.MaterialIcon
            fontArr = materialIconArr
        }
        
        if let _ = fontArr[fontCode] {
            attributedString.replaceCharacters(in: substringRange, with: String.getIcon(from: fontType, code: fontCode)!)
            let newRange = NSRange(location: substringRange.location, length: 1)
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.icon(from: fontType, ofSize: size), range: newRange)
        }
    }
    
    return attributedString
}


func getAttributedStringForRuntimeReplace(_ text: NSString, ofSize size: CGFloat) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: text as String)
    
    do {
        let input = text as String
        let regex = try NSRegularExpression(pattern: "icon:\\((\\w+):(\\w+)\\)", options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        if let match = matches.first {
            var fontPrefix = ""
            var fontCode = ""
            let iconLibraryNameRange = match.range(at: 1)
            let iconNameRange = match.range(at: 2)
            
            if let swiftRange = iconLibraryNameRange.range(for: text as String) {
                fontPrefix = String(input[swiftRange])
            }
            
            
            if let swiftRange = iconNameRange.range(for: text as String) {
                fontCode = String(input[swiftRange])
            }
            
            if fontPrefix.utf16.count > 0 && fontCode.utf16.count > 0 {
                
                var fontType: Fonts = Fonts.FontAwesome
                var fontArr: [String: String] = ["": ""]
                
                if fontPrefix == "fa" {
                    fontType = Fonts.FontAwesome
                    fontArr = fontAwesomeIconArr
                } else if fontPrefix == "ic" {
                    fontType = Fonts.Iconic
                    fontArr = iconicIconArr
                } else if fontPrefix == "io" {
                    fontType = Fonts.Ionicon
                    fontArr = ioniconArr
                } else if fontPrefix == "oc" {
                    fontType = Fonts.Octicon
                    fontArr = octiconArr
                } else if fontPrefix == "ti" {
                    fontType = Fonts.Themify
                    fontArr = temifyIconArr
                } else if fontPrefix == "mi" {
                    fontType = Fonts.MapIcon
                    fontArr = mapIconArr
                } else if fontPrefix == "ma" {
                    fontType = Fonts.MaterialIcon
                    fontArr = materialIconArr
                }
                
                
                if let _ = fontArr[fontCode] {
                    attributedString.replaceCharacters(in: match.range, with: String.getIcon(from: fontType, code: fontCode)!)
                    let newRange = NSRange(location: match.range.location, length: 1)
                    attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.icon(from: fontType, ofSize: size), range: newRange)
                }
                
            }
        }
        
    } catch {
        // regex was bad!
    }
    
    return attributedString
}

func GetIconIndexWithSelectedIcon(_ icon: String) -> String {
    let text = icon as NSString
    var iconIndex: String = ""
 
    for substring in ((text as String).characters.split{$0 == " "}.map(String.init)) {
        var splitArr = ["", ""]
        splitArr = substring.characters.split{$0 == ":"}.map(String.init)
        if splitArr.count == 1{
            continue
        }
        
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString!).replacingOccurrences(of: "_", with: "-")
        }
        iconIndex = fontCode
    }
    
    return iconIndex
}

func GetFontTypeWithSelectedIcon(_ icon: String) -> Fonts {
    let text = icon as NSString
    var fontType: Fonts = Fonts.FontAwesome
    
    for substring in ((text as String).characters.split{$0 == " "}.map(String.init)) {
        var splitArr = ["", ""]
        splitArr = substring.characters.split{$0 == ":"}.map(String.init)
        
        if splitArr.count == 1{
            continue
        }
        
        let fontPrefix: String  = splitArr[0].lowercased()
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString).replacingOccurrences(of: "_", with: "-")
        }
        
        
        if fontPrefix == "fa" {
            fontType = Fonts.FontAwesome
        } else if fontPrefix == "ic" {
            fontType = Fonts.Iconic
        } else if fontPrefix == "io" {
            fontType = Fonts.Ionicon
        } else if fontPrefix == "oc" {
            fontType = Fonts.Octicon
        } else if fontPrefix == "ti" {
            fontType = Fonts.Themify
        } else if fontPrefix == "mi" {
            fontType = Fonts.MapIcon
        } else if fontPrefix == "ma" {
            fontType = Fonts.MaterialIcon
        }
    }
    
    
    return fontType
}

// Extensions


public extension UILabel {
    func parseIcon() {
        let text = SwiftIconFont.replace(withText: (self.text! as NSString))
        self.attributedText = getAttributedString(text, ofSize: self.font!.pointSize)
    }
}

public extension UITextView {
    func parseIcon() {
        //let text = replace(withText: (self.text! as NSString))
        let text = SwiftIconFont.replace(withText: "")
        self.attributedText = getAttributedString(text, ofSize: self.font!.pointSize)
    }
}


public extension UITextField {
    
    func parseIcon() {
        let text = SwiftIconFont.replace(withText: (self.text! as NSString))
        self.attributedText = getAttributedString(text, ofSize: self.font!.pointSize)
    }
    
    func parseIconForRuntime() {
        let text = SwiftIconFont.replace(withText: (self.text! as NSString))
        self.attributedText = getAttributedStringForRuntimeReplace(text, ofSize: self.font!.pointSize)
    }
    
}

public extension UIButton {
    func parseIcon() {
        guard let currentTitle = self.titleLabel?.text as NSString? else { return }
        let text = replace(withText: currentTitle)
        let attrTitle = getAttributedString(text, ofSize: (self.titleLabel?.font!.pointSize)!)
        let all = NSRange(location: 0, length: attrTitle.length)
        attrTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: self.currentTitleColor, range: all)
        self.setAttributedTitle(attrTitle, for: UIControlState())
    }
}


public extension UIBarButtonItem {
    func icon(from font: Fonts, code: String, ofSize size: CGFloat){
        var textAttributes: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey.font: UIFont.icon(from: font, ofSize: size)]
        let currentTextAttributes: [String: AnyObject]? = self.titleTextAttributes(for: UIControlState()) as [String : AnyObject]?
        
        if currentTextAttributes != nil {
            for (rawKey, value) in currentTextAttributes! {
                let key = NSAttributedStringKey.init(rawKey)
                if key != NSAttributedStringKey.font {
                    textAttributes[key] = value
                }
            }
        }
        self.setTitleTextAttributes(textAttributes, for: UIControlState.normal)
        self.setTitleTextAttributes(textAttributes, for: UIControlState.highlighted)

        self.title = String.getIcon(from: font, code: code)
    }
}

public extension UITabBarItem {
    
    func iconWithSwiftIcon(defaultIcon: SwiftIcon) {
        self.image = UIImage.icon(from: defaultIcon.font, iconColor: defaultIcon.color, code: defaultIcon.code, imageSize: defaultIcon.imageSize, ofSize: defaultIcon.fontSize)
    }
    
    func icon(from font: Fonts, code: String, iconColor: UIColor, imageSize: CGSize, ofSize size: CGFloat) {
        self.image = UIImage.icon(from: font, iconColor: iconColor, code: code, imageSize: imageSize, ofSize: size)
    }
    
    func iconWithSelectedIcon(from defaultIcon: SwiftIcon, selectedIcon: SwiftIcon) {
        self.image = UIImage.icon(from: defaultIcon.font, iconColor: defaultIcon.color, code: defaultIcon.code, imageSize: defaultIcon.imageSize, ofSize: defaultIcon.fontSize)
        self.selectedImage = UIImage.icon(from: selectedIcon.font, iconColor: selectedIcon.color, code: selectedIcon.code, imageSize: selectedIcon.imageSize, ofSize: selectedIcon.fontSize)
    }
}

extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}
