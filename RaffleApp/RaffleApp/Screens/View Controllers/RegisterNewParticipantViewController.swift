//
//  RegisterParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RegisterNewParticipantViewController: UIViewController {
	// MARK: - Internal Properties
	
	var raffle: AllRaffles!
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var phoneNumberTextField: UITextField!
	
	// MARK: - Private Properties
	private var validateTextFields: (firstName: String, lastName: String, email: String)? {
		guard let firstName = firstNameTextField.text, !firstName.isEmpty,
					let lastName = lastNameTextField.text, !lastName.isEmpty,
					let email = emailTextField.text, !email.isEmpty else {
			let alertTitle = "Required"
			let alertMessage = "Please fill in your first name, last name and email."
			displayAlert(title: alertTitle, message: alertMessage)
			return nil
		}
		return (firstName, lastName, email)
	}
	
	// MARK: Lifecycle Methods
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	// MARK: - IBActions
	
	@IBAction private func submitFormButton(_ sender: UIButton) {
	guard let validCredentials = validateTextFields else { return }
		
		guard validCredentials.email.isValidEmail else {
				let alertTitle = "Error"
				let alertMessage = "Please enter a valid email"
				displayAlert(title: alertTitle, message: alertMessage)
				return
		}
		
		// MARK: - TODO: Check if email has ever been used, and create an "email already registered" alert
		// Users are only allowed to enter one raffle at a time, because the database has a UNIQUE constraint in the email field. Meaning no two users with the same email can be created. This makes it impossible for the same user say “alejo@email.com” be signed up for two raffles. You can use this as a talking point for the technical discussion as a limitation of the API and how you structure the database differently if you were creating the database/api say with fireabse to allow a user to sign up for multiple raffles.
		
		guard let participant = registerParticipantFromFields() else {
			displayIncompleteRegistrationAlert()
			return
		}
		print(participant)
		
		RaffleAPIClient.manager.postNewParticipant(with: raffle.id, participantInfo: participant) { [weak self] result in
			switch result {
			case .success:
				self?.displayRegistrationSuccessAlert()
			// MARK: TODO: Display registration alert, dismiss CreateVC when OK is pressed
			case let .failure(error):
				self?.displayRegistrationFailureAlert(with: error)
			}
		}
	}
	
	@IBAction private func clearFormButton(_ sender: UIButton) {
		firstNameTextField.text = ""
		lastNameTextField.text = ""
		emailTextField.text = ""
		phoneNumberTextField.text = ""
	}
	
	// MARK: - Private Methods
	
	private func registerParticipantFromFields() -> NewParticipant? {
		guard let firstName = firstNameTextField.text,
					let lastName = lastNameTextField.text,
					let email = emailTextField.text,
					let phone = phoneNumberTextField.text else {
			return nil
		}
		return NewParticipant(first_name: firstName, last_name: lastName, email: email, phone: phone)
	}
	
	private func displayRegistrationSuccessAlert() {
		displayAlert(title: "Success!", message: "You are registered! ✅")
	}
	
	private func displayRegistrationFailureAlert(with error: Error) {
		displayAlert(title: "Error: Unable Complete Registration", message: error.localizedDescription)
	}
	
	private func displayIncompleteRegistrationAlert() {
		displayAlert(title: "Incomplete Registration", message: "Please fill out all the required fields")
	}
	
	private func displayAlert(title: String, message: String) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alertVC, animated: true, completion: nil)
	}
}
