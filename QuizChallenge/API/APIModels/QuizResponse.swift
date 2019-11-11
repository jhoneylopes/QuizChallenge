struct QuizResponse: Decodable, Equatable {
    var question: String?
    var answer: [String]?
}
