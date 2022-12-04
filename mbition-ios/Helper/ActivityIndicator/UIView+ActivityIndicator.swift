//
//  UIView+ActivityIndicator.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

class ActivityIndicator: UIView {
    // MARK: - Public
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Init
    required init(color: UIColor? = nil, message: String? = nil) {
        self.color = color
        self.message = message
        super.init(frame: .zero)
        setupOnLoad()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Private
    private let message: String?
    private let color: UIColor?
    
    private let activityIndicator = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Private
extension ActivityIndicator {
    private func setupOnLoad() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        // activityIndicator
        activityIndicator.color = color
        activityIndicator.add(into: self)
            .top()
            .centerX()
            .done()
        activityIndicator.startAnimating()

        label.text = message
        label.textColor = color
        label.add(into: self)
            .leading()
            .trailing()
            .bottom()
            .top(to: activityIndicator, constant: 8)
            .done()
    }
}

extension UIView {
    func showActivityIndicator(_ color: UIColor? = nil, message: String? = nil) {
        let activityIndicator = ActivityIndicator(color: color, message: message)
        activityIndicator.add(into: self).done()
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    func hideActivityIndicator() {
        subviews.compactMap {  $0 as? ActivityIndicator }
            .forEach {
                $0.stopAnimating()
                $0.removeFromSuperview()
            }
    }
}
