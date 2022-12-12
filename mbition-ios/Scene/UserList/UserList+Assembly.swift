//
//  UserList+vc.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

extension UserList {
    static var vc: UIViewController {
        let userListService = UserList.Service.Implementation()
        let viewModel = UserList.ViewModel.Implementation(userListService: userListService)
        
        let viewController = UserList.ViewController(viewModel: viewModel)
        let router = UserList.Router(viewController: viewController)
        viewController.router = router
        return viewController
    }
}
