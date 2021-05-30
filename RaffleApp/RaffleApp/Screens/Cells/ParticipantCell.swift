//
//  ParticipantCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class ParticipantCell: UITableViewCell {

	@IBOutlet weak var participantNameLabel: UILabel!
	@IBOutlet weak var participantIdLabel: UILabel!
	@IBOutlet weak var participantEmailLabel: UILabel!
	@IBOutlet weak var participantPhoneNumberLabel: UIStackView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
