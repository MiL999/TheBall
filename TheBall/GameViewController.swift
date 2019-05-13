//
//  GameViewController.swift
//  TheBall
//
//  Created by Miłosz on 3/12/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		var level = UserDefaults.standard.integer(forKey: "CurrentLevel")
		let score = UserDefaults.standard.integer(forKey: "HiScore")

		if (level == 0) {
			level = 1
		}

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.originalSize = view.bounds.size
		appDelegate.levelsPurchased = UserDefaults.standard.bool(forKey: "LevelsPurchased")

		UIView.setAnimationsEnabled(true)
		//if(UIApplication.shared.statusBarOrientation == .landscapeLeft) {
		//	let value = UIApplication.shared.statusBarOrientation.rawValue
		//	UIDevice.current.setValue(value, forKey: "orientation")
		//}
		
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") {
				(scene as! MenuScene).currentLevel = level
				(scene as! MenuScene).hiScore = score
				print(scene.size)
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
          //  view.showsFPS = true
          //  view.showsNodeCount = true
			//view.showsPhysics = true
			

			
        }
    }


	
	
//	override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
//		(self.view as? SKView)?.scene?.size = self.view.bounds.size
//	}
	
    override var shouldAutorotate: Bool {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.shouldRotate
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
