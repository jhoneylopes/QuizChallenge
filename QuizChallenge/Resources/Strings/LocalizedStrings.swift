import Foundation

struct LocalizedStrings {
    static func stringWithTable(_ tableName: String, forKey key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: nil, table: tableName)
    }
}

// Time finished
extension LocalizedStrings {
    static let timeFinished = NSLocalizedString("timeFinished", comment: "")
    static let sorryTimeIsUp = NSLocalizedString("sorryTimeIsUp", comment: "")
    static let tryAgain = NSLocalizedString("tryAgain", comment: "")
}

// Time finished
extension LocalizedStrings {
    static let congratulations = NSLocalizedString("congratulations", comment: "")
    static let goodJobYouFound = NSLocalizedString("goodJobYouFound", comment: "")
    static let playAgain = NSLocalizedString("playAgain", comment: "")
}

// Error
extension LocalizedStrings {
    static let oops = NSLocalizedString("oops", comment: "")
    static let somethingWentWrong = NSLocalizedString("somethingWentWrong", comment: "")
    static let ok = NSLocalizedString("ok", comment: "")
}
