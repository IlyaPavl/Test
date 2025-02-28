import UIKit

final class ReviewsView: UIView {
    private enum Constants {
        static let footerHeight: CGFloat = 16
        static let footerPadding: CGFloat = 8
    }

    let tableView = UITableView()
    private let footerLabel = UILabel()
    let refreshControl = UIRefreshControl()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: safeAreaInsets)
    }
    
}

// MARK: - Public
extension ReviewsView {
    func updateFooter(with count: Int) {
        footerLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("%lld numberOfReviews", comment: ""),count
        )
        
        if let footerView = tableView.tableFooterView {
            let newHeight = footerLabel.intrinsicContentSize.height + Constants.footerHeight
            footerView.frame.size.height = newHeight
            tableView.tableFooterView = footerView
        }
    }
    
    func prepareFooterForReload() {
        footerLabel.text = nil
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
        tableView.tableFooterView = makeFooterView()
        tableView.refreshControl = refreshControl
    }
    
    func makeFooterView() -> UIView {
        let footerView = UIView()
        
        footerLabel.textAlignment = .center
        footerLabel.font = .reviewCount
        footerLabel.textColor = .reviewCount
        footerLabel.text = ""
        
        footerView.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerLabel
                .topAnchor
                .constraint(equalTo: footerView.topAnchor, constant: Constants.footerPadding),
            footerLabel
                .bottomAnchor
                .constraint(equalTo: footerView.bottomAnchor, constant: -Constants.footerPadding),
            footerLabel
                .centerXAnchor
                .constraint(equalTo: footerView.centerXAnchor)
        ])
        
        footerView.frame.size.height = footerLabel.intrinsicContentSize.height + Constants.footerHeight
        return footerView
    }

}
