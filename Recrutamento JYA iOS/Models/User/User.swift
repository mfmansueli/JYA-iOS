//
//  User.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

class User: Codable {
    var avatar: String = ""
    var login: String = ""
    
    init () {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case avatar = "avatar_url"
        case login = "login"
    }
}
