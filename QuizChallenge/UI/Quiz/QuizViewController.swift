import UIKit

class QuizViewController: UIViewController {
    var contentView: QuizView
    private(set) var viewModel: QuizViewModel?
    private let modalAlert: ModalAlertProtocol

    init(contentView: QuizView = QuizView(),
         modalAlert: ModalAlertProtocol = ModalAlert()) {
        self.contentView = contentView
        self.modalAlert = modalAlert
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.showLoading()
        viewModel?.viewDidLoad()
        setup()
    }

    private func setup() {
        bindLayoutEvents()
    }

    private func bindLayoutEvents() {
        guard let contentView = view as? QuizView else { return }
        contentView.wantsToActionTimer = { [weak self] in
            self?.viewModel?.startTimer()
        }

        contentView.wantsToInsertWord = { [weak self] text in
            self?.viewModel?.wordMatch(with: text)
        }
    }
}

extension QuizViewController: QuizViewModelDelegate {
    func showAlert(with model: ModalAlertModel) {
        modalAlert.showAlert(
            controller: self,
            model: model, buttonActionHandler: { [weak self] in
                self?.viewModel?.setupTimer()
                self?.viewModel?.setupQuiz()
            }, presentationCompletion: nil)
    }

    func update(with timerModel: TimerModel, and quizModel: QuizModel, wordMatch: Bool) {
        contentView.showView(with: timerModel, and: quizModel, wordMatch: wordMatch)
    }

    func loadingView(isHidden: Bool) {
        isHidden ? contentView.hideLoading() : contentView.showLoading()
    }
}

extension QuizViewController {
    class func make(viewModel: QuizViewModel, contentView: QuizView = QuizView(),
                    modalAlert: ModalAlertProtocol = ModalAlert()) -> QuizViewController {
        let viewController = QuizViewController(contentView: contentView, modalAlert: modalAlert)
        viewModel.delegate = viewController
        viewController.viewModel = viewModel
        return viewController
    }
}
