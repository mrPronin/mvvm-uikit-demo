//
//  UIViewController+banner.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

extension UIViewController {
    func showBanner(with message: String, animated: Bool = true) {
        guard let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return }
        guard let stackView = scrollView.subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
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
        guard let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return }
        guard let stackView = scrollView.subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
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
}
