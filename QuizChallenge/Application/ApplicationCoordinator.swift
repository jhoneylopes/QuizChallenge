import UIKit

class ApplicationCoordinator {
    private let window: UIWindow
    private lazy var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    private let controller: ApplicationController

    init(window: UIWindow) {
        self.window = window
        controller = ApplicationController()        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func start() {
        setRootViewController()
    }

    func setRootViewController() {
        let viewController = resolveQuizViewController()
        window.rootViewController = viewController
    }

    func resolveQuizViewController() -> QuizViewController {
        if let viewController: QuizViewController = existingViewController() {
            return viewController
        }
        let viewModel = QuizViewModel(controller: controller)
        let viewController = QuizViewController.make(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        return viewController
    }

    func existingViewController<T: UIViewController>() -> T? {
        for item in navigationController.viewControllers {
            if let viewController = item as? T {
                return viewController
            }
        }
        return nil
    }
}
