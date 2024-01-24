//
//  ModelsViewTest.swift
//  SoigneMoiTests
//
//  Created by Eric Terrisson on 23/01/2024.
//
// INTEGRATION TESTS

import XCTest
@testable import SoigneMoi

final class ModelsViewTest: XCTestCase {

    private let username: String = ProcessInfo.processInfo.environment["TEST_USERNAME"]!
    private let password: String = ProcessInfo.processInfo.environment["TEST_PASSWORD"]!
    
    
    
    // Test chainé des ViewModels
    func test_All_ViewModels() {
        let expectation = self.expectation(description: "Server dont respond")
        let loginVM = LoginViewModel()
        
        // connexion à l'api
        ActiveUser.shared.username = username
        ActiveUser.shared.password = password
        
        loginVM.login() { result in
            switch result {
            case .success(_):
                loginVM.isAuthenticated = true
                self.dashboardViewModelTest(expectation: expectation)
            case .failure(_):
                XCTFail("L'utilisateur n'est pas connecté.")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test VM Dashboard
    func dashboardViewModelTest(expectation: XCTestExpectation) {
        let dashboardVM = DashboardViewModel()
        dashboardVM.getPatients() { result in
            switch result {
            case .success(_):
                self.patientViewModelTest(patient: dashboardVM.patientsList[0].patient, expectation: expectation)
                
            case .failure(_):
                XCTFail("La liste des patients ne peut etre vide.")
                expectation.fulfill()
            }
        }
        
    }
    
    // Test VM Patient
    func patientViewModelTest(patient: Patient, expectation: XCTestExpectation) {
        let patientVM = PatientViewModel()        
        
        patientVM.loadPatient(patient: patient){
            XCTAssertNotNil(patientVM.firstName)
            expectation.fulfill()
        }
    }
}
