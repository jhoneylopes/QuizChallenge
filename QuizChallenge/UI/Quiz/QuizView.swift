import UIKit

class QuizView: UIView, KeyboardControllable {
    var wantsToActionTimer: (() -> Void)?
    var wantsToInsertWord: ((String) -> Void)?

    var notificationCenter: NotificationCenterProtocol = NotificationCenter.default
    var toBottomConstraint: NSLayoutConstraint?
    private var dataSource: UITableViewDataSource? {
        didSet {
            if let dataSource = dataSource {
                tableView.dataSource = dataSource
            }
        }
    }

    private var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .largeTitleFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    private var insertWordField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .quizGrey
        textField.borderStyle = .roundedRect
        textField.textColor = .gray
        textField.placeholder = "Insert Word"
        return textField
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.rowHeight = 44.0
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: UITableViewCell.self))

        return tableView
    }()

    private var timerView: UIView = {
        let view = UIView()
        view.backgroundColor = .quizGrey
        return view
    }()

    private var timerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .buttonFont
        button.backgroundColor = .quizOrange
        button.setTitleColor(UIColor.white.withAlphaComponent(0.35),
                             for: .highlighted)
        button.layer.cornerRadius = 5.0
        return button
    }()

    private var timerScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        return label
    }()

    private var timerTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboardEvents()
    }

    private func setup() {
        backgroundColor = .white
        registerKeyboardEvents()
        buildViewHierarchy()
        addConstraints()
        addActions()
    }

    private func buildViewHierarchy() {
        addSubview(questionTitleLabel)
        addSubview(insertWordField)
        addSubview(tableView)
        addSubview(timerView)
        timerView.addSubview(timerScoreLabel)
        timerView.addSubview(timerTimeLabel)
        timerView.addSubview(timerButton)
    }

    private func addConstraints() {
        questionTitleLabel.anchor(top: topAnchor,
                                  left: leftAnchor,
                                  right: rightAnchor,
                                  topConstant: 44.0,
                                  leftConstant: 16.0,
                                  rightConstant: 16.0,
                                  heightConstant: 84.0)

        insertWordField.anchor(top: questionTitleLabel.bottomAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               topConstant: 16.0,
                               leftConstant: 16.0,
                               rightConstant: 16.0,
                               heightConstant: 34.0)

        tableView.anchor(top: insertWordField.bottomAnchor,
                         left: leftAnchor,
                         bottom: timerView.topAnchor,
                         right: rightAnchor,
                         topConstant: 8.0,
                         bottomConstant: 16.0)

        timerView.anchor(
            left: leftAnchor,
            right: rightAnchor,
            heightConstant: 120.0
        )
        alignKeyboard(with: timerView)

        timerScoreLabel.anchor(left: timerView.leftAnchor,
                               bottom: timerButton.topAnchor,
                               leftConstant: 16.0,
                               bottomConstant: 16.0,
                               widthConstant: 100.0,
                               heightConstant: 34.0)

        timerTimeLabel.anchor(bottom: timerButton.topAnchor,
                               right: timerView.rightAnchor,
                               bottomConstant: 16.0,
                               rightConstant: 16.0,
                               widthConstant: 100.0,
                               heightConstant: 34.0)

        timerButton.anchor(left: timerView.leftAnchor,
                           bottom: timerView.bottomAnchor,
                           right: timerView.rightAnchor,
                           leftConstant: 16.0,
                           bottomConstant: 16.0,
                           rightConstant: 16.0,
                           heightConstant: 34.0)
    }

    private func addActions() {
        timerButton.addTarget(self, action: #selector(timerAction),
                              for: .touchUpInside)
        insertWordField.addTarget(self, action: #selector(editingChanged),
                                  for: .editingChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc
    func timerAction() {
        dismissKeyboard()
        wantsToActionTimer?()
    }

    @objc
    func editingChanged() {
        wantsToInsertWord?(insertWordField.text ?? "")
    }

    @objc
    func dismissKeyboard() {
        self.endEditing(true)
    }
}

// MARK: - Show View
extension QuizView {
    func showView(with timerModel: TimerModel, and quizModel: QuizModel, wordMatch: Bool = false) {

        insertWordField.isHidden = quizModel.question.isEmpty
        insertWordField.isEnabled = timerModel.isRunning
        tableView.isHidden = quizModel.answeredList.isEmpty

        if timerModel.timerStatus == TimerStatus.start || wordMatch {
            insertWordField.text = String()
        }
        questionTitleLabel.text = quizModel.question
        timerScoreLabel.text = timerModel.score
        timerTimeLabel.text = timerModel.timer
        timerButton.setTitle(timerModel.timerStatus.name, for: .normal)

        dataSource = QuizDataSource(with: quizModel.answeredList)
        tableView.reloadData()
    }
}
