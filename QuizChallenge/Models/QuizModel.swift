struct QuizModel: Equatable {
    private(set) var question: String
    private(set) var answeredList: [String]
    private(set) var proofList: [String]

    init(with question: String = String(), answeredList: [String] = [], proofList: [String] = []) {
        self.question = question
        self.answeredList = answeredList
        self.proofList = proofList
    }

    init(from response: QuizResponse) {
        self.question = response.question ?? String()
        self.answeredList = []
        self.proofList = response.answer ?? []
    }
}
