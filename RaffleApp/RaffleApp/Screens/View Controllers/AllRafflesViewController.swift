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
		loadAllRafflesData()
	}
		
	private func configureTableView() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
	private func loadAllRafflesData() {
		RaffleAPIClient.manager.getAllRaffles { result in
			DispatchQueue.main.async { [weak self] in
				switch result {
				case let .success(raffles):
					self?.raffles = raffles.sorted() { $0.dateCreated > $1.dateCreated }
				case let .failure(error):
					print(error.localizedDescription)
				}
			}
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

