import Foundation

public protocol NotificationCenterProtocol {
    func post(name aName: NSNotification.Name, object anObject: Any?)

    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?)
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol

    func removeObserver(_ observer: Any)
    func removeObserver(_ observer: Any,
                        name aName: NSNotification.Name?,
                        object anObject: Any?)
}

extension NotificationCenter: NotificationCenterProtocol {}
