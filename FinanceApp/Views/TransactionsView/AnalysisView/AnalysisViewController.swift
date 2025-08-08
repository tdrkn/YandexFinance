import UIKit

final class AnalysisViewController: UIViewController {
    private let viewModel: AnalysisViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(direction: Direction) {
        self.viewModel = AnalysisViewModel(direction: direction)
        super.init(nibName: nil, bundle: nil)
        title = "Аналитика"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "total")
        tableView.register(AnalysisTransactionCell.self, forCellReuseIdentifier: "tx")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        viewModel.reload { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AnalysisViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return viewModel.transactions.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return makeDateCell(title: "Начало", date: viewModel.startDate, selector: #selector(startChanged(_:)))
            case 1:
                return makeDateCell(title: "Конец", date: viewModel.endDate, selector: #selector(endChanged(_:)))
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "total", for: indexPath)
                cell.textLabel?.text = "Сумма"
                cell.detailTextLabel?.text = rubFormatter.string(for: viewModel.total)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tx", for: indexPath) as! AnalysisTransactionCell
            let tx = viewModel.transactions[indexPath.row]
            let cat = viewModel.category(for: tx)
            cell.configure(transaction: tx, category: cat, share: viewModel.share(for: tx))
            return cell
        }
    }

    private func makeDateCell(title: String, date: Date, selector: Selector) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = title
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.date = date
        picker.addTarget(self, action: selector, for: .valueChanged)
        cell.accessoryView = picker
        cell.selectionStyle = .none
        return cell
    }

    @objc private func startChanged(_ sender: UIDatePicker) {
        viewModel.startDate = sender.date
        if viewModel.startDate > viewModel.endDate {
            viewModel.endDate = viewModel.startDate
        }
        viewModel.reload { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc private func endChanged(_ sender: UIDatePicker) {
        viewModel.endDate = sender.date
        if viewModel.endDate < viewModel.startDate {
            viewModel.startDate = viewModel.endDate
        }
        viewModel.reload { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AnalysisViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 44 : 56
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "ОПЕРАЦИИ" : nil
    }
}

extension AnalysisViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max(), max >= viewModel.transactions.count - 5 else { return }
        viewModel.loadNextPage()
    }
}

private let rubFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    f.currencySymbol = "₽"
    f.maximumFractionDigits = 2
    f.minimumFractionDigits = 0
    f.groupingSeparator = " "
    f.locale = Locale(identifier: "ru_RU")
    return f
}()
