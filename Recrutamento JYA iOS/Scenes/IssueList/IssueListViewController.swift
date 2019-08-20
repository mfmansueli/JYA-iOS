//
//  IssueListViewController.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit

class IssueListViewController: ViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var items: [Issue] = [] {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    var presenter: IssueListPresenterType?
    let refreshControl = UIRefreshControl()
    
    init(_ presenter: IssueListPresenter?) {
        super.init(nibName: nil, bundle: nil)
        if presenter == nil {
            fatalError("Presenter must be injected")
        }
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        navigationItem.title = "Issues"
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func bindPresenter() {
        presenter?.output.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let strongSelf = self else { return }
                if isLoading {
                    strongSelf.refreshControl.beginRefreshing()
                    return
                }
                strongSelf.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        presenter?.output.error
            .drive(onNext: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showAlert(title: error.localizedDescription, message: "",
                                     buttonText: "Ok",
                                     alertAction: { })
            }).disposed(by: disposeBag)
        
        presenter?.output.onLoadIssueList
            .drive(onNext: { [weak self] list in
                guard let strongSelf = self else { return }
                strongSelf.items = list
            }).disposed(by: disposeBag)
        
        presenter?.output.onLoadIssue
            .drive(onNext: { [weak self] issue in
                guard let strongSelf = self else { return }
                strongSelf.push(to: IssueDetailViewController(issue))
            }).disposed(by: disposeBag)
        
        presenter?.input.loadIssueList()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        presenter?.input.loadIssueList()
    }
}

extension IssueListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return items as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = IssueListSectionController()
        section.delegate = self
        return section
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let emptyView: EmptyView? = {
           let view = UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: EmptyView.self, options: nil).first as? EmptyView
            
            view?.prepare(image: #imageLiteral(resourceName: "iconOpen"), message: "Nenhum resultado encontrado")
            
            return view
        }()
        return emptyView
    }
}

extension IssueListViewController: IssueCellDelegate {
    func cellSelected(issue: Issue) {
        presenter?.input.loadIssue(issue.number)
    }
}
