//
//  RaffleCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleCell: UITableViewCell {
	
	@IBOutlet weak var raffleView: UIView!
	@IBOutlet weak var raffleTitleLabel: UILabel!
	@IBOutlet weak var dateCreatedLabel: UILabel!
	@IBOutlet weak var winnerIdLabel: UILabel!
	@IBOutlet weak var dateOfRaffleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
