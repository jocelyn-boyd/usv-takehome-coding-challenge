//
//  PickAWinnerViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class PickWinnerViewController: UIViewController {

	@IBOutlet weak var secretTokenTextView: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	@IBAction private func pickWinnerButton(_ sender: UIButton) {
		print("winner button pressed")
	}
}
