import Foundation

protocol QuizController {
    func getQuizQuestionAnswer(completion: @escaping (Result<QuizResponse, QuizAPIError>) -> Void)
}

extension ApplicationController: QuizController { }

class ApplicationController {
    private let api: QuizAPI

    init(api: QuizAPI = QuizAPIService()) {
        self.api = api
    }

    func getQuizQuestionAnswer(completion: @escaping (Result<QuizResponse, QuizAPIError>) -> Void) {
        api.getQuizQuestionAnswer {
            switch $0 {
            case .failure(let error):
                self.log(error)
                completion(Result(error: error))
            case .success(let value):
                completion(Result(value: value))
            }
        }
    }

    private func log(_ error: QuizAPIError) {
        NSLog(error.localizedDescription)
    }
}
