//
//  ParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleDetailsParticpantListViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private var allParticipantsTableView: UITableView!
	@IBOutlet private weak var participantCountLabel: UILabel!
	@IBOutlet private weak var registrationButton: UIButton!
	@IBOutlet private weak var drawWinnerButton: UIButton!
	@IBOutlet private weak var winnerInfoButton: UIButton!
	
	// MARK: - Internal Properties
	
	var raffle: AllRaffles!
	var winner = Int()
	var participantList = [RegisteredParticipant]() {
		didSet {
			allParticipantsTableView.reloadData()
			loadTotalNumberOfParticipants()
			configureButtons()
		}
	}
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setTableViewDelegatesAndDataSource()
		setNavigationTitleToRaffleName()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadAllRaffleParticipants()
		configureButtons()
	}
	
		
	// MARK: - Private Methods
	
	private func setTableViewDelegatesAndDataSource() {
		allParticipantsTableView.delegate = self
		allParticipantsTableView.dataSource = self
	}
	
	private func setNavigationTitleToRaffleName() {
		navigationItem.title = "\(raffle.name)"
	}
	
	private func configureButtons() {
		// MARK: - NOTE: Limit the number of participants for each raffle
		
		// if there is no winner and no participants
		if raffle.winner_id == nil && participantList.count == 0 {
			registrationButton.isHidden = false
			drawWinnerButton.isHidden = true
			winnerInfoButton.isHidden = true
		}
		// if there is no winner and less than 2 participants
		else if raffle.winner_id == nil && participantList.count < 2 {
			registrationButton.isHidden = false
			drawWinnerButton.isHidden = true
			winnerInfoButton.isHidden = true
		}
		// if there is no winner and 2 or more participants
		else if raffle.winner_id == nil && participantList.count > 2 {
			registrationButton.isHidden = false
			drawWinnerButton.isHidden = false
			winnerInfoButton.isHidden = true
		}
		// if there is a winner
		else if raffle.winner_id != nil {
			registrationButton.isHidden = true
			drawWinnerButton.isHidden = true
			winnerInfoButton.isHidden = false
		}
	}
	
	private func loadTotalNumberOfParticipants() {
		 participantCountLabel.text = "Total Participants: \(participantList.count)"
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
		case "winnerSegue":
			guard let winnerVC = segue.destination as? RaffleWinnerInfoViewController else {
				fatalError("Unexpected segue VC")
			}
			winnerVC.raffles = raffle
		default:
			fatalError("Unexpected segue identifier")
		}
	}
}

// MARK: - TableView Data Source & Delegate Extensions

extension RaffleDetailsParticpantListViewController: UITableViewDataSource, UITableViewDelegate {
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
