//
//  User.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import Foundation

struct User {
    let id: String
    let email: String
    let name: String
    let firstName: String
}

extension User: Codable {

}
