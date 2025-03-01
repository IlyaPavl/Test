import UIKit

final class RootView: UIView {

    private let reviewsButton = UIButton(type: .system)
    private let onTapReviews: () -> Void

    init(onTapReviews: @escaping () -> Void) {
        self.onTapReviews = onTapReviews
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension RootView {

    func setupView() {
        backgroundColor = .systemBackground
        setupReviewsButton()
    }

    func setupReviewsButton() {
        var config = UIButton.Configuration.plain()
        config.title = "Отзывы"
        config.image = UIImage(systemName: "chevron.left")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        reviewsButton.configuration = config
        
        reviewsButton.addAction(UIAction { [unowned self] _ in onTapReviews() }, for: .touchUpInside)
        reviewsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        reviewsButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reviewsButton)
        NSLayoutConstraint.activate([
            reviewsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reviewsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

}
