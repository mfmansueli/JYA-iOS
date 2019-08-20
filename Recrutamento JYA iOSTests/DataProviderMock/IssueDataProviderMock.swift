//
//  IssueDataProviderMock.swift
//  Recrutamento JYA iOSTests
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import RxSwift

@testable import Recrutamento_JYA_iOS

final class IssueDataProviderMock: IssueDataProviderProtocol {
    func loadIssueList() -> Observable<[Issue]> {
        return Observable.just([])
    }
    
    func loadIssue(number: Int) -> Observable<Issue> {
        return Observable.just(Issue())
    }
}
