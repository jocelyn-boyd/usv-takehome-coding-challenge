//
//  RaffleAPlClient.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import Foundation
import Combine
struct RaffleAPIClient {
	
	// MARK: - Static Properties
	
	static let manager = RaffleAPIClient()
	
	// MARK: - Private Properties and Initializers
	private let rootEndpoint = "https://raffle-fs-app.herokuapp.com"
	public let allRaffles = CurrentValueSubject<Result<[AllRaffles], AppError>?,Never>(nil)
	
	
	var raffleURL: URL {
		guard let url = URL(string: rootEndpoint + "/api/raffles") else {
			fatalError("Error: Invalid URL")
		}
		return url
	}
	
	private init() {}
	
	func refreshAllRaffles() {
		getAllRaffles { result in
			allRaffles.value = result
		}
	}
	
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
	
	func getRaffleWinnerInfo(with raffle_id: Int, completionHandler: @escaping (Result<RaffleWinnerInfo, AppError>) -> Void) {
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
					let winner = try RaffleWinnerInfo.getRaffleWinner(from: data)
					completionHandler(.success(winner))
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
	
	func postNewParticipant(with raffle_id: Int, participantInfo: NewParticipant, completionHandler: @escaping (Result<Data, AppError>) -> Void) {
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
	
	// MARK: PUT Requests
	func putSecretTokenToGetRaffleWinner(with raffle_id: Int, secret_token: Token, completionHandler: @escaping (Result<Data, AppError>) -> Void) {
		guard let encodedSecretTokenData = try? JSONEncoder().encode(secret_token) else {
			fatalError("Unable to json encode project")
		}
		var drawRaffleWinnerURL: URL {
			guard let url = URL(string: rootEndpoint + "/api/raffles/\(raffle_id)/winner") else {
				fatalError("Error: Invalid URL")
			}
			return url
		}
		print(String(data: encodedSecretTokenData, encoding: .utf8)!)
		NetworkHelper.manager.performDataTask(withUrl: drawRaffleWinnerURL,
																					andHTTPBody: encodedSecretTokenData,
																					andMethod: .put,
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
