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
	
	// MARK: - GET Requests
	
	func getAllRaffles(completionHandler: @escaping (Result<[AllRaffles], AppError>) -> Void) {
		NetworkHelper.manager.performDataTask(withUrl: raffleURL, andMethod: .get) { result in
			switch result {
			case let .failure(error):
				completionHandler(.failure(error))
				return
			case let .success(data):
				do {
					let raffles = try AllRaffles.getAllRaffles(from: data)
					completionHandler(.success(raffles))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	func getAllRaffleParticipants(with raffle_id: Int, completionHandler: @escaping (Result<[RegisteredParticipant], AppError>) -> Void) {
		
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
					let participants = try RegisteredParticipant.getAllParticipants(from: data)
					completionHandler(.success(participants))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	func getRaffleWinner(with raffle_id: Int, completionHandler: @escaping (Result<RaffleWinner, AppError>) -> Void) {
		
		var raffleWinnerURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)/winner") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		
		NetworkHelper.manager.performDataTask(withUrl: raffleWinnerURL, andMethod: .get) { result in
			switch result {
			case let .failure(error):
				completionHandler(.failure(error))
				return
			case let .success(data):
				do {
					let winner = try RaffleWinner.getRaffleWinner(from: data)
					completionHandler(.success(winner))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	func getRaffleDetails(with raffle_id: Int, completionHandler: @escaping (Result<RaffleDetails, AppError>) -> Void) {
		
		var raffleDetailsURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		
		NetworkHelper.manager.performDataTask(withUrl: raffleDetailsURL, andMethod: .get) { result in
			switch result {
			case let .failure(error):
				completionHandler(.failure(error))
				return
			case let .success(data):
				do {
					let details = try RaffleDetails.getRaffleDetails(from: data)
					completionHandler(.success(details))
				}
				catch {
					completionHandler(.failure(.couldNotParseJSON(rawError: error)))
				}
			}
		}
	}
	
	// MARK: - POST Requests
	
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
	
	func registerNewParticipant(with raffle_id: Int, participantInfo: NewParticipant, completionHandler: @escaping (Result<Data, AppError>) -> Void) {
		guard let encodedParticipantData = try? JSONEncoder().encode(participantInfo) else {
			fatalError("Unable to json encode project")
		}
		var raffleParticipantURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)/participants") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		print(String(data: encodedParticipantData, encoding: .utf8)!)
		NetworkHelper.manager.performDataTask(withUrl: raffleParticipantURL,
																					andHTTPBody: encodedParticipantData,
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
	
	// MARK: - TODO: Pick a winner from the participants at random for a raffle
	func drawRaffleWinner(with raffle_id: Int, raffleInfo: RaffleDetails, completionHandler: @escaping (Result<Data, AppError>) -> Void) {
		guard let encodedParticipantData = try? JSONEncoder().encode(raffleInfo) else {
			fatalError("Unable to json encode project")
		}
		var raffleWinnerURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)/winner") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		print(String(data: encodedParticipantData, encoding: .utf8)!)
		NetworkHelper.manager.performDataTask(withUrl: raffleWinnerURL,
																					andHTTPBody: encodedParticipantData,
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
