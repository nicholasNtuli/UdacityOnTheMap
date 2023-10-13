//
//  UserProfile.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
