//
//  HelpScene.swift
//  TheBall
//
//  Created by Miłosz on 5/2/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import UIKit
import SpriteKit

class HelpScene: SKScene {

	override func didMove(to view: SKView) {
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(gotoMenu))
		swipeUp.direction = .up
		self.view?.addGestureRecognizer(swipeUp)
	}
	
	@objc func gotoMenu() {
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		let scene = SKScene(fileNamed: "MenuScene")!
		self.view?.presentScene(scene, transition: reveal)
	}
	
}
