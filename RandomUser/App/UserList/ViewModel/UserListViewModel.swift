//
//  UserListViewModel.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/16/22.
//

import UIKit
import Combine
import OrderedCollections

final class UserListViewModel {
    weak var transitionDelegate: TransitionDelegate?
    let userListSubject = PassthroughSubject<[User], Failure>()
    private var cancellables = Set<AnyCancellable>()
    private let store: RandomUserStore
    
    private var randomUserBase: RandomUserBase?
    
    private var fetchedUser = OrderedSet([User]()) {
        didSet {
            userListSubject.send(fetchedUser.elements)
        }
    }
    
    init(store: RandomUserStore = APIManager()) {
        self.store = store
    }
    
    func loadData(seed: String = "", page: Int = 1) {
        
        let recievedUsers = { [unowned self] (newRandomUserBase: RandomUserBase) -> Void in
            randomUserBase = newRandomUserBase
            DispatchQueue.main.async {
                fetchedUser.append(contentsOf: newRandomUserBase.results)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
                case .finished:
                    break
                case .failure(let failure):
                    userListSubject.send(completion: .failure(failure))
            }
        }
        
        store.readRandomUser(seed: seed, page: page)
            .sink(receiveCompletion: completion, receiveValue: recievedUsers)
            .store(in: &cancellables)
    }
    
    func searchUser(with query: String?) {
        if let query = query, !query.isEmpty {
            let lowerCaseQuery = query.lowercased()
            let filteredUserList = fetchedUser.elements.filter { $0.name?.first?.lowercased().contains(lowerCaseQuery) ?? false }
            userListSubject.send(filteredUserList)
        } else {
            userListSubject.send(fetchedUser.elements)
        }
    }
    
    func prefetchData(for indexPaths: [IndexPath]) {
        guard let index = indexPaths.last?.row else { return }
        var pageNo = randomUserBase?.info.page ?? 1
        pageNo += 1
        let userAlreadyLoaded = fetchedUser.count
        if index > userAlreadyLoaded - 10 {
            loadData(seed: randomUserBase?.info.seed ?? "", page: pageNo)
        }
    }
    
    func didTapItem(model: User) {
        transitionDelegate?.process(transition: .showUserDetail, with: model)
    }
}
