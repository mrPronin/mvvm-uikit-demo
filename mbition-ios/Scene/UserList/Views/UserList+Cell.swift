//
//  UserList+Cell.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit
import Combine

extension UserList {
    class Cell: UITableViewCell {
        // MARK: - Public
        class var identifier: String { return String.className(self) }
        
        func configure(with model: UserList.Model, imageLoader: ImageLoaderService = ImageLoader.Service.Implementation.shared) {
            self.imageLoader = imageLoader
            title.text = model.login
            cancellable = loadImage(for: model).sink { [unowned self] image in self.showImage(image: image) }
        }
        
        // ignore the default handling
        override open func setSelected(_ selected: Bool, animated: Bool) {}
        
        // MARK: - Init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupOnLoad()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func prepareForReuse() {
            super.prepareForReuse()
            avatar.image = .placeholder
            animator?.stopAnimation(true)
            cancellable?.cancel()
        }

        // MARK: - UI
        let avatar = UIImageView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.image = .placeholder
            $0.backgroundColor = .systemGray6
        }
        
        let title = UILabel().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = UIColor.UserList.textColor
            $0.font = .systemFont(ofSize: 24, weight: .bold)
        }

        // MARK: - Private
        private var imageLoader: ImageLoaderService?
        private var animator: UIViewPropertyAnimator?
        private var cancellable: AnyCancellable?
        
        private func showImage(image: UIImage?) {
            avatar.alpha = 0.0
            animator?.stopAnimation(false)
            avatar.image = image
            animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.avatar.alpha = 1.0
            })
        }

        private func loadImage(for model: UserList.Model) -> AnyPublisher<UIImage?, Never> {
            return Just(model.avatarUrl)
                .compactMap { $0 }
                .flatMap({ [weak self] avatarUrl -> AnyPublisher<UIImage?, Never> in
                    guard let imageLoader = self?.imageLoader else {
                        return Empty().eraseToAnyPublisher()
                    }
                    return imageLoader.loadImage(from: avatarUrl)
                })
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Private
extension UserList.Cell {
    private func setupOnLoad() {
        contentView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.background.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
//        accessoryType = .disclosureIndicator
        
//        containerView.add(into: contentView)
//            .leading(8)
//            .height(80)
//            .trailing(8)
//            .top(8)
//            .bottom(8)
//            .done()

//        contentStackView.add(into: contentView)
//            .leading(8)
//            .trailing(8)
//            .top(8)
//            .bottom(8)
//            .done()

        avatar.add(into: contentView)
            .leading(16)
            .top(8)
            .bottom(8)
            .height(100)
            .width(100)
            .done()
        
        title.add(into: contentView)
            .leading(to: avatar, constant: 16)
            .top(8)
            .bottom(8)
            .trailing(16, relation: .greaterThanOrEqual)
            .done()

        // avatar
//        avatar.cl
//            .width(60)
//            .height(60)
//            .done()
//        contentStackView.addArrangedSubview(avatar)

        // title
//        contentStackView.addArrangedSubview(title)
    }
}
