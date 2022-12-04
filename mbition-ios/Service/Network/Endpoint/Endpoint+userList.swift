//
//  Endpoint+userList.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension Endpoint where Kind == EndpointKinds.Public, Response == [UserList.Model], Payload == String {
    static var userList: Self { Endpoint(path: "users") }
}
