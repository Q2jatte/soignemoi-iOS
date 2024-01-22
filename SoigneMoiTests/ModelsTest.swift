//
//  ModelsTest.swift
//  SoigneMoiTests
//
//  Created by Eric Terrisson on 18/01/2024.
//

import XCTest
@testable import SoigneMoi

final class ModelsTest: XCTestCase {
    
    private var mockSession: URLSessionMock!
    private var api: Api!

    // init du MOCKER
    override func setUp() {
        super.setUp()
        mockSession = URLSessionMock()
        api = Api(session: mockSession)
    }
    
    // MARK: - API TEST
    
    // Login success
    func test_LoginApiResource_With_validRequest_Return_Token(){
        let expectation = self.expectation(description: "Server dont respond")
        let username = "john.doe@soignemoi.com"
        let password = "password"
        
        // MOCKER response
        let expectedToken = "mockedToken"
        let jsonData = try! JSONSerialization.data(withJSONObject: ["token": expectedToken], options: [])
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: Api.loginURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        api.sendLoginRequest(username: username, password: password) { result in
            switch result {
            case .success(let token):
                XCTAssertEqual(token, expectedToken)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Login request should not fail")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Login fail
    func test_LoginApiResource_With_invalidRequest_dontReturn_Token(){
        let expectation = self.expectation(description: "Server dont respond")
        let username = "john.doe@soignemoi.com"
        let password = "bad_password"
        
        // MOCKER response
        mockSession.data = nil
        mockSession.response = HTTPURLResponse(url: Api.loginURL, statusCode: 401, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        api.sendLoginRequest(username: username, password: password) { result in
            switch result {
            case .success(_):
                XCTFail("Login request should fail")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertTrue((error as NSError).code == (ApiError.authenticationFailure as NSError).code)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // GetProfile success
    func test_GetProfile_With_validRequest_Return_Profile(){
        let expectation = self.expectation(description: "Server dont respond")
        
        // MOCKER response
        let expectedProfile = Profile(firstName: "john", lastName: "Doe", doctor: DoctorResp(service: Service(name: "Cardiologie")), profileImageName: "img.png")
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(expectedProfile)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: Api.profileURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        api.getProfileRequest() { result in
            switch result {
            case .success(let profile):
                XCTAssertTrue(profile.firstName == expectedProfile.firstName)
                expectation.fulfill()
            case .failure(_):
                XCTFail("GetProfile request should not fail")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // GetStays success
    func test_GetStays_With_validRequest_Return_Stays(){
        let expectation = self.expectation(description: "Server dont respond")
        
        // MOCKER response
        let expectedStays = [Stay(id: 21, entranceDate: Date(), dischargeDate: Date(), reason: "Reason", service: Service(name: "Neurologie"))]
        let jsonEncoder = JSONEncoder()
        // encoder ne connait pas le format retourné par Date...
        jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        let jsonData = try! jsonEncoder.encode(expectedStays)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: Api.getStaysByPatientAndStatusURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        api.getStaysByPatientAndStatus(id: 1, status: "current") { result in
            switch result {
            case .success(let stays):
                XCTAssertTrue(stays[0].service.name == expectedStays[0].service.name)
                expectation.fulfill()
            case .failure(_):
                XCTFail("GetStays request should not fail")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // New prescription success
    func test_NewPrescription_With_validRequest_Return_Success(){
        let expectation = self.expectation(description: "Server dont respond")
        
        // MOCKER response
        let successMessage = "Prescription ajoutée avec succès."
        let successData = try! JSONEncoder().encode(ResponseMessage(message: successMessage))
        mockSession.data = successData
        mockSession.response = HTTPURLResponse(url: Api.prescriptionURL, statusCode: 201, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        let newPrescription = Prescription(startAt: Date(), endAt: Date(), medications: [Medication(name: "med", dosage: "dosage")])
        
        api.createNewPrescription(prescription: newPrescription) { result in
            switch result {
            case .success(let message):
                XCTAssertEqual(message, successMessage)
                expectation.fulfill()
            case .failure(_):
                XCTFail("New prescription request should not fail")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // New comment success
    func test_NewComment_With_validRequest_Return_Success(){
        let expectation = self.expectation(description: "Server dont respond")
        
        // MOCKER response
        let successMessage = "Commentaire ajouté avec succès."
        let successData = try! JSONEncoder().encode(ResponseMessage(message: successMessage))
        mockSession.data = successData
        mockSession.response = HTTPURLResponse(url: Api.commentURL, statusCode: 201, httpVersion: nil, headerFields: nil)
        mockSession.error = nil

        let newComment = Comment(title: "Titre", content: "Content", createAt: Date())
        
        api.createNewComment(comment: newComment) { result in
            switch result {
            case .success(let message):
                XCTAssertEqual(message, successMessage)
                expectation.fulfill()
            case .failure(_):
                XCTFail("New comment request should not fail")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: - ACTIVEUSER TESTS
    
    func test_AddTokenToActiveUser_shouldSetToken(){
        let expectedToekn = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MDU5MTQ1MDUsImV4cCI6MTcwNTkyMTcwNSwicm9sZXMiOlsiUk9MRV9ET0NUT1IiXSwidXNlcm5hbWUiOiJpLnZhbGVuY2lhQHNvaWduZW1vaS5jb20ifQ.Cm_9svyvDLBWOVYSUflyOM7S99S0EC_j584VGAEGlF2ohUcV37ROwoUuiEgTm6CtvN0vD0OAt9iKB1IX_81OOQSkXZSnPPtYAdze_a6o0prT_ZYG2k9yW95XvGiWhAWkYr7SzUn3PoUWgSZliC9n8WlGkpU5qKYgGFYaI8n-svt45QgVSAneY3V5Y-_rDs4RsnFZni8QgBQp6ZGxmXzZq6HofZogw9SUzaAe6V1UGUCxCBVVrqY456SZlt7SN3U_FuOZh5d5-slrPW803EgZZVDmA_gQqe-aqYP7vPNgczbvDrptP0EqDfKCbTqtYxza6MYYOFnhHT4jUufo1YujhSe9eXREY85A1ValSYVpze9FPAsQGFcj-39xqwfOc0i8MF7L9ZHt8nIBnjykYZgoETn_D50Uk0TP1m8EQkoasPrB1jwDEeph6zDEDezo4leGGHo0TsGd4VKWOJKd5MeyOYIW7SX9OamaS0q21ecKslHOQ_dHGN_9SwC8JuHLCmMvKhsbp702uux6NgsCMg4ea5uplwPm5FljIZOTjkSzswHvpANXAxQylCCnFD3LqGgk2q29W74KFgSp-CaIKddn1bJVpRUSVcaoqwx2EnkXKslRGHkrdoh_PHZxTO6KcrJ1SWrwrDEPtJ-gRRlNR_qb2aDp4pl-R_Cf9H9b5UMi3Y4"
        ActiveUser.shared.tokenManager.setToken(token: expectedToekn)
        XCTAssertEqual(expectedToekn, ActiveUser.shared.tokenManager.token)
    }
    
    // MARK: - DATE FORMATTER
    
    func test_ISO8601FullFormatter_ShouldProduceCorrectDate() {
        // Given
        let dateString = "1979-10-23T12:12:12+00:00"
        let expectedDate = Date(timeIntervalSince1970: 309_528_732)

        // When
        if let formattedDate = DateFormatter.iso8601Full.date(from: dateString) {
            // Then
            XCTAssertEqual(formattedDate, expectedDate, "Date does not match the expected value")
        } else {
            XCTFail("Failed to parse date from string: \(dateString)")
        }
    }
}

// URLSessionMock class to mock URLSession for testing
class URLSessionMock: URLSession {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskMock()
        task.completionHandler = { [weak self] in
            completionHandler(self?.data, self?.response, self?.error)
        }
        return task
    }
}

// URLSessionDataTaskMock class to mock URLSessionDataTask
class URLSessionDataTaskMock: URLSessionDataTask {
    var completionHandler: (() -> Void)?

    override func resume() {
        completionHandler?()
    }
}
