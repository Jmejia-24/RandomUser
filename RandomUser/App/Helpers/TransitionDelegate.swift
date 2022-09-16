//
//  TransitionDelegate.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import Foundation

protocol TransitionDelegate: AnyObject {
    func process(transition: Transition, with model: Any?)
}

enum Transition {
    case showMainScreen
    case showUserDetail
}
