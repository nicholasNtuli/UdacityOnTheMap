//
//  Location.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import Foundation

struct Location: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
       
        if let firstName = firstName {
            name = firstName
        }
        
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        
        if name.isEmpty {
            name = "FirstName LastName"
        }
        
        return name
    }
}
