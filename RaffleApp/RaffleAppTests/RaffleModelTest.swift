//
//  RaffleModelTest.swift
//  RaffleAppTests
//
//  Created by Jocelyn Boyd on 5/30/21.
//

import XCTest
@testable import RaffleApp

class RaffleModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// MARK: - Get All Raffles Test
	
	private func getAllRafflesJSONData() -> Data {
		guard let pathToData = Bundle.main.path(forResource: "AllRafflesSample", ofType: "json") else {
			fatalError("AllRafflesSample.json file not found")
		}
		
		let internalUrl = URL(fileURLWithPath: pathToData)
		
		do {
			let data = try Data(contentsOf: internalUrl)
			return data
		} catch  {
			fatalError("An error occured: \(error)")
		}
	}
	
	func testLoadAllRaffles() {
		let raffleData = getAllRafflesJSONData()
		var sampleRaffles = [Raffle]()
		
		do {
			sampleRaffles = try Raffle.getAllRaffles(from: raffleData)
		} catch {
			print(error)
		}
		
		XCTAssertTrue(sampleRaffles.count != 0, "There are \(sampleRaffles.count) raffle found.")
	}
	
	// MARK: - Get all Participants Test
	
	private func getAllParticipantsJSONData() -> Data {
		guard let pathToData = Bundle.main.path(forResource: "RaffleParticipantSample", ofType: "json") else {
			fatalError("RaffleParticipantSample.json file not found")
		}
		
		let internalUrl = URL(fileURLWithPath: pathToData)
		
		do {
			let data = try Data(contentsOf: internalUrl)
			return data
		} catch  {
			fatalError("An error occured: \(error)")
		}
	}
	
	func testLoadAllParticipants() {
		let participantData = getAllParticipantsJSONData()
		var sampleParticipantList = [RegisteredParticipant]()
		
		do {
			sampleParticipantList = try RegisteredParticipant.getAllParticipants(from: participantData)
		} catch {
			print(error)
		}
		
		XCTAssertTrue(sampleParticipantList.count != 0, "There are \(sampleParticipantList.count) participants found.")
	}
	
	// MARK: - Get Raffle Winner Test
	
	private func getRaffleWinnerJSONData() -> Data {
		guard let pathToData = Bundle.main.path(forResource: "RaffleWinnerSample", ofType: "json") else {
			fatalError("RaffleWinnerSample.json file not found")
		}
		
		let internalUrl = URL(fileURLWithPath: pathToData)
		
		do {
			let data = try Data(contentsOf: internalUrl)
			return data
		} catch  {
			fatalError("An error occured: \(error)")
		}
	}
	
	func testLoadRaffleWinner() {
		let winnerData = getRaffleWinnerJSONData()
		let sampleRaffleWinner: RaffleWinner
		
		
		do {
			sampleRaffleWinner = try RaffleWinner.getRaffleWinner(from: winnerData)
		} catch {
			print(error)
		}
		// MARK: - Bug: Fix XCTAssertTrue statement
//		XCTAssertTrue(!sampleRaffleWinner.isEmpty , "The winner is \(sampleRaffleWinner.first_name).")
	}

	
}
