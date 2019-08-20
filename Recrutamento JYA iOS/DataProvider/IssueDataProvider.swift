//
//  IssueDataProvider.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import RxSwift

protocol IssueDataProviderProtocol {
    func loadIssueList() -> Observable<[Issue]>
    func loadIssue(number: Int) -> Observable<Issue>
}

final class IssueDataProvider: IssueDataProviderProtocol {
    
    let apiClient: APIClient = APIClient()
    
    func loadIssueList() -> Observable<[Issue]> {
        return apiClient.requestList(IssueRouter.loadIssueList(), type: Issue.self)
    }
    
    func loadIssue(number: Int) -> Observable<Issue> {
        return apiClient.requestSingle(IssueRouter.loadIssue(number), type: Issue.self)
    }
}
