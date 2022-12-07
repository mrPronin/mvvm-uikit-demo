//
//  UserDetails+vc.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import UIKit

extension UserDetails {
    static func viewController(with userListModel: UserList.Model) -> UIViewController {
        // mock
        let testBundle = Bundle(for: UserDetails.ViewController.self)
        let path = testBundle.path(forResource: "user-details", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        var userDetails: UserDetails.Model?
        do {
            userDetails = try JSONDecoder().decode(UserDetails.Model.self, from: data!)
        } catch {
            LOG(error)
        }
//        LOG(userDetails)
        // mock
        
        // debug
        let userDetailsService = UserDetails.Service.Mock()
        userDetailsService.userDetails = userDetails
        // debug
        
        let viewModel = UserDetails.ViewModel.Implementation(
            userDetailsService: userDetailsService,
            userListModel: userListModel
        )
        
        return UserDetails.ViewController(viewModel: viewModel)
    }
}
