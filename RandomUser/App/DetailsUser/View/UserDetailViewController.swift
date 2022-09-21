//
//  UserDetailViewController.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import UIKit
import Combine

class UserDetailViewController: UIViewController {
    
    private let viewModel: UserDetailViewModelProtocol
    private var contentView: UserView?
    
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        self.contentView = UserView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        setUI()
    }
    
    private func setUI() {
        title = "Detail User"
        view = contentView
    }
}
