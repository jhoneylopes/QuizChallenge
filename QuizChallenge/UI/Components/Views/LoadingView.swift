import UIKit

final class LoadingView: UIView {
    static let tag = 9999
    
    private lazy var blurView: UIView = {
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        view.alpha = 0.35
        return view
    }()

    private lazy var centerView: UIView = {
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        view.layer.cornerRadius = 10.0
        view.alpha = 0.85
        return view
    }()

    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyFont
        label.textColor = .white
        label.text = "Loading..."
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        return view
    }()

    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        set { activityIndicator.style = newValue }
        get { return activityIndicator.style }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        tag = LoadingView.tag
        addSubviews()
    }

    private func addSubviews() {
        constrainBlurView()
        constrainCenterView()
        constrainActivityIndicator()
    }

    private func constrainBlurView() {
        addSubview(blurView)
        blurView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }

    private func constrainCenterView() {
        addSubview(centerView)
        centerView.anchorCenterSuperview()
        centerView.heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.35
        ).isActive = true
        centerView.widthAnchor.constraint(
            equalTo: centerView.heightAnchor,
            constant: 1.0
        ).isActive = true

        centerView.addSubview(loadingLabel)
        loadingLabel.anchor(left: centerView.leftAnchor,
                            bottom: centerView.bottomAnchor,
                            right: centerView.rightAnchor,
                            bottomConstant: 16.0,
                            heightConstant: 24.0)
    }

    private func constrainActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        activityIndicator.heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.2
        ).isActive = true
        activityIndicator.widthAnchor.constraint(
            equalTo: activityIndicator.heightAnchor,
            constant: 1.0
        ).isActive = true
    }

    public func startAnimating() {
        activityIndicator.startAnimating()
    }

    public func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
