import Foundation

protocol QuizViewModelDelegate: AnyObject {
    func update(with timerModel: TimerModel, and quizModel: QuizModel, wordMatch: Bool)
    func showAlert(with model: ModalAlertModel)
    func loadingView(isHidden: Bool)
}

class QuizViewModel {
    weak var delegate: QuizViewModelDelegate?
    private let controller: QuizController
    private(set) var timer: Timer?
    private var timeLeft: Int
    private let seconds: Int
    private(set) var timerModel: TimerModel
    private(set) var quizModel: QuizModel

    init(controller: QuizController,
         timerModel: TimerModel = TimerModel(),
         quizModel: QuizModel = QuizModel(),
         seconds: Int = 300,
         timeLeft: Int? = nil) {
        self.controller = controller
        self.timerModel = timerModel
        self.quizModel = quizModel
        self.seconds = seconds
        self.timeLeft = timeLeft ?? seconds
    }

    func viewDidLoad() {
        setupTimer()
        controller.getQuizQuestionAnswer { [weak self] in
            guard let self = self else { return }
            self.delegate?.loadingView(isHidden: true)
            switch $0 {
            case .success(let value):
                self.quizModel = QuizModel(from: value)
                self.setupQuiz()
            case .failure:
                self.showAlert(with: ModalAlertModel(title: LocalizedStrings.oops,
                                                     subtitle: LocalizedStrings.somethingWentWrong,
                                                     buttonText: LocalizedStrings.ok))
            }
        }
    }

    func setupTimer() {
        timerModel = TimerModel(score: "00/50", timer: timeLeft.timeToString(),
                                timerStatus: .start, isRunning: false)
        delegate?.update(with: timerModel, and: quizModel, wordMatch: false)
    }

    func setupQuiz() {
        quizModel = QuizModel(with: quizModel.question,
                              answeredList: [],
                              proofList: quizModel.proofList)
        delegate?.update(with: timerModel, and: quizModel, wordMatch: false)
    }

    func startTimer() {
        if timer != nil {
            endTimer()
            setupQuiz()
            setupTimer()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                self.timeLeft -= 1
                self.updateTimerModel(timer: self.timeLeft.timeToString(),
                                      isRunning: true)
                self.delegate?.update(with: self.timerModel, and: self.quizModel, wordMatch: false)

                if self.timeLeft <= 0 {
                    self.showTimeIsOverAlert()
                }
            }
        }
    }

    func wordMatch(with text: String) {
        let word = text.lowercased()
        if quizModel.proofList.contains(word) && !quizModel.answeredList.contains(word) {
            updateQuizModel(word: word)
            delegate?.update(with: timerModel, and: quizModel, wordMatch: true)
            if quizModel.answeredList.count == quizModel.proofList.count {
                showCongratulationsAlert()
            }
        }
    }

    private func showTimeIsOverAlert() {
        let subtitle = String(format: LocalizedStrings.sorryTimeIsUp, quizModel.answeredList.count)
        showAlert(with: ModalAlertModel(title: LocalizedStrings.timeFinished,
                                        subtitle: subtitle,
                                        buttonText: LocalizedStrings.tryAgain))
        endTimer()
    }

    private func showCongratulationsAlert() {
        showAlert(with: ModalAlertModel(title: LocalizedStrings.congratulations,
                                        subtitle: LocalizedStrings.goodJobYouFound,
                                        buttonText: LocalizedStrings.playAgain))
        endTimer()
    }

    private func showAlert(with model: ModalAlertModel) {
        delegate?.showAlert(with: model)
    }

    private func endTimer() {
        timer?.invalidate()
        timeLeft = seconds
        timer = nil
    }

    private func updateTimerModel(score: Int? = nil, timer: String? = nil,
                                  isRunning: Bool = false) {
        let model = TimerModel(score: score == nil ? timerModel.score : (score ?? 0).twoPlaces() + "/" + "50",
                              timer: timer ?? timerModel.timer,
                              timerStatus: isRunning ? .reset : .start,
                              isRunning: isRunning)
        timerModel = model
    }

    private func updateQuizModel(word: String) {
        let newAnsweredList = [word] + quizModel.answeredList
        quizModel = QuizModel.init(with: quizModel.question,
                                   answeredList: newAnsweredList,
                                   proofList: quizModel.proofList)
        updateTimerModel(score: newAnsweredList.count, isRunning: true)
    }
}
