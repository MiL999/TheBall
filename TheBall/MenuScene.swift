//
//  MenuScene.swift
//  TheBall
//
//  Created by Miłosz on 4/2/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import UIKit
import SpriteKit


class MenuScene: SKScene {

	var currentLevel: Int = 1 {
		didSet {
			//UserDefaults.standard.set(currentLevel, forKey: "CurrentLevel")
			print("Set level")
		}
	}
	 
	var hiScore: Int = 0 {
		didSet {
			UserDefaults.standard.set(hiScore, forKey: "HiScore")
		}
	}
	
	override func didMove(to view: SKView) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.shouldRotate = true
		
		self.scaleMode = .aspectFit
		self.size = CGSize(width: 667, height: 375)
		
		currentLevel = UserDefaults.standard.integer(forKey: "CurrentLevel")
		currentLevel == 0 ? currentLevel = 1 : nil
		
		let continueGameNode = self.childNode(withName: "ContinueGameLabel")
		if(currentLevel == 1) {
			continueGameNode?.isHidden = true
		} else {
			continueGameNode?.isHidden = false
		}

		let newLevelsNode = self.childNode(withName: "NewLevelsLabel")
		let purchased = appDelegate.levelsPurchased
		if(purchased) {
			newLevelsNode?.isHidden = false
		} else {
			newLevelsNode?.isHidden = true
		}
		
		let hiScoreNode = self.childNode(withName: "HiScoreLabel")
		(hiScoreNode as! SKLabelNode).text = "HiScore: \(hiScore)"

	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let touchPosition = touch.location(in: self)
		let touchedNodes = nodes(at: touchPosition)
		
		for node in touchedNodes {
			if node.name == "NewGameLabel" {
				//newGameTouched()
				showPurchaseOptions()
			}
			if node.name == "ContinueGameLabel" {
				continueGameTouched()
			}
			if node.name == "HelpLabel" {
				showHelp()
			}
		}
	}
	
	func newGameTouched() {
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		let gameScene = GameScene(size: self.size)
		gameScene.levelValue = 1
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		gameScene.size = appDelegate.originalSize
		appDelegate.shouldRotate = false
		self.view?.presentScene(gameScene, transition: reveal)
	}
	
	func continueGameTouched() {
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		let gameScene = GameScene(size: self.size)
		gameScene.levelValue = currentLevel
		gameScene.levelLabel.text = "Level: \(currentLevel)"
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		gameScene.size = appDelegate.originalSize
		appDelegate.shouldRotate = false
		self.view?.presentScene(gameScene, transition: reveal)
	}
	
	func showHelp() {
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		let helpScene = SKScene(fileNamed: "HelpScene")!
		helpScene.size = CGSize(width: 667, height: 375)
		self.view?.presentScene(helpScene, transition: reveal)
	}
	
	func showPurchaseOptions() {
		let currentViewController = UIApplication.shared.keyWindow?.rootViewController
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "PurchaseController")
		
		currentViewController?.present(viewController, animated: true, completion: nil)
	}
	
}
