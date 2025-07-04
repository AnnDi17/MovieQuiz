//
//  GameResult.swift
//  MovieQuiz
//

import Foundation

struct GameResult {
    let correct: Int
    let totalQuestions: Int
    let date: Date
    func isResultBetterThan(_ result: GameResult)->Bool{
        if totalQuestions == 0 {
            return false
        }
        if result.totalQuestions == 0 {
            return true
        }
        if Double(correct)/Double(totalQuestions) > Double(result.correct)/Double(result.totalQuestions){
            return true
        }
        else{
            return false
        }
    }
}
