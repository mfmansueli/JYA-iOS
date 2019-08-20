//
//  IssueListPresenter.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IssueListPresenterInput {
    func loadIssueList()
    func loadIssue(_ number: Int)
}

protocol IssueListPresenterOutput {
    var isLoading: Driver<Bool> { get }
    var error: Driver<Error> { get }
    var onLoadIssueList: Driver<[Issue]> { get }
    var onLoadIssue: Driver<Issue> { get }
}

protocol IssueListPresenterType {
    var input: IssueListPresenterInput { get }
    var output: IssueListPresenterOutput { get }
}

final class IssueListPresenter: IssueListPresenterType, IssueListPresenterInput, IssueListPresenterOutput {
    
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    var error: SharedSequence<DriverSharingStrategy, Error>
    let onLoadIssueList: SharedSequence<DriverSharingStrategy, [Issue]>
    let onLoadIssue: SharedSequence<DriverSharingStrategy, Issue>
    
    init(provider: IssueDataProviderProtocol = IssueDataProvider()) {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        error = errorTracker.asDriver()
        isLoading = activityTracker.asDriver()
        
        onLoadIssueList = loadIssueListProperty
            .asDriverOnErrorJustComplete()
            .flatMapLatest({ _ -> Driver<[Issue]> in
                return provider.loadIssueList()
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            })
        
        onLoadIssue = loadIssueProperty
            .asDriverOnErrorJustComplete()
            .flatMapLatest({ number -> Driver<Issue> in
                return provider.loadIssue(number: number)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            })
    }
    
    private let loadIssueListProperty = PublishSubject<Void>()
    func loadIssueList() {
        loadIssueListProperty.onNext(())
    }
    
    private let loadIssueProperty = PublishSubject<Int>()
    func loadIssue(_ number: Int) {
        loadIssueProperty.onNext(number)
    }
    
    var input: IssueListPresenterInput { return self }
    var output: IssueListPresenterOutput { return self }
}
