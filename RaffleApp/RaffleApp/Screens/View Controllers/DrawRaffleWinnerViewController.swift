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
	
	private var secretTokenTextFieldIsFilled: (String)? {
		guard let secret_token = secretTokenTextField.text, !secret_token.isEmpty else {
			let alertTitle = "Required"
			let alertMessage = "Please input secret token"
			displayAlert(title: alertTitle, message: alertMessage)
			return nil
		}
		return (secret_token)
	}
	
	// MARK: - Lifecyle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadRaffleSecretToken()
	}

	// MARK: - IBActions
	
	@IBAction private func drawRaffleWinnerButton(_ sender: UIButton) {
		// 1. Check if secret token textfield is empty
		guard let _ = secretTokenTextFieldIsFilled else { return }
		
		// 2. Check if input matches the secret token created at time of raffle
		guard secretTokenTextField.text == secret_token else {
			displayInvalidTokenAlert()
			return
		}
	
		loadRaffleWinnerFromParticipantList()
	}
	
	// MARK: - Private Methods
	
	private func encodeInputTokenFromSecretTokenTextfield() -> Token? {
		guard let encodedInputToken = secretTokenTextField.text else {
			return nil
		}
		return Token(secret_token: encodedInputToken)
	}

	
	// MARK: - Networking Methods
	
	private func loadRaffleSecretToken() {
		RaffleAPIClient.manager.getRaffleDetails(with: raffle.id) { [weak self] result in
			switch result {
			case let .success(details):
				self?.secret_token = details.secret_token
			case let .failure(error):
				print(error)
			}
		}
	}
	
	private func loadRaffleWinnerFromParticipantList() {
		guard let token = encodeInputTokenFromSecretTokenTextfield() else {
			displayInvalidTokenAlert()
			return
		}
		
		RaffleAPIClient.manager.putSecretTokenToGetRaffleWinner(with: raffle.id, secret_token: token) { [weak self] result in
			DispatchQueue.main.async { [self] in
				switch result {
				case .success:
					self?.displaySuccessAlert()
					RaffleAPIClient.manager.refreshAllRaffles()
				case let .failure(error):
					print(error.localizedDescription)
				}
			}
		}
	}
	
	// MARK: Alert Methods
	private func displaySuccessAlert() {
		let alertVC = UIAlertController(title: "Success! ✅", message: "A winner has been chosen!", preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			self.navigationController?.popToRootViewController(animated: true)
		}))
		present(alertVC, animated: true, completion: nil)
		
	}
	
	private func displayInvalidTokenAlert() {
		displayAlert(title: "Invalid Token ❌", message: "Please enter valid token")
	}
	
	private func displayAlert(title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
}
