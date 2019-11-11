import UIKit

extension UIFont {
    static func customFontWithDefault(familyName: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: familyName, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {
    static var largeTitleFont: UIFont {
        return customFontWithDefault(familyName: FontFamily.SFProDisplay.bold, size: 34.0)
    }

    static var titleFont: UIFont {
        return customFontWithDefault(familyName: FontFamily.SFProDisplay.bold, size: 27.0)
    }

    static var bodyFont: UIFont {
        return customFontWithDefault(familyName: FontFamily.SFProDisplay.regular, size: 17.0)
    }

    static var buttonFont: UIFont {
        return customFontWithDefault(familyName: FontFamily.SFProDisplay.semiBold, size: 17.0)        
    }
}
