//
//  RaffleCell.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class RaffleCell: UITableViewCell {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var raffleView: UIView!
	@IBOutlet weak var raffleTitleLabel: UILabel!
	@IBOutlet weak var dateCreatedLabel: UILabel!
	@IBOutlet weak var winnerIdLabel: UILabel!
	@IBOutlet weak var dateOfRaffleLabel: UILabel!
	@IBOutlet weak var raffleWinnerImage: UIImageView!
	@IBOutlet weak var closedRaffleImage: UIImageView!
	@IBOutlet weak var raffleCellBackgroundView: UIView!
	
	// MARK: - Initializers
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	// MARK: - Methods
	func configureRaffleCell(with raffleData: AllRaffles) {
		raffleTitleLabel.text = "\(raffleData.name)"
		dateCreatedLabel.text = "Created: \(String(describing: raffleData.dateCreated))"

		if raffleData.raffled_at != nil {
			winnerIdLabel.text = "Winner Id: \(String(describing: raffleData.winner_id!)) 🎉"
			raffleWinnerImage.image = UIImage(systemName: "person.fill.checkmark")
			dateOfRaffleLabel.text = "Closed: \(String(describing: raffleData.dateRaffled!))"
			dateOfRaffleLabel.textColor = .systemRed
			closedRaffleImage.image = UIImage(systemName: "checkmark.seal.fill")
		} else {
			winnerIdLabel.text = "No winner yet!"
			raffleWinnerImage.image = UIImage(systemName: "person.fill.xmark")
			dateOfRaffleLabel.text = "Click on raffle to register!"
			dateOfRaffleLabel.textColor = .systemGreen
			closedRaffleImage.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
		}
	}
}
