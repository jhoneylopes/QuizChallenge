import UIKit

public protocol KeyboardControllable: class {
    var notificationCenter: NotificationCenterProtocol { get set }
    var toBottomConstraint: NSLayoutConstraint? { get set }

    func registerKeyboardEvents()
    func removeKeyboardEvents()
    func alignKeyboard(with view: UIView)
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

extension KeyboardControllable where Self: UIView {
    public func alignKeyboard(with view: UIView) {
        registerKeyboardEvents()
        toBottomConstraint = view.bottomSafeArea(alignedWith: self)
    }

    public func registerKeyboardEvents() {
        _ = notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                           object: nil,
                                           queue: nil) { notification in
                                        self.keyboardWillShow(notification)
        }

        _ = notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                           object: nil,
                                           queue: nil) { notification in
                                        self.keyboardWillHide(notification)
        }
    }

    public func removeKeyboardEvents() {
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = notification.keyboardSize else {
            return
        }

        toBottomConstraint?.constant = -keyboardSize.height
        updateConstraints()
    }

    public func keyboardWillHide(_ notification: Notification) {
        toBottomConstraint?.constant = 0
        updateConstraints()
    }
}
