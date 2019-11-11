import UIKit

class QuizDataSource: NSObject, UITableViewDataSource {
    private let list: [String]

    init(with list: [String]) {
        self.list = list
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: UITableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath)
        cell.textLabel?.text = list[indexPath.row].capitalized
        return cell
    }
}
