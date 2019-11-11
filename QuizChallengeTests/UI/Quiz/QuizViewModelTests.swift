import XCTest
@testable import QuizChallenge

class QuizViewModelTests: XCTestCase {
    var sut: QuizViewModel!
    var mockController: MockApplicationController!

    override func setUp() {
        mockController = MockApplicationController()
        sut = QuizViewModel(controller: mockController,
                            timerModel: TimerModel(),
                            quizModel: QuizModel(),
                            seconds: 15, timeLeft: nil)
    }

    func test_GetQuizQuestionAnswer_WhenGivenSuccessTrue_UpdatesCurrentQuizModel() {
        let expected = QuizModel(from: QuizResponse(question: "Question", answer: ["try", "if"]))
        mockController.completionSuccess = true
        sut.viewDidLoad()

        XCTAssertEqual(sut.quizModel, expected)
    }

    func test_GetQuizQuestionAnswer_WhenGivenSuccessFalse_KeepsCurrentQuizModel() {
        let expected = sut.quizModel
        mockController.completionSuccess = false
        sut.viewDidLoad()

        XCTAssertEqual(sut.quizModel, expected)
    }

    func test_SetupTimer_WhenCalled_SetsTimerModel() {
        let expected = TimerModel(score: "00/50", timer: "00:15",
                                  timerStatus: .start, isRunning: false)
        sut.setupTimer()

        XCTAssertEqual(sut.timerModel, expected)
    }

    func test_SetupTimer_WhenCalled_SetsQuizModel() {
        let expected = QuizModel(with: sut.quizModel.question,
                                 answeredList: [],
                                 proofList: sut.quizModel.proofList)
        sut.setupQuiz()

        XCTAssertEqual(sut.quizModel, expected)
    }

    func test_WordMatch_WhenTextMatch_HasAnsweredListUpdated() {
        let expected = "try"
        mockController.completionSuccess = true
        sut.viewDidLoad()
        sut.wordMatch(with: expected)

        XCTAssertTrue(sut.quizModel.answeredList.contains(expected))
    }

    func test_WordMatch_WhenTextNotMatch_HasNoUpdate() {
        let expected = "protocols"
        mockController.completionSuccess = true
        sut.viewDidLoad()
        sut.wordMatch(with: expected)

        XCTAssertFalse(sut.quizModel.answeredList.contains(expected))
    }

    func test_StartTimer_WhenInit_SetsTimerToNil() {
        XCTAssertNil(sut.timer)
    }

    func test_StartTimer_WhenTimerIsNil_StartsTimer() {
        sut.startTimer()

        XCTAssertNotNil(sut.timer)
    }

    func test_StartTimer_WhenCallItTwice_EndsTimer() {
        sut.startTimer()
        sut.startTimer()

        XCTAssertNil(sut.timer)
    }
}

extension QuizViewModelTests {
    class MockApplicationController: QuizController {
        var completionSuccess: Bool = true

        func getQuizQuestionAnswer(completion: @escaping (Result<QuizResponse, QuizAPIError>) -> Void) {
            if completionSuccess {
                completion(.success(QuizResponse(question: "Question", answer: ["try", "if"])))
            } else {
                completion(.failure(QuizAPIError.noData(URLResponse())))
            }
        }
    }
}
