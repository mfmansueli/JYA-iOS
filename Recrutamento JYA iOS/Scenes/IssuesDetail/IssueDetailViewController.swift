//
//  IssueDetailViewController.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit
import Kingfisher

class IssueDetailViewController: ViewController {

    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var issueTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var issueDescriptionTextView: UITextView!
    @IBOutlet weak var browserButton: UIButton!
    
    var issue: Issue!
    
    init(_ issue: Issue?) {
        super.init(nibName: nil, bundle: nil)
        if issue == nil {
            fatalError("Issue must be injected")
        }
        self.issue = issue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        initNavigationBar()
        
        createdDateLabel.text = dateToString(date:issue.createdDate, format: "dd/MM/yyyy")
        createdDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        createdDateLabel.translatesAutoresizingMaskIntoConstraints = true
        
        issueTitleLabel.text = issue.title
        issueTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        issueTitleLabel.numberOfLines = 3
        
        let radius = avatarImageView.frame.height / 2
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = radius
        let processor = RoundCornerImageProcessor(cornerRadius: radius)
        avatarImageView.kf.setImage(with: URL(string: issue.user.avatar),
                                     placeholder: #imageLiteral(resourceName: "iconAvatar"),
                                     options: [.processor(processor)])
        
        nickNameLabel.text = issue.user.login
        
        issueDescriptionTextView.text = issue.body
        issueDescriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        issueDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        issueDescriptionTextView.sizeToFit()
        issueDescriptionTextView.isScrollEnabled = false
        issueDescriptionTextView.isUserInteractionEnabled = false
        browserButton.setTitle("See more in browser", for: .normal)
    }
    
    private func initNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onBackButtonTapped))
        navigationItem.title = "Detalhes da Issue #\(issue.number)"
    }

    @objc func onBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let identifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: identifier)
        }
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }

    @IBAction func browserButtonTapped(_ sender: Any) {
        if let url = URL(string: issue.url) {
            UIApplication.shared.open(url)
        }
    }
}
