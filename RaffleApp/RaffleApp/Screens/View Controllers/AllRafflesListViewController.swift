//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesListViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private var allRafflesTableView: UITableView!
	
	// MARK: - Properties
	
	var allRaffles = [AllRaffles]() {
		didSet {
			allRafflesTableView.reloadData()
		}
	}
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// refreshes tableview data
		super.viewWillAppear(animated)
		loadAllRafflesData()
	}
	
	// MARK: - Private Methods
	
	private func configureTableView() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
	private func loadAllRafflesData() {
		RaffleAPIClient.manager.getAllRaffles { result in
			DispatchQueue.main.async { [weak self] in
				switch result {
				case let .success(raffles):
					self?.allRaffles = raffles.sorted() { $0.id > $1.id }
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

		if raffle.raffled_at != nil {
			cell.winnerIdLabel.text = "Winner Id: \(String(describing: raffle.winner_id!)) 🎉"
			cell.raffleWinnerImage.image = UIImage(systemName: "person.fill.checkmark")
			cell.dateOfRaffleLabel.text = "Closed: \(String(describing: raffle.dateRaffled!))"
			cell.closedRaffleImage.image = UIImage(systemName: "checkmark.seal.fill")
		} else {
			cell.winnerIdLabel.text = "No winner yet!"
			cell.raffleWinnerImage.image = UIImage(systemName: "person.fill.xmark")
			cell.dateOfRaffleLabel.text = "Click on raffle to register!"
			cell.closedRaffleImage.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
		}
		return cell
	}
}
