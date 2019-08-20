//
//  IssueCellDelegate.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit

protocol IssueCellDelegate: class {
    func cellSelected(issue: Issue)
}

extension IssueCellDelegate where Self: UIViewController {
    
}
