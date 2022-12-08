//
//  UIViewController+banner.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

extension UIViewController {
    func showBanner(with error: Error, animated: Bool = true) {
        guard let message = error.localizedDescription.nilIfEmpty else { return }
        let truncatedMessage = message.truncate(length: 250)
        showBanner(with: truncatedMessage, animated: animated)
    }
    func showBanner(with message: String, animated: Bool = true) {
        guard let stackView = stackView else { return }
        let errorView = BannerView(message: message)
        view.layoutIfNeeded()
        if !animated {
            stackView.insertArrangedSubview(errorView, at: 0)
            view.layoutIfNeeded()
            return
        }
        stackView.insertArrangedSubview(errorView, at: 0)
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    func hideBanner(animeted: Bool = true) {
        guard let stackView = stackView else { return }
        guard let errorView = stackView.arrangedSubviews.first(where: { $0 is BannerView }) else { return }
        if !animeted {
            stackView.removeArrangedSubview(errorView)
            errorView.removeFromSuperview()
            return
        }
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseIn) {
            errorView.isHidden = true
        } completion: { (finished) in
            guard finished else { return }
            stackView.removeArrangedSubview(errorView)
            errorView.removeFromSuperview()
        }
    }
    
    // MARK: - Private
    private var stackView: UIStackView? {
        guard let topView = view.subviews.first else { return nil }
        switch topView {
        case let topStackView as UIStackView: return topStackView
        case let topScrollView as UIScrollView:
            if let stackView = topScrollView.subviews.first(where: { $0 is UIStackView }) as? UIStackView {
                return stackView
            }
            return nil
        default:
            return nil
        }
    }
}
