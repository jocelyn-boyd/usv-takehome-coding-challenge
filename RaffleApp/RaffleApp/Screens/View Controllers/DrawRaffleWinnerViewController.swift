//
//  PickAWinnerViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class DrawRaffleWinnerViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet weak var secretTokenTextField: UITextField!
	
	// MARK: - Internal Properties
	
	var raffle: AllRaffles!
	var secret_token = String()
	var winner_id = Int()
	
	private var validateTextFields: (String)? {
		guard let secret_token = secretTokenTextField.text, !secret_token.isEmpty else {
			let alertTitle = "Required"
			let alertMessage = "Please enter secret token"
			displayAlert(title: alertTitle, message: alertMessage)
			return nil
		}
		return (secret_token)
	}
	
	// MARK: - Lifecyle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	// MARK: - IBActions
	
	@IBAction private func drawRaffleWinnerButton(_ sender: UIButton) {
		guard let _ = validateTextFields else { return }
		
		// MARK: - TODO: Draw a random winner from the list if participants
		// if raffle details winner is nil, then draw random winner
		// drawRaffleWinnerFromParticipants()
		// if raffle details winner is NOT nil, then fetch raffle winner
		 getRaffleWinner()
	}
	
	// MARK: - Private Methods
	
	private func getRaffleDetails() {
		RaffleAPIClient.manager.getRaffleDetails(with: raffle.id) { [weak self] result in
			switch result {
			case let .success(details):
				self?.secret_token = details.secret_token
				self?.winner_id = details.winner_id!
			case let .failure(error):
				print(error)
			}
		}
	}
	
	private func drawRaffleWinnerFromParticipants() {
		// MARK: - TODO: write function code
	}
	
	private func getRaffleWinner() {
		RaffleAPIClient.manager.getRaffleWinner(with: raffle.id) { [weak self] result in
			switch result {
			case .success:
				if self?.secretTokenTextField.text == self?.secret_token {
					print("Success! Raffle winner retrived!")
				}
			case let .failure(error):
				self?.displayTokenValidationFailureAlert(with: error)
			}
		}
	}
	
	private func displayTokenValidationFailureAlert(with error: Error) {
		displayAlert(title: "Error: Could not validate secret token", message: error.localizedDescription)
	}
	
	private func displayInvalidTokenAlert() {
		displayAlert(title: "Invalid Token", message: "Please enter valid token")
	}
	
	private func displayAlert(title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
}
