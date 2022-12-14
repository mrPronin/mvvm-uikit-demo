//
//  UserDetails+ViewController.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import UIKit
import Combine

extension UserDetails {
    class ViewController: UIViewController {
        // MARK: - Init
        init(viewModel: UserDetailsViewModel, imageLoader: ImageLoaderService = ImageLoader.Service.Implementation.shared) {
            self.viewModel = viewModel
            self.imageLoader = imageLoader
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupOnLoad()
            bindViewModel()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            load.send()
        }

        // MARK: - UI
        let scrollView = UIScrollView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
            $0.isPagingEnabled = false
            $0.backgroundColor = .background
        }
        
        let stackView = UIStackView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 0
        }
        
        let avatarView = SectionView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let avatarImageView = UIImageView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.image = .placeholder
            $0.backgroundColor = .systemGray6
        }
        
        let profileURLView = TitleAndValueView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.title.text = "User profile URL:"
        }
        
        let detailsSectionView = SectionView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }

        // MARK: - Private
        let viewModel: UserDetailsViewModel
        let load = PassthroughSubject<Void, Never>()
        let imageLoader: ImageLoaderService
        private var animator: UIViewPropertyAnimator?
        var subscriptions = Set<AnyCancellable>()
    }
}

// MARK: - Private
extension UserDetails.ViewController {
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(
            load: load.eraseToAnyPublisher()
        ))
        
        bind(userList: output.userList)
        bind(userDetails: output.userDetails)
        bind(error: output.error)
        bind(activityIndicator: output.activityIndicator)
    }
    
    private func bind(userList: AnyPublisher<UserList.Model, Never>) {
        let sharedUserListModel = userList
            .multicast { PassthroughSubject<UserList.Model, Never>() }
        
        sharedUserListModel
            .sink { [weak self] userListModel in
                self?.title = "User details: \(userListModel.login)"
                self?.profileURLView.value.text = userListModel.htmlUrl?.absoluteString
            }
            .store(in: &subscriptions)
        
        sharedUserListModel
            .map(\.avatarUrl)
            .compactMap { $0 }
            .flatMap({ [weak self] avatarUrl -> AnyPublisher<UIImage?, Never> in
                guard let imageLoader = self?.imageLoader else {
                    return Empty().eraseToAnyPublisher()
                }
                return imageLoader.loadImage(from: avatarUrl)
            })
            .sink { [unowned self] image in
                self.showImage(image: image)
            }
            .store(in: &subscriptions)
        
        sharedUserListModel.connect()
            .store(in: &subscriptions)
    }
    
    private func bind(userDetails: AnyPublisher<UserDetails.Model, Never>) {
        userDetails
            .sink { [weak self] userDetails in
                if let heightConstraint = self?.detailsSectionView.constraint(forAttribute: .height) {
                    heightConstraint.isActive = false
                }
                // Build details UI
                [
                    (userDetails.name, "Name:"),
                    (userDetails.company, "Company:"),
                    (userDetails.location, "Location:"),
                    (userDetails.twitterUsername, "Twitter username:"),
                    (String(userDetails.publicRepos), "Public repos:"),
                    (String(userDetails.publicGists), "Public gists:"),
                    (String(userDetails.followers), "Followers:"),
                    (String(userDetails.following), "Following:"),
                    (userDetails.createdAt, "Created at:"),
                    (userDetails.updatedAt, "Updated at:")
                ]
                    .map { TitleAndValueView(title: $0.1, value: $0.0) }
                    .forEach { [weak self] in self?.detailsSectionView.contentStackView.addArrangedSubview($0) }
            }
            .store(in: &subscriptions)

    }
    
    private func bind(error: AnyPublisher<Error, Never>) {
        error
            .sink { [weak self] error in
                self?.showBanner(with: error)
            }
            .store(in: &subscriptions)
    }
    
    private func bind(activityIndicator: AnyPublisher<Bool, Never>) {
        activityIndicator
            .sink { [weak self] showActivityIndicator in
                if showActivityIndicator {
                    self?.detailsSectionView.showActivityIndicator(.activityIndicator)
                } else {
                    self?.detailsSectionView.hideActivityIndicator()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func showImage(image: UIImage?) {
        avatarImageView.alpha = 0.0
        animator?.stopAnimation(false)
        avatarImageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.avatarImageView.alpha = 1.0
        })
    }

    private func setupOnLoad() {
        view.backgroundColor = .background
        title = "User details"
        
        // scrollView
        scrollView.add(into: view)
            .leading(16, toSafeArea: true)
            .trailing(16, toSafeArea: true)
            .top(16, toSafeArea: true)
            .bottom(toSafeArea: true)
            .done()

        // stackView
        stackView.add(into: scrollView)
            .leading()
            .trailing()
            .top()
            .bottom()
            .done()
        
        // avatarImageView
        avatarImageView.add(into: avatarView)
            .centerX()
            .centerY()
            .width(200)
            .height(200)
            .top(16)
            .bottom(16)
            .done()
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(avatarView)
        stackView.addArrangedSubview(profileURLView)
        stackView.addArrangedSubview(detailsSectionView)
    }
}
