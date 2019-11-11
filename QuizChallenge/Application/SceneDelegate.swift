import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let coordinator = ApplicationCoordinator(window: makeWindow(with: windowScene)!)
        coordinator.start()
        self.coordinator = coordinator
    }

    func makeWindow(with windowScene: UIWindowScene?) -> UIWindow? {
        let frame = windowScene?.coordinateSpace.bounds ?? UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.windowScene = windowScene        
        return window
    }
}
