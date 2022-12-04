//
//  UserList+Router.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

protocol UserListRouter {
    func navigateToUser(with userLoginId: String)
}

extension UserList {
    struct Router: UserListRouter {
        // MARK: - Public API
        func navigateToUser(with userLoginId: String) {
            // TODO: implement navigation
        }
        // MARK: - Init
        init(viewController: UserList.ViewController) {
            self.viewController = viewController
        }
        
        // MARK: - Private
        private weak var viewController: UserList.ViewController?
    }
}
