//
//  UserDetailCoordinator.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import UIKit

final class UserDetailCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    
    var primaryViewController: UIViewController {
        // NOTE: TREATING THIS MODEL AS DEPENCY WHICH IS WHY FORCE CASTIN HERE
        let viewModel = UserDetailViewModel(user: model as! User)
        let detailViewController = UserDetailViewController(viewModel: viewModel)
        return detailViewController
    }
    
    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
