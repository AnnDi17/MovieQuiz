import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertProtocol?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    // counter of correct answers
    private var correctAnswers = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionLabel.font = Fonts.ysDisplayMedium20
        questionLabel.textColor = .ypWhite
        counterLabel.font = Fonts.ysDisplayMedium20
        counterLabel.textColor = .ypWhite
        textLabel.font = Fonts.ysDisplayBold23
        textLabel.textColor = .ypWhite
        yesButton.titleLabel?.font = Fonts.ysDisplayMedium20
        yesButton.titleLabel?.textColor = .ypBlack
        noButton.titleLabel?.font = Fonts.ysDisplayMedium20
        noButton.titleLabel?.textColor = .ypBlack
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = ResultAlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
        
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - AlertPresenterDelegate
    func didTapOk() {
        // returning to the start of the game
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        showLoadingIndicator()
        questionFactory?.loadData()
        //self.questionFactory?.requestNextQuestion()
    }
    // MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(data:  model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)"
        )
        return viewModel
    }
    // show current question
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    // show final result
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ){[weak self] in
            guard let self = self else {return}
            self.didTapOk()
        }
        alertPresenter?.showAlert(alertModel)
    }
    // change color of the border according to the answer: Green - correct, Red - wrong
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect {
            correctAnswers+=1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            if let statistic = statisticService {
                statistic.store(correct: correctAnswers, total: questionsAmount)
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    buttonText: "Сыграть еще раз",
                    statistic: statistic,
                    correctAnswers: correctAnswers,
                    questionsAmount: questionsAmount
                )
                show(quiz: result)
            }
        }
        else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let errorMessage = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"
        ){[weak self] in
            guard let self = self else {return}
            self.didTapOk()}
        alertPresenter?.showAlert(errorMessage)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        noButton.isEnabled = false
        /* button YES =>
         if YES is the correct answer, isCorrect = true
         if NO is the correct answer, isCorrect = false => isCorrect = questions[...].correctAnswer)*/
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        yesButton.isEnabled = false
        /* button YES =>
         if YES is the correct answer, isCorrect = false
         if NO is the correct answer, isCorrect = true => isCorrect = !questions[...].correctAnswer)*/
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
}
