//
//  RaffleDetails.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/31/21.
//

import Foundation

struct RaffleDetails: Codable {
	let id: Int
	let name: String
	let secret_token: String
	let created_at: String
	let raffled_at: String?
	let winner_id: Int?
	
	static func getRaffleDetails(from jsonData: Data) throws -> RaffleDetails {
		do {
			let details = try JSONDecoder().decode(RaffleDetails.self, from: jsonData)
			return details
		} catch {
			throw JSONError.decodingError(error)
		}
	}
}
