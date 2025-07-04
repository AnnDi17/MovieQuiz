//
//  QuizResultsViewModel.swift
//  MovieQuiz
//

import Foundation

// ViewModel "Результат квиза"
struct QuizResultsViewModel {
    let title: String
    let buttonText: String
    let text: String
    init(title: String, buttonText: String, statistic: StatisticServiceProtocol, correctAnswers: Int, questionsAmount: Int){
        self.title = title
        self.buttonText = buttonText
        self.text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        + "\nКоличество сыгранных квизов: \(statistic.gamesCount)"
        + "\nРекорд: \(statistic.bestGame.correct)/\(statistic.bestGame.totalQuestions) (\(statistic.bestGame.date.dateTimeString))"
        + "\nСредняя точность: \(String(format: "%.2f", statistic.totalAccuracy))%"
    }
}
