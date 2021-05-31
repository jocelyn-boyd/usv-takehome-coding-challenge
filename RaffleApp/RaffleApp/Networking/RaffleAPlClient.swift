//
//  RaffleAPlClient.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation
struct RaffleAPIClient {
	
	// MARK: - Static Properties
	
	static let manager = RaffleAPIClient()
	
	// MARK: - Private Properties and Initializers
	private let rootEndpoint = "https://raffle-fs-app.herokuapp.com"
	
	
 var raffleURL: URL {
	 guard let url = URL(string: rootEndpoint + "/api/raffles") else {
		 fatalError("Error: Invalid URL")
	 }
	 return url
 }
	
	private init() {}
	
	// MARK: - Internal Methods
	
	func getAllRaffles(completionHandler: @escaping (Result<[Raffle], AppError>) -> Void) {
		NetworkHelper.manager.performDataTask(withUrl: raffleURL, andMethod: .get) { result in
			switch result {
			case let .failure(error):
				completionHandler(.failure(error))
				return
			case let .success(data):
				do {
					let raffles = try Raffle.getAllRaffles(from: data)
					completionHandler(.success(raffles))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	func getAllRaffleParticipants(with raffle_id: Int, completionHandler: @escaping (Result<[Participant], AppError>) -> Void) {
		
		var raffleParticipantURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)/participants") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		
		NetworkHelper.manager.performDataTask(withUrl: raffleParticipantURL, andMethod: .get) { result in
			switch result {
			case let .failure(error):
				completionHandler(.failure(error))
				return
			case let .success(data):
				do {
					let participants = try Participant.getAllParticipants(from: data)
					completionHandler(.success(participants))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	
	func postNewRaffle(_ raffle: NewRaffle, completionHandler: @escaping (Result<Data, AppError>) -> Void) {
		guard let encodedRaffleData = try? JSONEncoder().encode(raffle) else {
			fatalError("Unable to json encode project")
		}
		print(String(data: encodedRaffleData, encoding: .utf8)!)
		NetworkHelper.manager.performDataTask(withUrl: raffleURL,
																					andHTTPBody: encodedRaffleData,
																					andMethod: .post,
																					completionHandler: { result in
																						switch result {
																						case let .success(data):
																							completionHandler(.success(data))
																						case let .failure(error):
																							completionHandler(.failure(error))
																						}
																					})
	}
}
