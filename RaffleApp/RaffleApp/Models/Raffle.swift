//
//  Raffle.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

enum JSONError: Error {
		case decodingError(Error)
}

struct Raffle: Codable {
	let id: Int?
	let name: String
	let createdAt: String?
	let raffledAt: String?
	let winnerId: Int?
	
	var dateCreated: String  {
		let dateCreatedString = createdAt

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		let date = dateFormatter.date(from: dateCreatedString!)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	var dateRaffled: String? {
		let dateCreatedString = raffledAt

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		let date = dateFormatter.date(from: dateCreatedString!)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case createdAt = "created_at"
		case raffledAt = "raffled_at"
		case winnerId = "winner_id"
	}
	
	static func getAllRaffles(from jsonData: Data) throws -> [Raffle] {
		do {
			let raffles = try JSONDecoder().decode([Raffle].self, from: jsonData)
			return raffles
		} catch {
			throw JSONError.decodingError(error)
		}
	}
}

