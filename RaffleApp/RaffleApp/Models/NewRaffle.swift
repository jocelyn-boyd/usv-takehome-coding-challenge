//
//  NewRaffle.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation

struct NewRaffle: Encodable {
	let name: String
	let secret_token: String
	
	static func generateRandomString(length: Int = 6) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}
