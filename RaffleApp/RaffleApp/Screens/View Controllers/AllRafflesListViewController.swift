//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesListViewController: UIViewController {
	// MARK: - Internal Properties
	var allRaffles = [Raffle]() {
		didSet {
			allRafflesTableView.reloadData()
		}
	}
	
	// MARK: - IBOutlets
	@IBOutlet private var allRafflesTableView: UITableView!
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		configureTableView()
		loadAllRafflesData()
	}
	
	// MARK: - Private Metholds
	private func configureTableView() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
	private func loadAllRafflesData() {
		RaffleAPIClient.manager.getAllRaffles { result in
			DispatchQueue.main.async { [weak self] in
				switch result {
				case let .success(raffles):
					self?.allRaffles = raffles.sorted() { $0.dateCreated < $1.dateCreated }
				case let .failure(error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { fatalError("No identifier on segue") }
		switch segueIdentifier {
		case "raffleSegue":
			guard let raffleDetailVC = segue.destination as? RaffleDetailViewController else {
				fatalError("Unexpected segue VC")
			}
			guard let selectedIndexPath = allRafflesTableView.indexPathForSelectedRow else {
				fatalError("No row was selected")
			}
			raffleDetailVC.raffle = allRaffles[selectedIndexPath.row]
		case "createRaffleSegue":
			guard let _ = segue.destination as? CreateRaffleViewController else {
				fatalError("Unexpected segue VC")
			}
		default:
			fatalError("Unexpected segue identifier")
		}
	}
}

// MARK: - Extensions

extension AllRafflesListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allRaffles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleCell", for: indexPath) as? RaffleCell else { return UITableViewCell() }
		let raffle = allRaffles[indexPath.row]
		cell.raffleTitleLabel.text = raffle.name
		cell.dateCreatedLabel.text = "Created: \(String(describing: raffle.dateCreated))"
		cell.winnerIdLabel.text = raffle.winner_id != nil ? "Winner Id: \(Int.random(in: 1...100)) 🎉" : "No winner yet!"
		cell.dateOfRaffleLabel.text = raffle.raffled_at != nil ? "Closed: \(String(describing: raffle.dateRaffled!))" : "Click on raffle to register!"
		return cell
	}
}
