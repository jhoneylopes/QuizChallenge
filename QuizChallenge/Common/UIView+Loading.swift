import UIKit

extension UIView {
    func showLoading() {
        viewWithTag(LoadingView.tag)?.removeFromSuperview()
        let loadingView = LoadingView(frame: frame)
        loadingView.activityIndicatorStyle = .large
        addSubview(loadingView)
        loadingView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        loadingView.startAnimating()
    }

    func hideLoading() {
        let loadingView = viewWithTag(LoadingView.tag)
        UIView.animate(withDuration: 0.35, animations: {
            loadingView?.alpha = 0
        }, completion: { _ in
            (loadingView as? LoadingView)?.stopAnimating()
            loadingView?.removeFromSuperview()
        })
    }
}
