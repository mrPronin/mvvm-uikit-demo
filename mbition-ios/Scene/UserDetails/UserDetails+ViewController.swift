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
        let stackView = UIStackView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 0
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
        
    }
    
    private func setupOnLoad() {
        view.backgroundColor = .background
        title = "User details"
        
        // stackView
        stackView.add(into: view)
            .leading()
            .trailing()
            .top(0, relation: .equal, toSafeArea: true)
            .bottom(toSafeArea: true)
            .done()
    }
}
