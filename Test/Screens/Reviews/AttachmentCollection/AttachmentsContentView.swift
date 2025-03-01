//
//  AttachmentsContentView.swift
//  Test
//
//  Created by Илья Павлов on 28.02.2025.
//

import UIKit

final class AttachmentsContentView: UIView, UIContentView {
    
    private enum Constants {
        static let imageCornerRadius: CGFloat = 8
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            applyConfiguration()
        }
    }
    
    private let imageView = WebImageView()

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupViews()
        applyConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray5
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyConfiguration() {
        guard let config = configuration as? AttachmentsConfig else { return }
        
        if let url = config.attachmentURL {
            self.imageView.set(imageURL: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
