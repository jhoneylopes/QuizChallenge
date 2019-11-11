import XCTest
@testable import QuizChallenge

class QuizViewControllerTests: XCTestCase {
    var sut: QuizViewController!

    override func setUp() {
        sut = QuizViewController.make(viewModel: QuizViewModel(controller: ApplicationController()))
    }

    func test_LoadingView_WhenIsHiddenTrue_ItHasNoInstance() {
        sut.loadingView(isHidden: true)

        XCTAssertNil(sut.contentView.viewWithTag(LoadingView.tag) as? LoadingView)
    }

    func test_LoadingView_WhenIsHiddenFalse_ItHasAnInstance() {
        sut.loadingView(isHidden: false)

        XCTAssertNotNil(sut.contentView.viewWithTag(LoadingView.tag) as? LoadingView)
    }
}
