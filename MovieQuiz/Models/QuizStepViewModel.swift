//
//  QuizStepViewModel.swift
//  MovieQuiz
//

import UIKit

// ViewModel "Вопрос показан"
struct QuizStepViewModel {
    // poster
    let image: UIImage
    let question: String
    // number of the current question (ex. "1/10")
    let questionNumber: String
}
