import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertProtocol?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
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
        yesButton.isEnabled = false
        noButton.isEnabled = false
        noButton.titleLabel?.font = Fonts.ysDisplayMedium20
        noButton.titleLabel?.textColor = .ypBlack
        alertPresenter = ResultAlertPresenter(delegate: self)
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    // MARK: - AlertPresenterDelegate
    func didTapOk() {
        // returning to the start of the game
        self.presenter.restartGame()
        showLoadingIndicator()
    }
    // show current question
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        imageView.accessibilityValue = "question number \(step.questionNumber)"
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    // show final result
    func show(quiz result: QuizResultsViewModel) {
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ){[weak self] in
            guard let self else {return}
            self.didTapOk()
        }
        alertPresenter?.showAlert(alert)
    }
    // change color of the border according to the answer: Green - correct, Red - wrong
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let errorMessage = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз"
        ){[weak self] in
            guard let self else {return}
            self.didTapOk()}
        alertPresenter?.showAlert(errorMessage)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        noButton.isEnabled = false
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        yesButton.isEnabled = false
        presenter.noButtonClicked()
    }
}
