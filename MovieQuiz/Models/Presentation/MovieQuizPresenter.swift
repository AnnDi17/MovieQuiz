//
//  MovieQuizPresenter.swift
//  MovieQuiz
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(data:  model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)"
        )
        return viewModel
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        
    }
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    func didAnswer(isCorrectAnswer: Bool){
        if isCorrectAnswer {
            correctAnswers+=1
        }
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if isYes{
            /* button YES =>
             if YES is the correct answer, isCorrect = true
             if NO is the correct answer, isCorrect = false => isCorrect = currentQuestion.correctAnswer)*/
            proceedWithAnswer(isCorrect: currentQuestion.correctAnswer)
        }else{
            /* button NO =>
             if YES is the correct answer, isCorrect = false
             if NO is the correct answer, isCorrect = true => isCorrect = !currentQuestion.correctAnswer)*/
            proceedWithAnswer(isCorrect: !currentQuestion.correctAnswer)
        }
    }
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            if let statistic = statisticService {
                statistic.store(correct: correctAnswers, total: self.questionsAmount)
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    buttonText: "Сыграть еще раз",
                    statistic: statistic,
                    correctAnswers: correctAnswers,
                    questionsAmount: self.questionsAmount
                )
                viewController?.show(quiz: result)
            }
        }
        else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
