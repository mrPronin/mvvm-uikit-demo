//
//  UserList+vc.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

extension UserList {
    static var vc: UIViewController {
        // mock
        let testBundle = Bundle(for: UserList.ViewController.self)
        let path = testBundle.path(forResource: "user-list", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let userList = try? JSONDecoder().decode([UserList.Model].self, from: data!)
        // mock
        
        let userListService = UserList.Service.Mock()
        
        // debug
        userListService.userListArray = userList
        // debug
        
        let viewModel = UserList.ViewModel.Implementation(userListService: userListService)
        
        let viewController = UserList.ViewController(viewModel: viewModel)
        let router = UserList.Router(viewController: viewController)
        viewController.router = router
        return viewController
    }
}
