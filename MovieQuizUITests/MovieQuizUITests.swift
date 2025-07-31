//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    func testYesButton() {
        sleep(5)
        //image with a movie
        let firstPoster = app.images["Poster"]
        let firstPosterImage = firstPoster.value as? String ?? ""
        XCTAssertFalse(firstPosterImage.isEmpty)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondPosterImage = secondPoster.value as? String ?? ""
        XCTAssertFalse(secondPosterImage.isEmpty)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        //label with a number of current question
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testNoButton() {
        sleep(5)
        //image with a movie
        let firstPoster = app.images["Poster"]
        let firstPosterImage = firstPoster.value as? String ?? ""
        XCTAssertFalse(firstPosterImage.isEmpty)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondPosterImage = secondPoster.value as? String ?? ""
        XCTAssertFalse(secondPosterImage.isEmpty)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        //label with a number of current question
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testFinishAlert() {
        /*title: "Этот раунд окончен!",
         button: "Сыграть еще раз",*/
        let questionsAmount = 10
        var tapCount = 0
        while tapCount < questionsAmount {
            if app.buttons["Yes"].isEnabled{
                app.buttons["Yes"].tap()
                tapCount += 1
            }
            else{
                sleep(1)
            }
        }
        sleep(5)
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.exists)
        let alertLabel = alert.label
        let alertButtonText = alert.buttons.firstMatch.label //?? ""
        XCTAssertEqual(alertLabel, "Этот раунд окончен!")
        XCTAssertEqual(alertButtonText, "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        let questionsAmount = 10
        var tapCount = 0
        while tapCount < questionsAmount {
            if app.buttons["Yes"].isEnabled{
                app.buttons["Yes"].tap()
                tapCount += 1
            }
            else{
                sleep(1)
            }
        }
        sleep(5)
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
