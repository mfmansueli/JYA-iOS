//
//  IssueListPresenterTests.swift
//  Recrutamento JYA iOSTests
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa

@testable import Recrutamento_JYA_iOS

enum ParseError: Error, Equatable {
    case unexpectedArgument()
}

class IssueListPresenterTests: XCTestCase {
    
    private var presenter: IssueListPresenterType!
    var testScheduler: TestScheduler!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        presenter = IssueListPresenter(provider: IssueDataProviderMock())
    }
    
    override func tearDown() {
        super.tearDown()
        testScheduler = nil
        presenter = nil
    }
    
    func testWhenSuccessLoadIssueList() {
        let observer = testScheduler.createObserver([Issue].self)
        presenter.output.onLoadIssueList.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        presenter.input.loadIssueList()
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testWhenSuccessLoadIssue() {
        let observer = testScheduler.createObserver(Issue.self)
        presenter.output.onLoadIssue.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        presenter.input.loadIssue(0)
        XCTAssertEqual(observer.events.count, 1)
    }
    
}
