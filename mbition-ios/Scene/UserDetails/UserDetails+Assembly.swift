//
//  UserDetails+vc.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import UIKit

extension UserDetails {
    static func viewController(with userListModel: UserList.Model) -> UIViewController {
        let userDetailsService = UserDetails.Service.Implementation()
        let viewModel = UserDetails.ViewModel.Implementation(
            userDetailsService: userDetailsService,
            userListModel: userListModel
        )
        
        return UserDetails.ViewController(viewModel: viewModel)
    }
}
