//
//  CreateRaffleViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class CreateRaffleViewController: UIViewController {
	
	@IBOutlet private var raffleNameTextView: UITextField!
	@IBOutlet private var secretTokenTextView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
	@IBAction private func generateSecretToken(_ sender: UIButton) {
		print("generate secret token button pressed")
	}
	
	@IBAction private func createNewRaffle(_ sender: UIButton) {
		print("create new raffle button pressed")
	}

}
