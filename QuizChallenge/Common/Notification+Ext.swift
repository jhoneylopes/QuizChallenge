import UIKit

extension Notification {
    public var keyboardSize: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
}
