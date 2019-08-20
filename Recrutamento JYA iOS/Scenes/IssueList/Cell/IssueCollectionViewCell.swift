//
//  IssueCollectionViewCell.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit

class IssueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    weak var delegate: IssueCellDelegate?
    var issue: Issue!
    
    func setup(issue: Issue) {
        self.issue = issue
        
        titleLabel.text = issue.title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.numberOfLines = 2
        
        let state = IssueState(rawValue: issue.state)
        stateImageView.image = state?.imageType
        stateLabel.text = state?.rawValue
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onCellTapped() {
        delegate?.cellSelected(issue: issue)
    }
}
