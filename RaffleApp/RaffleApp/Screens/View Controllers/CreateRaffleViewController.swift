//
//  CreateRaffleViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class CreateRaffleViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet private weak var raffleNameTextField: UITextField!
	@IBOutlet private weak var secretTokenTextField: UITextField!
	@IBOutlet private weak var postButton: UIButton!
	
	// MARK: - Properties
	
	private var validateTextFields: (raffleName: String, token: String)? {
		guard let name = raffleNameTextField.text, !name.isEmpty,
					let token = secretTokenTextField.text, !token.isEmpty else {
			let alertTitle = "Required"
			let alertMessage = "Please fill in all fields"
			displayAlert(title: alertTitle, message: alertMessage)
			return nil
		}
		return (name, token)
	}
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - IBActions
	
	@IBAction private func generateSecretToken(_ sender: UIButton) {
		let inputString = NewRaffle.generateRandomString()
		secretTokenTextField.text = inputString
	}
	
	@IBAction private func createNewRaffle(_ sender: UIButton) {
		guard let _ = validateTextFields else { return }
		guard let raffle = createRaffleFromUserInput() else {
			displayInvalidRaffleAlert()
			return
		}
		
		RaffleAPIClient.manager.postNewRaffle(raffle) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					self?.displayPostSuccessAlert()
					RaffleAPIClient.manager.refreshAllRaffles()
				case let .failure(error):
					self?.displayPostFailureAlert(with: error)
				}
			}
		}
	}
	
	// MARK: - Private Methods
	
	private func createRaffleFromUserInput() -> NewRaffle? {
		guard let raffleName = raffleNameTextField.text,
					let secretToken = secretTokenTextField.text else {
			return nil
		}
		return NewRaffle(name: raffleName, secret_token: secretToken)
	}
	
	private func displayPostSuccessAlert() {
		let alertVC = UIAlertController(title: "Success!", message: "\(raffleNameTextField.text!) raffle posted!", preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			self.navigationController?.popToRootViewController(animated: true)
		}))
		present(alertVC, animated: true, completion: nil)
	}
	
	private func displayPostFailureAlert(with error: Error) {
		displayAlert(title: "Error posting new Raffle", message: error.localizedDescription)
	}
	
	private func displayInvalidRaffleAlert() {
		displayAlert(title: "Invalid Post", message: "Ensure you have completed fields")
	}
	
	private func displayAlert(title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
}
