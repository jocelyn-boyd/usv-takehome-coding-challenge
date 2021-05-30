//
//  ParticipantViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/29/21.
//

import UIKit

class ParticipantListViewController: UIViewController {
	
	@IBOutlet private var participantTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
			participantTableView.delegate = self
			participantTableView.dataSource = self
    }
    

	@IBAction private func registerParticipantButton(_ sender: UIButton) {
		print("register button pressed")
	}
	
	
	@IBAction private func pickAWinnerButton(_ sender: Any) {
		print("pick winner button pressed")
	}

}

extension ParticipantListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		6
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as? ParticipantCell else { return UITableViewCell() }
		cell.participantNameLabel.text = "Participant Name"
		cell.participantIdLabel.text = "Participant Id: \(indexPath.row + 1)"
		cell.participantEmailLabel.text = "participant@email.com"
		cell.participantPhoneNumberLabel.text = "123-456-7890"
		return cell
	}
	
	
}
