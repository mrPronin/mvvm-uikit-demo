//
//  Endpoint+userDetails.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import Foundation

extension Endpoint where Kind == EndpointKinds.Public, Response == UserDetails.Model, Payload == String {
    static func userDetails(with userLoginId: String) -> Self { Endpoint(path: "users/\(userLoginId)") }
}
