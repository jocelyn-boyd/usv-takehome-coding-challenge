//
//  ViewController.swift
//  RaffleApp
//
//  Created by Jocelyn Boyd on 5/28/21.
//

import UIKit

class AllRafflesViewController: UIViewController {
	
	@IBOutlet private var allRafflesTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		allRafflesTableView.delegate = self
		allRafflesTableView.dataSource = self
	}
	
}

extension AllRafflesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RaffleCell", for: indexPath) as? RaffleCell else { return UITableViewCell() }
		cell.raffleTitleLabel.text = "Raffle Name"
		cell.dateCreatedLabel.text = "Date Created: \(Date())"
		cell.winnerIdLabel.text = "Winner Id: \(Int.random(in: 1...100))"
		cell.dateOfRaffleLabel.text = "Winner picked: \(Date())"
		return cell
	}
	
	
}

