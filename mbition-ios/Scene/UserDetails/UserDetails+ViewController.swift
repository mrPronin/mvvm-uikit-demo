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
        
        private func showImage(image: UIImage?) {
            avatarImageView.alpha = 0.0
            animator?.stopAnimation(false)
            avatarImageView.image = image
            animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.avatarImageView.alpha = 1.0
            })
        }
    }
}

// MARK: - Private
extension UserDetails.ViewController {
    private func bindViewModel() {
        let output = viewModel.transform(input: UserDetails.ViewModel.Input(
            load: load.eraseToAnyPublisher()
        ))
        
        // userListModel
        let sharedUserListModel = output.userListModel
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
        
        // userDetails
        output.userDetails
            .sink { [weak self] userDetails in
                if let heightConstraint = self?.detailsSectionView.constraint(forAttribute: .height) {
                    heightConstraint.isActive = false
                }
                // TODO: refactor multiple similar calls
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Name:"
                    $0.value.text = userDetails.name
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Company:"
                    $0.value.text = userDetails.company
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Location:"
                    $0.value.text = userDetails.location
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Twitter username:"
                    $0.value.text = userDetails.twitterUsername
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Public repos:"
                    $0.value.text = String(userDetails.publicRepos)
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Public gists:"
                    $0.value.text = String(userDetails.publicGists)
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Followers:"
                    $0.value.text = String(userDetails.followers)
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Following:"
                    $0.value.text = String(userDetails.following)
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Created at:"
                    $0.value.text = userDetails.createdAt
                })
                self?.detailsSectionView.contentStackView.addArrangedSubview(TitleAndValueView().then {
                    $0.title.text = "Updated at:"
                    $0.value.text = userDetails.updatedAt
                })
            }
            .store(in: &subscriptions)
        
        // error
        output.error
            .sink { [weak self] error in
                self?.showBanner(with: error)
            }
            .store(in: &subscriptions)

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
