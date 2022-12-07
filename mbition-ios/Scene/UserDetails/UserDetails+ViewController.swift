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
        
        let profileURLView = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .lightGray
            let title = UILabel().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "User profile URL:"
            }
            title.add(into: $0)
                .leading(16)
                .top(16)
                .bottom(16)
                .done()
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
//                LOG(userListModel)
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

        // profileURLView
        profileURLView.cl
            .height(100)
//            .width(100)
            .done()
        stackView.addArrangedSubview(profileURLView)
    }
}
