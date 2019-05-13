//
//  PurchaseViewController.swift
//  TheBall
//
//  Created by Miłosz on 5/10/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {

	@IBOutlet weak var cancelButton: UIButton!
	
	
	//public static let SwiftShopping = "miloszduda.theball.newlevels"
	//private let productIdentifiers: Set<String>?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		IAPHandler.shared.fetchAvailableProducts()

		IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
			guard let strongSelf = self else { return }

			let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in		})
			alertView.addAction(action)
			strongSelf.present(alertView, animated: true, completion: nil)

//			switch(type) {
//			case .purchased:
//				break
//			case .restored:
//				break
//			case .failed:
//				break;
//			case .disabled:
//
//			}
			
		}

    }
    

	@IBAction func cancelClicked(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func purchase(_ sender: Any) {
		
		let alertView = UIAlertController(title: "Purchase", message: "Do you want to purchase new levels?", preferredStyle: .alert)
		let action = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
			IAPHandler.shared.purchaseMyProduct(index: 0)
		})
		let cancel = UIAlertAction(title: "No", style: .cancel, handler: { (alert) in
		})
		alertView.addAction(action)
		alertView.addAction(cancel)
		self.present(alertView, animated: true, completion: nil)
		
	}
	
	
}
