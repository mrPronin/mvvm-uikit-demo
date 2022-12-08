//
//  BannerView.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit
import Combine

class BannerView: UIView {
    // MARK: - Init
    required init(message: String) {
        self.message = message
        super.init(frame: .zero)
        setupOnLoad()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI
    let closeImageView = UIImageView().then {
        $0.image = UIImage(named: "error-banner-close-icon")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 21).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 21).isActive = true
    }
    
    let label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.textColor = .warningText
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    let button = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    
    // MARK: - Private
    private let message: String
    var subscriptions = Set<AnyCancellable>()
}

// MARK: - Private
extension BannerView {
    private func setupOnLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .warning

        // label
        label.text = message
        label.add(into: self)
            .leading(24)
            .bottom(12)
            .top(12)
            .done()
        
        // closeImageView
        closeImageView.add(into: self)
            .centerY()
            .trailing(24)
            .done()
        label.cl
            .right(to: closeImageView, constant: 16)
            .done()

        // button
        button.add(into: self)
            .top()
            .bottom()
            .trailing()
            .done()
        label.cl
            .right(to: button)
            .done()
        button.tapPublisher
            .sink { [weak self] _ in
                guard let owner = self else { return }
                guard let stackView = owner.superview as? UIStackView else { return }
                UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseIn) {
                    owner.isHidden = true
                } completion: { (finished) in
                    guard finished else { return }
                    stackView.removeArrangedSubview(owner)
                    owner.removeFromSuperview()
                }
            }
            .store(in: &subscriptions)

    }
}
