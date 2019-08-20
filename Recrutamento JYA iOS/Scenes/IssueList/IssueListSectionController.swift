//
//  IssueListSectionController.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//
import UIKit
import IGListKit

class IssueListSectionController: ListSectionController {
    
    struct Constants {
        static let cellHeight = CGFloat(105)
    }
    
    var object: Issue!
    weak var delegate: IssueListViewController!
    let itemsSize: Int = 1
    
    override func numberOfItems() -> Int {
        return itemsSize
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: Constants.cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: "IssueCollectionViewCell",
                                                          bundle: nil, for: self, at: index) as! IssueCollectionViewCell
        cell.delegate = delegate
        cell.setup(issue: object)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        assert(object is Issue)
        self.object = object as? Issue
    }
}
