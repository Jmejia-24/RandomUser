//
//  Dob.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import Foundation
struct Dob: Codable {
	let date: String?
	let age: Int?

	enum CodingKeys: String, CodingKey {
		case date = "date"
		case age = "age"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		age = try values.decodeIfPresent(Int.self, forKey: .age)
	}
}
