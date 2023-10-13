//
//  LoginResponse.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
