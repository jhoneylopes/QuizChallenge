import Foundation

protocol QuizAPI {
    func getQuizQuestionAnswer(completion: @escaping (Result<QuizResponse, QuizAPIError>) -> Void)
}

private let defaultBaseURL: URL = URL(string: "https://codechallenge.arctouch.com")!

class QuizAPIService: QuizAPI {
    let networking: Networking
    let baseURL: URL

    init(networking: Networking = URLSession.shared, baseURL: URL = defaultBaseURL) {
        self.networking = networking
        self.baseURL = baseURL
    }

    func getQuizQuestionAnswer(completion: @escaping (Result<QuizResponse, QuizAPIError>) -> Void) {
        let request = makeRequest(path: "/quiz/1", httpMethod: HTTPMethod.get.name)
        perform(request: request, completion: completion)
    }

    private func perform<T: Decodable>(request: URLRequest,
                                       completion: @escaping (Result<T, QuizAPIError>) -> Void) {
        func callback(_ result: Result<T, QuizAPIError>) {
            DispatchQueue.main.sync { completion(result) }
        }

        networking.perform(with: request) { (data, response, error) in
            if let error = error {
                let apiError = QuizAPIError.network(error)
                let result: Result<T, QuizAPIError> = .failure(apiError)
                callback(result)
                return
            }
            guard let data = data else {
                let apiError = QuizAPIError.noData(response)
                let result: Result<T, QuizAPIError> = .failure(apiError)
                callback(result)
                return
            }

            let validStatusCodes = 200..<300

            guard let httpResponse = response as? HTTPURLResponse,
                validStatusCodes.contains(httpResponse.statusCode) else {
                    let apiError = QuizAPIError.server(response)
                    let result: Result<T, QuizAPIError> = .failure(apiError)
                    callback(result)
                    return
            }

            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: data)
                let result: Result<T, QuizAPIError> = .success(value)
                callback(result)
            } catch {
                let apiError = QuizAPIError.decoding(error)
                let result: Result<T, QuizAPIError> = .failure(apiError)
                callback(result)
            }
        }
    }

    private func makeRequest(path: String, httpMethod: String) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = path

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
