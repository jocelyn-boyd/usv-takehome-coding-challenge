//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesViewController: UIViewController {
	
	@IBOutlet private var allRafflesTableView: UITableView!
	
	var raffles = [Raffle]() {
		didSet {
			allRafflesTableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		configureTableView()
		loadData()
	}
	
	private func configureTableView() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
	private func loadData() {
		guard let pathToData = Bundle.main.path(forResource: "AllRafflesSample", ofType: "json") else {
			fatalError("AllRafflesSample.json file not found")
		}
		let internalUrl = URL(fileURLWithPath: pathToData)
		do {
			let data = try Data(contentsOf: internalUrl)
			let rafflesFromJSON = try Raffle.getAllRaffles(from: data)
			raffles = rafflesFromJSON
		}
		catch {
			print(error)
		}
	}
	
}

extension AllRafflesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return raffles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleCell", for: indexPath) as? RaffleCell else { return UITableViewCell() }
		let raffle = raffles[indexPath.row]
		cell.raffleTitleLabel.text = raffle.name
		cell.dateCreatedLabel.text = "Created: \(String(describing: raffle.dateCreated))"
		cell.winnerIdLabel.text = raffle.winnerId != nil ? "Winner Id: \(Int.random(in: 1...100)) 🎉" : "No winner yet!"
		cell.dateOfRaffleLabel.text = raffle.raffledAt != nil ? "Closed: \(String(describing: raffle.dateRaffled!))" : "Click on raffle to register!"
		return cell
	}
}

