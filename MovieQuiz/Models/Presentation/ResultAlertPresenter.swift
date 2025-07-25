//
//  AlertPresenter.swift
//  MovieQuiz
//

import UIKit

final class ResultAlertPresenter: AlertProtocol{
    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    func showAlert(_ model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion?()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
