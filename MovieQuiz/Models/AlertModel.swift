//
//  AlertModel.swift
//  MovieQuiz
//

import Foundation

// Data for Alert
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)?
}
