//
//  RaffleWinnerViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleWinnerInfoViewController: UIViewController {

	// MARK: - IBOutlers
	
	@IBOutlet weak var participantNameLabel: UILabel!
	@IBOutlet weak var dateRegisteredLabel: UILabel!
	@IBOutlet weak var participantIdLabel: UILabel!
	@IBOutlet weak var participantEmailLabel: UILabel!
	@IBOutlet weak var participantPhoneNumberLabel: UILabel!
	
	// MARK: - Properties
	var raffles: AllRaffles!
	
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadWinnerInformation()
	}
	
	// MARK: Private Methods
	
	func loadWinnerInformation() {
		RaffleAPIClient.manager.getRaffleWinnerInfo(with: raffles.id) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case let .success(details):
					self?.participantNameLabel.text = "\(details.first_name) \(details.last_name)"
					self?.dateRegisteredLabel.text = "Registered: \(details.dateRegistered)"
					self?.participantIdLabel.text = "\(details.participant_id)"
					self?.participantEmailLabel.text = "\(details.email)"
					self?.participantPhoneNumberLabel.text = details.phone != nil ? "\(String(describing: details.phone))" : "Not Available"
				case let .failure(error):
					print(error.localizedDescription) // There is no winner yet.
				}
			}
		}
	}
}
