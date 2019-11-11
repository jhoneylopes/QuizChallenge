enum TimerStatus: String {
    case start
    case reset

    public var name: String {
        return rawValue.capitalized
    }
}

struct TimerModel: Equatable {
    private(set) var score: String
    private(set) var timer: String
    private(set) var timerStatus: TimerStatus
    private(set) var isRunning: Bool

    init(score: String = String(), timer: String = String(),
         timerStatus: TimerStatus = .start, isRunning: Bool = false) {
        self.score = score
        self.timer = timer
        self.timerStatus = timerStatus
        self.isRunning = isRunning
    }
}
