//
//  UserList+Router.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

protocol UserListRouter {
    func navigateToUser(with userListItem: UserList.Model)
}

extension UserList {
    struct Router: UserListRouter {
        // MARK: - Public API
        func navigateToUser(with userListModel: UserList.Model) {
            let detailsViewController = UserDetails.viewController(with: userListModel)
            viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        // MARK: - Init
        init(viewController: UserList.ViewController) {
            self.viewController = viewController
        }
        
        // MARK: - Private
        private weak var viewController: UserList.ViewController?
    }
}
