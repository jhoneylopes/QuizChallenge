import UIKit

extension Int {
    func twoPlaces() -> String {
        if self < 10 { return String(format: "0%i", self) }
        return String(describing: "\(self)")
    }

    func timeToString() -> String {
        let minutes: String = ((self % 3600) / 60).twoPlaces()
        let seconds: String = ((self % 3600) % 60).twoPlaces()
        return minutes + ":" + seconds
    }
}
