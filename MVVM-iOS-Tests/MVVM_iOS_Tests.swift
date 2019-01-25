//
//  MVVM_iOS_Tests.swift
//  MVVM-iOS-Tests
//
//  Created by Hovhannes Stepanyan on 1/24/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import XCTest
@testable import MVVM_ios
import Moya
import RxSwift

class MVVM_iOS_Tests: XCTestCase {
    
    let disposeBag = DisposeBag()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DataRepository.api().apiProvider = MoyaProvider<BaseTargetType>(stubClosure: MoyaProvider.immediatelyStub)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag.disposeAll()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let viewModel = SplashViewModel()
        let ex = XCTestExpectation(description: "expectation 1")
        viewModel.configs.bind { config in
            guard let configs = config else {
                return
            }
            XCTAssertEqual(configs.callCenter, "+374 30 121212")
            XCTAssertEqual(configs.loginTime, 15)
            XCTAssertNotNil(configs.amountSign)
            ex.fulfill()
        }.disposed(by: disposeBag)
        viewModel.getConfigs()
        wait(for: [ex], timeout: 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            for _ in 0...100000 {
                print("test")
            }
        }
    }

}
