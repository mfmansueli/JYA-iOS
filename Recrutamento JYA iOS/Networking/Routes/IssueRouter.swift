//
//  IssueRouter.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum IssueRouter {
    case loadIssueList()
    case loadIssue(Int)
}

extension IssueRouter: RouterType {
    
    var method: HTTPMethod {
        switch self {
        case .loadIssueList, .loadIssue:
            return .get
        }
    }
    
    var paramsQueryString: [String : Any]? {
        switch self {
        case .loadIssueList:
            return ["state": "all"]
        case .loadIssue:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .loadIssueList:
            return "issues"
        case .loadIssue(let number):
            return "issues/\(number)"
        }
    }
}
