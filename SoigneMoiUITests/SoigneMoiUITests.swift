//
//  SoigneMoiUITests.swift
//  SoigneMoiUITests
//
//  Created by Eric Terrisson on 05/12/2023.
//
// IMPORTANT : pour éviter le bug de saisie, le clavier externe doit etre désactivé ( Simulator > I/O > Keyboard > Connect Hardware keyboard

import XCTest
@testable import SoigneMoi

final class SoigneMoiUITests: XCTestCase {
    
    private let username: String = ProcessInfo.processInfo.environment["TEST_USERNAME"]!
    private let password: String = ProcessInfo.processInfo.environment["TEST_PASSWORD"]!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func test_create_A_Prescription_For_A_Visited_Patient() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Mot de passe"]
        let medicineNameTextField = app.textFields["Nom du traitement"]
        let medicineDosage = app.textFields["Posologie"]
        
        // On s'assure que les champs existent
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        
        // On remplit les champs avec des valeurs d'exemple
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText(self.username)
        sleep(1)
        passwordSecureTextField.tap()
        sleep(1)
        passwordSecureTextField.typeText(self.password)
        
        app.buttons["Se connecter"].tap()
        
        sleep(5)
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons.element(boundBy: 0).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Ajouter").element(boundBy: 0).tap()
        
        medicineNameTextField.tap()
        medicineNameTextField.typeText("Paracétamol")
        medicineDosage.tap()
        medicineDosage.typeText("3 x 1000mg par jour")
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Ajouter"]/*[[".cells.buttons[\"Ajouter\"]",".buttons[\"Ajouter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enregistrer"].tap()
        sleep(5)
        let alert = app.alerts["Succès 👍"]
        XCTAssertTrue(alert.exists)
    }
    
    func test_create_A_Comment_For_A_Visited_Patient() throws {
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Mot de passe"]
        let commentTitleTextField = app.textFields["Titre"]
        let commentContentTextFiel = app.textFields["Commentaire"]
        
        // On s'assure que les champs existent
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        
        // On remplit les champs avec des valeurs d'exemple
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText(self.username)
        sleep(1)
        passwordSecureTextField.tap()
        sleep(1)
        passwordSecureTextField.typeText(self.password)
        
        app.buttons["Se connecter"].tap()
        
        sleep(5)
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons.element(boundBy: 0).tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Ajouter").element(boundBy: 1).tap()
        
        commentTitleTextField.tap()
        commentTitleTextField.typeText("Rétablissement")
        commentContentTextFiel.tap()
        commentContentTextFiel.typeText("Chute de la fièvre. Sortie imminente")
        app.buttons["Enregistrer"].tap()
        sleep(5)
        let alert = app.alerts["Succès 👍"]
        XCTAssertTrue(alert.exists)
    }
    
    func test_Modify_A_Precription_For_A_Visited_Patient() throws {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE d MMMM"
            return formatter
        }()
        let currentDate = Date()
        let anotherDay = currentDate.addingTimeInterval(TimeInterval(24 * 60 * 60 * Int(arc4random_uniform(11)))) // 24 hours in seconds * random Int
        let dateString = dateFormatter.string(from: anotherDay)
        
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Mot de passe"]
        
        // On s'assure que les champs existent
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        
        // On remplit les champs avec des valeurs d'exemple
        emailTextField.tap()
        sleep(1)
        emailTextField.typeText(self.username)
        sleep(1)
        passwordSecureTextField.tap()
        sleep(1)
        passwordSecureTextField.typeText(self.password)
        app.buttons["Se connecter"].tap()
        sleep(3)
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons.element(boundBy: 0).tap()
        sleep(3)
        app.collectionViews["list"].children(matching: .cell).element(boundBy: 0).buttons.element(boundBy: 0).tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.datePickers.containing(.button, identifier:"Date Picker").element/*[[".cells.datePickers.containing(.button, identifier:\"Date Picker\").element",".datePickers.containing(.button, identifier:\"Date Picker\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.datePickers.collectionViews.buttons[dateString].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["PopoverDismissRegion"]/*[[".buttons[\"dismiss popup\"]",".buttons[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Enregistrer"].tap()
        sleep(3)
        let alert = app.alerts["Prescription modifiée 👍"]
        XCTAssertTrue(alert.exists)
    }
    
    func test_LaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
