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
        
        let tableView = UITableView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .background
            $0.tableFooterView = UIView()
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.separatorStyle = .singleLine
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.registerCellClass(UserList.Cell.self)
            $0.isHidden = true
        }
        
        private let refreshControl = UIRefreshControl()

        // MARK: - Private
        let viewModel: UserListViewModel
        var userList = [UserList.Model]()
        var router: UserListRouter!
        let load = PassthroughSubject<Void, Never>()
        var subscriptions = Set<AnyCancellable>()
    }
}

// MARK: - UITableViewDelegate
extension UserList.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        let item = userList[indexPath.row]
        router.navigateToUser(with: item)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
            tableView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Private
extension UserList.ViewController {
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async { [weak self] in
            self?.load.send()
            sender.endRefreshing()
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: UserList.ViewModel.Input(
            load: load.eraseToAnyPublisher()
        ))
        
        // serverList
        output.userList
            .handleEvents(receiveOutput: { [weak self] userList in
                self?.userList = userList
            })
            .bind(subscriber: tableView.rowsSubscriber(cellIdentifier: UserList.Cell.identifier, cellType: UserList.Cell.self, cellConfig: { cell, _, model in
                cell.configure(with: model)
            })).store(in: &subscriptions)

        // activityIndicator
        output.activityIndicator
            .sink { [weak self] showActivityIndicator in
                if showActivityIndicator {
                    self?.view.showActivityIndicator(.activityIndicator)
                } else {
                    self?.tableView.isHidden = false
                    self?.view.hideActivityIndicator()
                }
            }.store(in: &subscriptions)

    }
    
    private func setupOnLoad() {
        view.backgroundColor = .background
        title = "User list"
        
        // stackView
        stackView.add(into: view)
            .leading()
            .trailing()
            .top(0, relation: .equal, toSafeArea: true)
            .bottom(toSafeArea: true)
            .done()
        
        stackView.addArrangedSubview(tableView)
        
        // refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        // tableView
        tableView.refreshControl = refreshControl
        tableView.delegate = self
    }
}
