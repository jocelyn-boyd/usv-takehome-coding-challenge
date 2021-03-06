//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//
/*
- create a variable to hold the new array
- write a function and call that function in the success
- input: [AllRaffles], output: open allraffles on top, closed all raffles on the bottom
-  logic:
	

*/

import UIKit
import Combine

class AllRafflesListViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private weak var allRafflesTableView: UITableView!
	
	// MARK: - Properties
	
	private var allRaffles = [AllRaffles]() {
		didSet {
			allRafflesTableView.reloadData()
			//navigationItem.title = "All Raffles (\(allRaffles.count))"
		}
	}
	private var refreshControl: UIRefreshControl?
	private var allRafflesSubscription: AnyCancellable?

	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		refreshTableView()
		subscribeToAllRaffles()
		loadAllRafflesData()
	}
	
	// MARK: - Private Methods

	private func configureTableView() {
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
	private func refreshTableView() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(loadAllRafflesData), for: .valueChanged)
		allRafflesTableView.refreshControl = refreshControl
	}
	
	private func subscribeToAllRaffles() {
		allRafflesSubscription = RaffleAPIClient.manager.allRaffles.receive(on: DispatchQueue.main).sink { [weak self] result in
			switch result {
			case let .success(raffles):	
				self?.allRaffles = raffles
			case let .failure(error):
				print(error.localizedDescription)
			case nil: // hasn't loaded yet
				break
			}
			self?.refreshControl?.endRefreshing()
		}
	}
	
	// MARK: - @objc Private Methods
	
	@objc private func loadAllRafflesData() {
		RaffleAPIClient.manager.refreshAllRaffles()
	}
	
	// MARK: - Segue Methods
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { fatalError("No identifier on segue") }
		switch segueIdentifier {
		case "raffleDetailSegue":
			guard let raffleDetailVC = segue.destination as? RaffleDetailsViewController else {
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
		cell.configureRaffleCell(with: raffle)
		return cell
	}
}
