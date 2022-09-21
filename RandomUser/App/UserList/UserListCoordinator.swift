//
//  UserListCoordinator.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/16/22.
//

import UIKit

final class UserListCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = UserListViewModel()
        viewModel.transitionDelegate = transitionDelegate
        let viewController = UserListViewController(viewModel: viewModel)
        return viewController
    }()
    
    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
