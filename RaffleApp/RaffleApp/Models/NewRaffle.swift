//
//  NewRaffle.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation

struct NewRaffle: Encodable {
	let name: String
	let secretToken: String
	
	private enum CodingKeys: String, CodingKey {
		case name
		case secretToken = "secret_token"
	}
	
	static func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}
