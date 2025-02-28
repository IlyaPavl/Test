//
//  CustomActivityIndicatorView.swift
//  Test
//
//  Created by Илья Павлов on 28.02.2025.
//

import UIKit

final class CustomActivityIndicatorView: UIView {
    
    private let ringLayer = CAShapeLayer()
    private let animationKey = "rotationAnimation"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ringLayer.frame = bounds
        setupLayer()
    }
}

// MARK: - Private
private extension CustomActivityIndicatorView {
    func setupLayer() {
        let lineWidth: CGFloat = 4
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth
        
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 1.5,
            clockwise: true
        )
        
        ringLayer.path = circularPath.cgPath
        ringLayer.strokeColor = UIColor.systemBlue.cgColor
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.lineWidth = lineWidth
        ringLayer.lineCap = .round
        ringLayer.strokeEnd = 0.75

        layer.addSublayer(ringLayer)
    }
}

// MARK: - Public
extension CustomActivityIndicatorView {
    func startAnimating() {
        guard ringLayer.animation(forKey: animationKey) == nil else { return }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        ringLayer.add(rotationAnimation, forKey: animationKey)
    }
    
    func stopAnimating() {
        ringLayer.removeAnimation(forKey: animationKey)
    }
}
