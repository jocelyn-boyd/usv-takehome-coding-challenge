//
//  NewRaffleCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class NewRaffleCell: UITableViewCell {
	
	static let reuseIdentifier = String(describing: NewRaffleCell.self)
	@IBOutlet private var newRaffleLabel: UILabel!
	@IBOutlet private var raffleNameLabel: UILabel!
	@IBOutlet private var raffleNameTextField: UITextField!
	@IBOutlet private var raffleSecretTokenLabel: UILabel!
	@IBOutlet private var secretTokenTextField: UITextField!
	@IBOutlet private var secretTokenInstructionLabel: UILabel!
	@IBOutlet private var allRafflesLabel: UILabel!
	
	override func awakeFromNib() {
			super.awakeFromNib()
			// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
			super.setSelected(selected, animated: animated)

			// Configure the view for the selected state
	}
	
	@IBAction private func generateSecretToken(_ sender: UIButton) {
		
	}
	
	@IBAction private func createNewProfile(_ sender: UIButton) {
		
	}
	
}
