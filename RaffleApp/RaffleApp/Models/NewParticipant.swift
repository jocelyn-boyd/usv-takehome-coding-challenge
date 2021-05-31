//
//  RegisterParticipant.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation

struct NewParticipant: Encodable {
	let first_name: String
	let last_name: String
	let email: String
	let phone: String?
	
	private enum CodingKeys: String, CodingKey {
		case first_name = "firstname"
		case last_name = "lastname"
		case email
		case phone
	}
}
