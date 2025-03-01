import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void
    /// Имя пользователя.
    let username: NSAttributedString
    /// Аватар пользователя.
    let avatar: UIImage
    /// Изображение рейтинга.
    let ratingImage: UIImage
    /// Коллекция изображений, прикрепленных к отзывам
    let attachedImagesURLs: [String]?

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.avatarView.image = avatar
        cell.usernameLabel.attributedText = username
        cell.ratingImageView.image = ratingImage
        if let attachedImagesURLs = attachedImagesURLs {
            cell.attachmentsView.update(with: attachedImagesURLs)
        }
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let avatarView = UIImageView()
    fileprivate let usernameLabel = UILabel()
    fileprivate let ratingImageView = UIImageView()
    fileprivate let attachmentsView = AttachmentsView()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        avatarView.frame = layout.avatarViewFrame
        usernameLabel.frame = layout.usernameLabelFrame
        ratingImageView.frame = layout.ratingImageViewFrame
        attachmentsView.frame = layout.attachmentsFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.attributedText = nil
        ratingImageView.image = nil
        attachmentsView.update(with: [])
        reviewTextLabel.text = nil
        createdLabel.attributedText = nil
    }
}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupAvatarView()
        setupUsernameLabel()
        setupRatingImageView()
        setupAttachedImagesCollection()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setupAvatarView() {
        contentView.addSubview(avatarView)
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
        avatarView.layer.masksToBounds = true
    }
    
    func setupUsernameLabel() {
        contentView.addSubview(usernameLabel)
        usernameLabel.font = .username
        
    }

    func setupRatingImageView() {
        contentView.addSubview(ratingImageView)
    }
    
    func setupAttachedImagesCollection() {
        contentView.addSubview(attachmentsView)
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }

    @objc func didTapShowMore() {
        guard let config = config else { return }
        config.onTapShowMore(config.id)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы
    private(set) var avatarViewFrame = CGRect.zero
    private(set) var usernameLabelFrame = CGRect.zero
    private(set) var ratingImageViewFrame = CGRect.zero
    private(set) var attachmentsFrame = CGRect.zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right

        var maxY = insets.top
        var showShowMoreButton = false
        
        // Расположение аватара
        avatarViewFrame = CGRect(
            origin: CGPoint(x: insets.left, y: maxY),
            size: Self.avatarSize
        )
        let newXCoordinate = avatarViewFrame.maxX + avatarToUsernameSpacing

        // Расположение имени и фамилии
        let usernameHeight = config.username.boundingRect(width: width).size.height
        usernameLabelFrame = CGRect(
            origin: CGPoint(x: newXCoordinate, y: maxY),
            size: CGSize(width: width - newXCoordinate, height: usernameHeight)
        )
        
        // Расположение рейтинга
        let ratingY = usernameLabelFrame.maxY + usernameToRatingSpacing
        ratingImageViewFrame = CGRect(
            origin: CGPoint(x: newXCoordinate, y: ratingY),
            size: config.ratingImage.size
        )
        
        maxY = ratingImageViewFrame.maxY + ratingToTextSpacing
        
        // Расположение вложений
        if let attachmentURLs = config.attachedImagesURLs {
            if !attachmentURLs.isEmpty {
                attachmentsFrame = CGRect(
                    x: newXCoordinate,
                    y: maxY,
                    width: width - newXCoordinate,
                    height: Self.photoSize.height
                )
                maxY = attachmentsFrame.maxY + photosToTextSpacing
            }
        } else {
            attachmentsFrame = .zero
        }

        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: newXCoordinate, y: maxY),
                size: config.reviewText.boundingRect(
                    width: width - newXCoordinate,
                    height: currentTextHeight
                ).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: newXCoordinate, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        createdLabelFrame = CGRect(
            origin: CGPoint(x: newXCoordinate, y: maxY),
            size: config.created.boundingRect(width: width).size
        )

        return createdLabelFrame.maxY + insets.bottom
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
