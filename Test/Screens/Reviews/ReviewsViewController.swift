import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getReviews()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        return reviewsView
    }

    func setupViewModel() {
        reviewsView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        viewModel.onStateChange = { [weak self] _ in
            DispatchQueue.main.async {
                self?.reviewsView.tableView.reloadData()
            }
        }
        
        viewModel.onFooterUpdate = { [weak self] count in
            self?.reviewsView.updateFooter(with: count)
        }
        
        viewModel.onRefresh = { [weak self] in
            DispatchQueue.main.async {
                self?.reviewsView.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.refreshReviews()
    }
}
