//
//  RaffleParticipant.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation

struct RegisteredParticipant: Codable {
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
		let dateRegisteredString = registered_at

		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

		let date = dateFormatter.date(from: dateRegisteredString)
		
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		let formattedDate = dateFormatter.string(from: date!)
		return "\(formattedDate)"
	}
	
	static func getAllParticipants(from jsonData: Data) throws -> [RegisteredParticipant] {
	do {
		 let raffles = try JSONDecoder().decode([RegisteredParticipant].self, from: jsonData)
		 return raffles
	 } catch {
		 throw JSONError.decodingError(error)
	 }
 }

}
