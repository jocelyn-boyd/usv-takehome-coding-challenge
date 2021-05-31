//
//  RegisterParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RegisterParticipantViewController: UIViewController {
	// MARK: - IBOutlets
	
	@IBOutlet weak var firstNameTextView: UITextField!
	@IBOutlet weak var lastNameTextView: UITextField!
	@IBOutlet weak var emailTextView: UITextField!
	@IBOutlet weak var phoneNumberTextView: UITextField!
	
	// MARK: Lifecycle Methods
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	// MARK: - IBActions
	
	@IBAction private func submitFormButton(_ sender: UIButton) {
		print("submit button pressed")
	}
	
	@IBAction private func clearFormButton(_ sender: UIButton) {
		print("clear button pressed")
	}
}
