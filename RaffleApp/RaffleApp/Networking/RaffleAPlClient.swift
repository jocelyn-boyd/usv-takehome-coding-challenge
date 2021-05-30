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
	private var raffleURL: URL {
		guard let url = URL(string: rootEndpoint + "/api/raffles") else {
			fatalError("Error: Invalid URL")
		}
		return url
	}
	
//	private var winnerURL: URL {
//		guard let url = URL(string: rootEndpoint + "/api/raffles/:id/winner")
//	}
	
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
					let projects = try Raffle.getAllRaffles(from: data)
					completionHandler(.success(projects))
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
