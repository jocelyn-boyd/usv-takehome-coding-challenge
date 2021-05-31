//
//  ParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleDetailViewController: UIViewController {
	// MARK: - Internal Properties
	
	var raffle: Raffle!
	var participantList = [Participant]() {
		didSet {
			allParticipantsTableView.reloadData()
		}
	}
	
	// MARK: - IBOutlets
	
	@IBOutlet private var allParticipantsTableView: UITableView!
	@IBOutlet weak var participantCountLabel: UILabel!
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		configureViewController()
		loadAllRaffleParticipants()
	}
	
	// MARK: - IBActions
	
	@IBAction private func registerParticipantButton(_ sender: UIButton) {
		print("register button pressed")
	}
	
	@IBAction private func pickAWinnerButton(_ sender: Any) {
		print("pick winner button pressed")
	}
	
	// MARK: - Private Methods
	
	private func configureViewController() {
		allParticipantsTableView.delegate = self
		allParticipantsTableView.dataSource = self
		navigationItem.title = "\(raffle.name)"
		// MARK: - BUG: load the total number of raffle participants
		participantCountLabel.text = "Total Participants: \(participantList.count)"
		print(participantList.count)
	}
	
	private func loadAllRaffleParticipants() {
		let id = raffle.raffle_id
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
}

// MARK: - Extensions

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
