//
//  AlertPresenter.swift
//  MovieQuiz
//

import UIKit

class ResultAlertPresenter: AlertProtocol{
    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    func showAlert(_ result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak delegate] _ in
            guard let delegate else {return}
            // returning to the start of the game
            delegate.didTapOk()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: result.completion)
    }
}
