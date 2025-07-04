//
//  StatisticService.swift
//  MovieQuiz
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correctBestGame
        case totalBestGame
        case dateBestGame
        case gamesCount
        case totalCorrectAnswers
        case totalQuestions
    }
    private var totalNumberOfCorrectAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalNumberOfQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameResult {
        get{
            let correct = storage.integer(forKey: Keys.correctBestGame.rawValue)
            let total = storage.integer(forKey: Keys.totalBestGame.rawValue)
            let date = storage.object(forKey: Keys.dateBestGame.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, totalQuestions: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correctBestGame.rawValue)
            storage.set(newValue.totalQuestions, forKey: Keys.totalBestGame.rawValue)
            storage.set(newValue.date, forKey: Keys.dateBestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        return totalNumberOfQuestions != 0 ? (Double(totalNumberOfCorrectAnswers) / Double(totalNumberOfQuestions))*100 : 0
    }
    //save result of the current game and update total data
    func store(correct count: Int, total amount: Int) {
        totalNumberOfCorrectAnswers += count
        totalNumberOfQuestions += amount
        gamesCount += 1
        let currentGameResult: GameResult = GameResult(correct: count, totalQuestions: amount, date: Date())
        if currentGameResult.isResultBetterThan(bestGame){
            bestGame = currentGameResult
        }
    }
}
