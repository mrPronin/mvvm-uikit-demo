//
//  UserList+ViewController.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit
import Combine

extension UserList {
    class ViewController: UIViewController {
        // MARK: - Init
        init(viewModel: UserListViewModel) {
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

        // MARK: - UI
        
        // MARK: - Private
        let viewModel: UserListViewModel
        var router: UserListRouter!
        let load = PassthroughSubject<Void, Never>()
        var subscriptions = Set<AnyCancellable>()
    }
}

// MARK: - Private
extension UserList.ViewController {
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        // TODO: Update content
//        load.send(.init(sorting: viewModel.sorting, scope: .network))
        
        DispatchQueue.main.async {
            sender.endRefreshing()
        }
    }
    
    private func bindActions(with output: UserList.ViewModel.Output) {
        // TODO: implement bind actions
    }
    
    private func bindViewModel() {
        // TODO: implement bind view model
    }
    
    private func setupOnLoad() {
        
    }

}
