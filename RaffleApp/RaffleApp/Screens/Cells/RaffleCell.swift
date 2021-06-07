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
		dateCreatedLabel.text = "Created: \(raffleData.dateCreated)"
		
		if raffleData.raffled_at != nil { // if there is a winner
			winnerIdLabel.text = "Winner Id: \(String(describing: raffleData.winner_id!)) 🎉"
			winnerIdLabel.textColor = .systemGreen
			raffleWinnerImage.image = UIImage(systemName: "person.fill.checkmark")
			raffleWinnerImage.tintColor = .systemGreen
			
			dateOfRaffleLabel.text = "Closed: \(String(describing: raffleData.dateRaffled!))"
			dateOfRaffleLabel.textColor = .systemRed
			closedRaffleImage.image = UIImage(systemName: "checkmark.seal.fill")!.withTintColor(UIColor.systemRed)
			closedRaffleImage.tintColor = .systemRed
		}
		else if raffleData.raffled_at == nil { // if there is no winner
			winnerIdLabel.text = "No winner yet!"
			winnerIdLabel.textColor = .systemGray
			raffleWinnerImage.image = UIImage(systemName: "person.fill.xmark")
			raffleWinnerImage.tintColor = .systemGray
			
			dateOfRaffleLabel.text = "Click on raffle to register!"
			dateOfRaffleLabel.textColor = .systemGreen
			closedRaffleImage.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
			closedRaffleImage.tintColor = .systemGreen
		}
	}
}
