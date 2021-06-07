//
//  ParticipantCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class ParticipantCell: UITableViewCell {
	// MARK: - IBOulets
	
	@IBOutlet weak var participantNameLabel: UILabel!
	@IBOutlet weak var participantIdLabel: UILabel!
	@IBOutlet weak var participantEmailLabel: UILabel!
	@IBOutlet weak var participantPhoneNumberLabel: UILabel!
	
	// MARK: - Initializers
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	
	//MARK: - Private Methods
	
	func configureCell(with data: RegisteredParticipant) {
		participantNameLabel.text = "\(data.first_name) \(data.last_name)"
		participantIdLabel.text = "\(data.participant_id)"
		participantEmailLabel.text = "\(data.email)"
		participantPhoneNumberLabel.text = data.phone != nil ? "\(data.phone!)" : "Not Available"
	}
}
