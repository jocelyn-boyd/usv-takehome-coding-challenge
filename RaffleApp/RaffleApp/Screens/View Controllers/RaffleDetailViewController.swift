//
//  ParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleDetailViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private var allParticipantsTableView: UITableView!
	@IBOutlet weak var participantCountLabel: UILabel!
	@IBOutlet weak var registrationButton: UIButton!
	@IBOutlet weak var drawWinnerButton: UIButton!
	
	// MARK: - Internal Properties
	
	var raffle: AllRaffles!
	var participantList = [RegisteredParticipant]() {
		didSet {
			allParticipantsTableView.reloadData()
		}
	}
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setTableViewDelegatesAndDataSource()
		setNavigationTitleToRaffleName()
		loadAllRaffleParticipants()
		loadTotalNumberOfParticipants()
	}
		
	// MARK: - Private Methods
	
	private func setTableViewDelegatesAndDataSource() {
		allParticipantsTableView.delegate = self
		allParticipantsTableView.dataSource = self
	}
	
	private func setNavigationTitleToRaffleName() {
		navigationItem.title = "\(raffle.name)"
		
	}
	
	private func loadTotalNumberOfParticipants() {
		// MARK: - BUG: load the total number of raffle participants
		// participantCountLabel.text = "Total Participants: \(participantList.count)"
		// print(participantList.count)
	}
	
	private func loadAllRaffleParticipants() {
		let id = raffle.id
		RaffleAPIClient.manager.getAllRaffleParticipants(with: id) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case let .success(participantsFromJSON):
					self?.participantList = participantsFromJSON
				case let .failure(error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	private func displayAlert(title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
	
	// MARK: - Segue Methods
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueIdentifier = segue.identifier else { fatalError("No identifier on segue") }
		switch segueIdentifier {
		case "registerNewParticipantSegue":
			guard let registrationVC = segue.destination as? RegisterNewParticipantViewController else {
				fatalError("Unexpected segue VC")
			}
			registrationVC.raffle = raffle
		case "drawWinnerSegue":
			guard let drawWinnerVC = segue.destination as? DrawRaffleWinnerViewController else {
				fatalError("Unexpected segue VC")
			}
			drawWinnerVC.raffle = raffle
		case "winnerInfoSegue":
			guard let winnerInfo = segue.destination as? RaffleWinnerInfoViewController else {
				fatalError("Unexpected segue VC")
			}
			winnerInfo.raffles = raffle
		default:
			fatalError("Unexpected segue identifier")
		}
	}
	
}

// MARK: - TableView Data Source & Delegate Extensions

extension RaffleDetailViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return participantList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as? ParticipantCell else { return UITableViewCell() }
		let participant = participantList[indexPath.row]
		cell.participantNameLabel.text = "\(participant.first_name) \(participant.last_name)"
		cell.participantIdLabel.text = "\(participant.participant_id)"
		cell.participantEmailLabel.text = "\(participant.email)"
		cell.participantPhoneNumberLabel.text = participant.phone != nil ? "\(participant.phone!)" : "Not Available"
		return cell
	}
}
