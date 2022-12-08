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
        init(viewModel: UserDetailsViewModel) {
            self.viewModel = viewModel
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
        
        let profileURLView = TitleAndValueView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.title.text = "User profile URL:"
        }

        // MARK: - Private
        let viewModel: UserDetailsViewModel
        let load = PassthroughSubject<Void, Never>()
        var subscriptions = Set<AnyCancellable>()
    }
}

// MARK: - Private
extension UserDetails.ViewController {
    private func bindViewModel() {
        let output = viewModel.transform(input: UserDetails.ViewModel.Input(
            load: load.eraseToAnyPublisher()
        ))
        
        // userListModel
        output.userListModel
            .sink { [weak self] userListModel in
                self?.title = "User details: \(userListModel.login)"
                self?.profileURLView.value.text = userListModel.url?.absoluteString
            }
            .store(in: &subscriptions)
        
        // userDetails
        output.userDetails
            .sink { [weak self] userDetails in
                self?.stackView.addArrangedSubview(SectionView().then {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
                })
                LOG(userDetails)
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
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.stackView.addArrangedSubview(profileURLView)
    }
}
