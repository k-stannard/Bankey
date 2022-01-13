//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Koty Stannard on 1/12/22.
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
    var viewController: AccountSummaryViewController!
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManageable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
    }
    
    override func setUp() {
        super.setUp()
        viewController = AccountSummaryViewController()
        //viewController.loadViewIfNeeded()
        
        mockManager = MockProfileManager()
        viewController.profileManager = mockManager
    }
    
    func testErrorMessageForServerError() throws {
        let error = viewController.errorMessageTesting(for: .serverError)
        XCTAssertEqual("Server Error", error.0)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", error.1)
    }
    
    func testErrorMessageForDecodingError() throws {
        let error = viewController.errorMessageTesting(for: .decodingError)
        XCTAssertEqual("Decoding Error", error.0)
        XCTAssertEqual("We could not process your request. Please try again.", error.1)
    }
    
    func testAlertForServerError() throws {
        mockManager.error = NetworkError.serverError
        viewController.forceFetchProfile()
        
        XCTAssertEqual("Server Error", viewController.errorAlert.title)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", viewController.errorAlert.message)
    }
    
    func testAlertForDecodingError() throws {
        mockManager.error = NetworkError.decodingError
        viewController.forceFetchProfile()
        
        XCTAssertEqual("Decoding Error", viewController.errorAlert.title)
        XCTAssertEqual("We could not process your request. Please try again.", viewController.errorAlert.message)
    }
}
