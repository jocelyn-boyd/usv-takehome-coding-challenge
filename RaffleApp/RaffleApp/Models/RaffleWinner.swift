//
//  RaffleWinner.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/31/21.
//

import Foundation

struct RaffleWinner: Codable {
	let participant_id: Int
	let raffle_id: Int
	let first_name: String
	let last_name: String
	let email: String
	let phone: String?
	let registered_at: String

	private enum CodingKeys: String, CodingKey {
		case participant_id = "id"
		case raffle_id
		case first_name = "firstname"
		case last_name = "lastname"
		case email
		case phone
		case registered_at
	}
	
	var dateRegistered: String  {
		let dateRegistered = registered_at

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		let date = dateFormatter.date(from: dateRegistered)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	static func getRaffleWinner(from jsonData: Data) throws -> RaffleWinner {
		do {
			let winner = try JSONDecoder().decode(RaffleWinner.self, from: jsonData)
			return winner
		} catch {
			throw JSONError.decodingError(error)
		}
	}
	
}
