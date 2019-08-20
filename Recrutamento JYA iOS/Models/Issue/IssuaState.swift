//
//  IssuaState.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit

enum IssueState: String {
    case open = "open"
    case closed = "closed"
    
    var imageType: UIImage? {
        get {
            switch self {
            case .open:
                return #imageLiteral(resourceName: "iconOpen")
            case .closed:
                return #imageLiteral(resourceName: "iconClose")
            }
        }
        set {
        }
    }
}
