//
//  AllRafflesCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesCell: UITableViewCell {
	
	@IBOutlet private var raffleTitleLabel: UILabel!
	@IBOutlet private var dateRaffleCreatedLabel: UILabel!
	@IBOutlet private var winnerIdLabel: UILabel!
	@IBOutlet private var dateOfRaffleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
