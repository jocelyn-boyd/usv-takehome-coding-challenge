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

struct AllRaffles: Codable {
	let id: Int
	let name: String
	let created_at: String
	let raffled_at: String?
	let winner_id: Int?
	
	var dateCreated: String  {
		let dateCreatedString = created_at
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		let date = dateFormatter.date(from: dateCreatedString)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	var dateRaffled: String? {
		let dateCreatedString = raffled_at
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		let date = dateFormatter.date(from: dateCreatedString!)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	static func getAllRaffles(from jsonData: Data) throws -> [AllRaffles] {
		do {
			let raffles = try JSONDecoder().decode([AllRaffles].self, from: jsonData)
			return raffles
		} catch {
			throw JSONError.decodingError(error)
		}
	}
}
