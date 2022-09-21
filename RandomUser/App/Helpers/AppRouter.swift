//
//  AppRouter.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import UIKit

final class AppRouter {
    private var coordinatorRegister: [Transition: Coordinator] = [.showMainScreen: UserListCoordinator(),
                                                                  .showUserDetail: UserDetailCoordinator()]
    let navigationViewController = UINavigationController()

    func start() {
        process(transition: .showMainScreen, with: nil)
    }
}

extension AppRouter: TransitionDelegate {

    func process(transition: Transition, with model: Any?) {
        print("Processing route: \(transition)")
        
        let coordinator = coordinatorRegister[transition]
        coordinator?.inject(transitionDelegate: self)
        coordinator?.inject(navigationController: navigationViewController)
        coordinator?.inject(model: model)
        coordinator?.start()
    }
}
