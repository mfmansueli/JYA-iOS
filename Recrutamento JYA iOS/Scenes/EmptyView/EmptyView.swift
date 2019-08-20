//
//  EmptyView.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    struct Constants {
        static let maxLines = 0
    }
    
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    func prepare(image: UIImage, message: String) {
        centerImageView.image = image
        centerImageView.contentMode = .scaleAspectFit
        centerImageView.tintColor = UIColor.gray
        
        messageLabel.text = message
        messageLabel.numberOfLines = Constants.maxLines
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
    }
}
