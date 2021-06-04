//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesListViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private var raffleSearchBar: UISearchBar!
	@IBOutlet private var allRafflesTableView: UITableView!
	
	// MARK: - Properties
	
	var allRaffles = [AllRaffles]() {
		didSet {
			allRafflesTableView.reloadData()
		}
	}
	
	var raffleSearchString: String? = nil {
		didSet {
			allRafflesTableView.reloadData()
		}
	}
	
	var raffleSearchResults = [AllRaffles]()
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureDelegates()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// refreshes tableview data
		super.viewWillAppear(animated)
		loadAllRafflesData()
	}
	
	// MARK: - Private Methods
	
	private func configureDelegates() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
		raffleSearchBar.delegate = self
	}
	
	private func loadAllRafflesData() {
		RaffleAPIClient.manager.getAllRaffles { result in
			DispatchQueue.main.async { [weak self] in
				switch result {
				case let .success(raffles):
					self?.allRaffles = raffles // .sorted() { $0.id > $1.id }
				case let .failure(error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	// MARK: - Segue Methods
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { fatalError("No identifier on segue") }
		switch segueIdentifier {
		case "raffleDetailSegue":
			guard let raffleDetailVC = segue.destination as? RaffleDetailsParticpantListViewController else {
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

// MARK: - TableView Data Source & Delegate Extensions

extension AllRafflesListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allRaffles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleCell", for: indexPath) as? RaffleCell else { return UITableViewCell() }
		let raffle = allRaffles[indexPath.row]
		cell.raffleTitleLabel.text = "\(raffle.name)"
		cell.dateCreatedLabel.text = "Created: \(String(describing: raffle.dateCreated))"
		cell.winnerIdLabel.text = raffle.winner_id != nil ? "Winner Id: \(String(describing: raffle.winner_id!)) 🎉" : "No winner yet!"
		cell.dateOfRaffleLabel.text = raffle.raffled_at != nil ? "Closed: \(String(describing: raffle.dateRaffled!))" : "Click on raffle to register!"
		return cell
	}
}

extension AllRafflesListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		raffleSearchString = searchBar.text
//		print(raffleSearchString)
	}
}
