//
//  Localization.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/16/22.
//

import Foundation

protocol Localization {
    associatedtype Key
    func localizedString(_ key: Key) -> String
}
