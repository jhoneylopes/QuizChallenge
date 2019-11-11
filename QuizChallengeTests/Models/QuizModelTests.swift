import XCTest
@testable import QuizChallenge

class QuizModelTests: XCTestCase {
    var sut: QuizModel!

    override func setUp() {
        sut = QuizModel()
    }

    func test_Init_Default() {
        XCTAssertNotNil(sut)
    }

    func test_Init_WhenGivenAnsweredList_SetsAnsweredList() {
        let expected = ["Else"]
        sut = QuizModel(with: "", answeredList: expected, proofList: [])
        XCTAssertEqual(sut.answeredList, expected)
    }

    func test_Init_WhenGivenQuizResponse_SetsQuestion() {
        let expected = "Question"
        sut = QuizModel(from: QuizResponse(question: expected, answer: []))
        XCTAssertEqual(sut.question, expected)
    }

    func test_Init_WhenGivenQuizResponse_SetsProofList() {
        let expected = ["Try", "If"]
        sut = QuizModel(from: QuizResponse(question: "", answer: expected))
        XCTAssertEqual(sut.proofList, expected)
    }
}
