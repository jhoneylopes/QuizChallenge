import XCTest
@testable import QuizChallenge

class timerModelTests: XCTestCase {
    var sut: TimerModel!

    override func setUp() {
        sut = TimerModel()
    }

    func test_Init_Default() {
        XCTAssertNotNil(sut)
    }

    func test_Init_WhenGivenScore_SetsScore() {
        let expected = "50/50"
        sut = TimerModel(score: expected, timer: "", timerStatus: .start, isRunning: false)
        XCTAssertEqual(sut.score, expected)
    }

    func test_Init_WhenGivenTimer_SetsTimer() {
        let expected = "00:44"
        sut = TimerModel(score: "", timer: expected, timerStatus: .start, isRunning: false)
        XCTAssertEqual(sut.timer, expected)
    }

    func test_Init_WhenGivenTimerStatus_SetsTimerStatus() {
        let expected = TimerStatus.reset
        sut = TimerModel(score: "", timer: "", timerStatus: expected, isRunning: false)
        XCTAssertEqual(sut.timerStatus, expected)
    }

    func test_Init_WhenGivenIsRunning_SetsIsRunning() {
        let expected = true
        sut = TimerModel(score: "", timer: "", timerStatus: .start, isRunning: expected)
        XCTAssertEqual(sut.isRunning, expected)
    }
}
