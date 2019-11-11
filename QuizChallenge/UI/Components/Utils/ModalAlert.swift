import UIKit

struct ModalAlertModel {
    let title: String
    let subtitle: String?
    let buttonText: String?

    init(title: String, subtitle: String? = nil, buttonText: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
    }
}

protocol ModalAlertProtocol {
    func showAlert(controller: UIViewController?,
                   model: ModalAlertModel,
                   buttonActionHandler: (() -> Void)?,
                   presentationCompletion: (() -> Void)?)
}

final class ModalAlert: ModalAlertProtocol {
    func showAlert(controller: UIViewController?,
                   model: ModalAlertModel,
                   buttonActionHandler: (() -> Void)? = nil,
                   presentationCompletion: (() -> Void)? = nil) {

        let alert = UIAlertController(title: model.title, message: model.subtitle, preferredStyle: .alert)

        let buttonActionTitle = model.buttonText ?? "Ok"
        var buttonAction = UIAlertAction(title: buttonActionTitle, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })

        if let buttonActionHandler = buttonActionHandler {
            buttonAction = UIAlertAction(title: buttonActionTitle, style: .cancel, handler: { _ in
                buttonActionHandler()
            })
        }

        alert.addAction(buttonAction)

        controller?.present(alert, animated: true, completion: presentationCompletion)

    }
}
