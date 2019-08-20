//
//  Issue.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit
import IGListKit

class Issue: Codable {
    var id: Int = 0
    var url: String = ""
    var title: String = ""
    var number: Int = 0
    var comments: Int = 0
    var state: String = ""
    var user: User = User()
    var body: String = ""
    var createdDate: Date = Date()
    
    init () {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "html_url"
        case number = "number"
        case title = "title"
        case state = "state"
        case user = "user"
        case body = "body"
        case createdDate = "created_at"
    }
}

extension Issue: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Issue else { return false }
        return id == object.id
    }
}
