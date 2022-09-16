//
//  UserDetailViewModel.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import UIKit
import Combine

final class UserDetailViewModel {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
}

extension UserDetailViewModel: UserDetailViewModelProtocol {
    var userDetail: User { user }
}
