import UIKit

extension UIColor {
    public static func colorFrom(_ hex: String) -> UIColor {
        var hexCode: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexCode.hasPrefix("#") {
            hexCode.remove(at: hexCode.startIndex)
        }

        if hexCode.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexCode).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
    static var quizGrey: UIColor {
        return UIColor.colorFrom("F5F5F5")
    }

    static var quizOrange: UIColor {
        return UIColor.colorFrom("FF8300")
    }
}
