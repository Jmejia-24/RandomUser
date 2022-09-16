//
//  Info.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/15/22.
//

import Foundation

struct Info: Codable {
	let seed: String?
	let results: Int?
	let page: Int?
	let version: String?

	enum CodingKeys: String, CodingKey {
		case seed = "seed"
		case results = "results"
		case page = "page"
		case version = "version"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		seed = try values.decodeIfPresent(String.self, forKey: .seed)
		results = try values.decodeIfPresent(Int.self, forKey: .results)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		version = try values.decodeIfPresent(String.self, forKey: .version)
	}
}