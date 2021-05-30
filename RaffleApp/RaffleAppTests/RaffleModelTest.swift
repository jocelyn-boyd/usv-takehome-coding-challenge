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
			print(sampleRaffles)
		} catch {
			print(error)
		}
		
		XCTAssertTrue(sampleRaffles.count != 0, "There are \(sampleRaffles.count) recipes found.")
	}
}
