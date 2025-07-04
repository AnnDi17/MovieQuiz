//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//

import UIKit

protocol AlertPresenterDelegate: AnyObject{
    func didTapOk()
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
