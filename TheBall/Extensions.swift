//
//  Extensions.swift
//  Motors
//
//  Created by Miłosz on 12/3/18.
//  Copyright © 2018 Miłosz. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
	}
	
	convenience init(rgb: Int) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF,
			alpha: 1.0
		)
	}
	
	convenience init(rgb: Int, alpha: Double) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF,
			alpha: alpha
		)
	}
}




extension Date {
	var yearsFromNow:   Int { return Calendar.current.dateComponents([.year],       from: self, to: Date()).year        ?? 0 }
	var monthsFromNow:  Int { return Calendar.current.dateComponents([.month],      from: self, to: Date()).month       ?? 0 }
	var weeksFromNow:   Int { return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear  ?? 0 }
	var daysFromNow:    Int { return Calendar.current.dateComponents([.day],        from: self, to: Date()).day         ?? 0 }
	var hoursFromNow:   Int { return Calendar.current.dateComponents([.hour],       from: self, to: Date()).hour        ?? 0 }
	var minutesFromNow: Int { return Calendar.current.dateComponents([.minute],     from: self, to: Date()).minute      ?? 0 }
	var secondsFromNow: Int { return Calendar.current.dateComponents([.second],     from: self, to: Date()).second      ?? 0 }
	
	var relativeTime: String {
		if yearsFromNow	  > 10 { return "Never"}
		if yearsFromNow   > 0 { return "\(yearsFromNow) year"    + (yearsFromNow    > 1 ? "s" : "") + " ago" }
		if monthsFromNow  > 0 { return "\(monthsFromNow) month"  + (monthsFromNow   > 1 ? "s" : "") + " ago" }
		if weeksFromNow   > 0 { return "\(weeksFromNow) week"    + (weeksFromNow    > 1 ? "s" : "") + " ago" }
		if daysFromNow    > 0 { return daysFromNow == 1 ? "Yesterday" : "\(daysFromNow) days ago" }
		if hoursFromNow   > 0 { return "\(hoursFromNow) hour"     + (hoursFromNow   > 1 ? "s" : "") + " ago" }
		if minutesFromNow > 0 { return "\(minutesFromNow) minute" + (minutesFromNow > 1 ? "s" : "") + " ago" }
		if secondsFromNow > 0 { return secondsFromNow < 15 ? "Just now"	: "\(secondsFromNow) second" + (secondsFromNow > 1 ? "s" : "") + " ago" }
		return ""
	}
}





extension UINavigationController {
	func pushToViewController(_ viewController: UIViewController, animated:Bool = true, completion: @escaping ()->()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		self.pushViewController(viewController, animated: animated)
		CATransaction.commit()
	}
	
	func popViewController(animated:Bool = true, completion: @escaping ()->()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		self.popViewController(animated: true)
		CATransaction.commit()
	}
	
	
	func popToViewController(ofClass: AnyClass, animated: Bool = true) {
		if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
			popToViewController(vc, animated: animated)
		}
	}
	
	func popViewControllers(viewsToPop: Int, animated: Bool = true) {
		if viewControllers.count > viewsToPop {
			let vc = viewControllers[viewControllers.count - viewsToPop - 1]
			popToViewController(vc, animated: animated)
		}
	}
		
	
	
}




