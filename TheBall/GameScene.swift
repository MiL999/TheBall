//
//  GameScene.swift
//  TheBall
//
//  Created by Miłosz on 3/12/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion




class GameScene: SKScene, SKPhysicsContactDelegate {
	
	let motionManager = CMMotionManager()
	var colors = [UIColor]()
	var brickColors = [String]()
	let dimPanel = SKSpriteNode()
	let defaultFont = "Avenir"
	let timeValue = 60
	
	lazy var scoreLabel = SKLabelNode(fontNamed: defaultFont)
	lazy var timeLabel = SKLabelNode(fontNamed: defaultFont)
	lazy var levelLabel = SKLabelNode(fontNamed: defaultFont)
	
	var brickCount = 0
	var collisionsDisabled = false
	var numOfLevels = 10
	
	var levelValue: Int = 1 {
		didSet {
			levelLabel.text = "Level: \(levelValue)"
		}
	}
	
	var levelTimerValue: Int = 60 {
		didSet {
			timeLabel.text = "Time: \(levelTimerValue)"
		}
	}
	
	var scoreValue: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(scoreValue)"
		}
	}
	

	var numColumns = 0
	var numRows = 0
	var brickSize = 0
	var maxX = 0
	var maxY = 0
	var ballSize = 0
	var playerStartPosition = CGPoint(x: 0, y: 0)
	var player = Player(imageNamed: "Ball")
//	var smoke = SKSpriteNode()
//	var smokeFrames: [SKTexture] = []
	var orientationModifier = 1.0
	
	lazy var mapManager = MapManager(self)
	lazy var pauseLabel = SKLabelNode(fontNamed: defaultFont)

	
	
	override func didMove(to view: SKView) {
		self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		self.physicsWorld.contactDelegate = self
		self.backgroundColor = UIColor.black
		
		if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
			ballSize = 30
			numColumns = 21
			numRows = 11
			brickSize = Int(self.frame.size.width) / (numColumns+1)
		} else {
			numColumns = 21
			numRows = 11
			ballSize = 20
			brickSize = Int(self.frame.size.height) / (numRows+1)
		}

		print("BrickSize: \(brickSize)")
		maxX = brickSize * numColumns
		maxY = brickSize * numRows

		if(UIApplication.shared.statusBarOrientation == .landscapeRight) {
			orientationModifier = -1.0
		}
		
		
		mapManager.createBackground()
		mapManager.createDashboard()
		setUpGame()

		NotificationCenter.default.addObserver(self, selector: #selector(pauseGame), name: UIApplication.willResignActiveNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(pauseAfterBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(gotoMenu))
		swipeUp.direction = .up
		self.view?.addGestureRecognizer(swipeUp)
		
		if motionManager.isAccelerometerAvailable {
			motionManager.accelerometerUpdateInterval = 0.1
			motionManager.startAccelerometerUpdates(to: .main) {
				(data, error) in
				guard let data = data, error == nil else {
					return
				}
				let x = data.acceleration.x * 20 * self.orientationModifier
				let y = data.acceleration.y * 20 * self.orientationModifier
				self.physicsWorld.gravity = CGVector(dx: y, dy: -x)
			}
		}
		

	}

	
	fileprivate func setUpGame() {
		brickCount = 0
		levelLabel.text = "Level: \(levelValue)"
		
		let level = "L\(levelValue)"
		mapManager.currentLevel = levelValue
		mapManager.loadMap(level)
		getReady()
	}
	
	
//	func buildSmoke() {
//		let smokeAnimatedAtlas = SKTextureAtlas(named: "Smoke")
//		var frames: [SKTexture] = []
//
//		let numImages = smokeAnimatedAtlas.textureNames.count
//		for i in 1...numImages {
//			let smokeTextureName = "Smoke\(i)"
//			frames.append(smokeAnimatedAtlas.textureNamed(smokeTextureName))
//		}
//		smokeFrames = frames
//		smoke = SKSpriteNode(texture: smokeFrames[0])
//		smoke.zPosition = 200
//	}
	
	


//	func createPhoneDashboard() {
//		let x = maxX + (Int(self.frame.size.width) - maxX) / 2
//		scoreLabel.text = "Score: 0"
//		scoreLabel.fontSize = 14
//		scoreLabel.horizontalAlignmentMode = .center
//		scoreLabel.position = CGPoint(x: x, y: maxY - 30)
//		addChild(scoreLabel)
//
//		timeLabel.text = "Time: 1"
//		timeLabel.fontSize = 14
//		timeLabel.horizontalAlignmentMode = .center
//		timeLabel.position = CGPoint(x: x , y: maxY - 70)
//		addChild(timeLabel)
//
//		levelLabel.text = "Level: "
//		levelLabel.fontSize = 14
//		levelLabel.horizontalAlignmentMode = .center
//		levelLabel.position = CGPoint(x: x, y: maxY - 110)
//		addChild(levelLabel)
//	}
	

	
	
	

	

	
	func startTimer(from: Int) {
		levelTimerValue = from
		
		let wait = SKAction.wait(forDuration: 1.0)
		let block = SKAction.run({
			if self.levelTimerValue > 0 {
				self.levelTimerValue -= 1
			} else {
				self.removeAction(forKey: "countdown")
				self.gameOver(Message: "Time's Up")
			}
		})
		
		let sequence = SKAction.sequence([wait,block])
		run(SKAction.repeatForever(sequence), withKey: "countdown")
	}
	
	
	func stopTimer() {
		self.removeAction(forKey: "countdown")
	}
	
	func dimScreen(_ alpha:CGFloat) {
		dimPanel.color = UIColor.black
		dimPanel.size = self.size
		dimPanel.alpha = alpha
		dimPanel.zPosition = 100
		dimPanel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		self.addChild(dimPanel)
	}
	
	func undimScreen() {
		dimPanel.removeFromParent()
	}
	
	
	
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
	
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		guard collisionsDisabled == false else {
			return
		}
		
		if (contact.bodyA.node?.name == "Floor" && contact.bodyB.node?.name == "Player") {
			print("Contact between frame and ball")
		}

		if (contact.bodyA.node?.name == "Brick" &&	contact.bodyB.node?.name == "Player") {
			print("Contact between brick and ball")
			brickContact(node: contact.bodyA.node!)
			let impact = UIImpactFeedbackGenerator()
			impact.impactOccurred()
		}
		
		if (contact.bodyA.node?.name == "Wall" &&	contact.bodyB.node?.name == "Player") {
			print("Contact between wall and ball")
			let brick = contact.bodyA.node as! Brick
			playSound(brick.hitSound)
			let impact = UIImpactFeedbackGenerator()
			impact.impactOccurred()
		}
		
		if (contact.bodyA.node?.name == "ColoringBrick" &&	contact.bodyB.node?.name == "Player") {
			print("Contact between coloringBrick and ball")
			coloringBrickContact(node: contact.bodyA.node!)
		}
		
		if (contact.bodyA.node?.name == "EnemyBrick" &&	contact.bodyB.node?.name == "Player") {
			print("Contact between enemyBrick and ball")
			enemyBrickContact(player: contact.bodyB.node!, enemy: contact.bodyA.node!)
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.error)
		}
		
		if (contact.bodyA.node?.name == "StarBonus" && contact.bodyB.node?.name == "Player") {
			print("Contact between bonus and ball")
			bonusBrickContact(node: contact.bodyA.node!)
		}
	}
	
	
	
	func bonusBrickContact(node: SKNode) {
		let brick = node as! Brick
		playSound(brick.hitSound)
		
		let particles = SKEmitterNode(fileNamed: "Spark.sks")
		if let particles = particles {
			particles.position = brick.position
			addChild(particles)
		}
		
		let scaleDownAction = SKAction.scale(to: 0.01, duration: 0.2)
		let scaleActionSequence = SKAction.sequence([scaleDownAction])
		node.run(scaleActionSequence, completion: {
			node.removeFromParent()
			self.scoreValue += 20
//			if let particles = particles {
//				particles.removeFromParent()
//			}
		})
	}
	
	func playSound(_ sound:SKAction?) {
		if let sound = sound {
			self.run(sound)
		}
	}

	func brickContact(node: SKNode) {
		let brick = node as! Brick
		if(brick.brickColor.isEqual(player.playerColor)) {
			playSound(brick.destroySound)
			
			let particles = SKEmitterNode(fileNamed: "Smoke.sks")
			if let particles = particles {
				particles.position = brick.position
				addChild(particles)
			}
			
			let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.2)
			let scaleDownAction = SKAction.scale(to: 0.01, duration: 0.2)
			let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
			node.run(scaleActionSequence, completion: {
				node.removeFromParent()
				self.brickCount -= 1
				self.scoreValue += 10
				
				if(self.brickCount == 0) {
					self.endLevel()
				}
			})

		} else {
			playSound(brick.hitSound)
		}
	}
	
	
	func enemyBrickContact(player: SKNode, enemy: SKNode) {
		let brick = enemy as! Brick
		player.removeFromParent()
		playSound(brick.hitSound)
		stopTimer()
		
		let particles = SKEmitterNode(fileNamed: "Death.sks")
		if let particles = particles {
			particles.position = brick.position
			addChild(particles)
		}
		
		let waitAction = SKAction.wait(forDuration: 2)
		brick.run(waitAction, completion: {
			//self.gameOver(Message: "Game Over")
			self.gotoMenu()
		})
		

	}
	
	
	func coloringBrickContact(node: SKNode) {
		player.playerColor = (node as! Brick).brickColor
		player.texture = SKTexture(imageNamed: player.playerColor+"Ball")
		let brick = node as! Brick
		playSound(brick.hitSound)
	}

	
	
	func endLevel() {
		player.removeFromParent()
		dimScreen(0.4)
		let label = SKLabelNode(fontNamed: defaultFont)
		label.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height-20) / 2)
		label.fontSize = 200
		label.fontColor = UIColor.white
		label.text = "Level Completed"
		label.zPosition = 101
		addChild(label)
	
		stopTimer()
		//playSound(SKAction.playSoundFileNamed("level_completed.wav", waitForCompletion: false))
		
		let waitAction = SKAction.wait(forDuration: 2)
		let scaleDownAction = SKAction.scale(to: 0.25, duration: 0.5)
		scaleDownAction.timingMode = .easeOut
		let scaleActionSequence = SKAction.sequence([scaleDownAction, waitAction])
		label.run(scaleActionSequence, completion: {
			label.removeFromParent()
			self.undimScreen()
			self.player.removeFromParent()
			
			if (self.levelValue+1 > self.numOfLevels) {
				self.gameCompleted()
			} else {
				self.levelValue += 1
				self.setUpGame()
			}

		})
	}
	
	func gameCompleted() {
		dimScreen(0.7)
		let label = SKLabelNode(fontNamed: defaultFont)
		label.position = CGPoint(x: self.frame.width / 2, y: ((self.frame.height-20) / 2) + 20)
		label.fontSize = 200
		label.fontColor = UIColor.white
		label.numberOfLines = 2
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .center
		label.text = "You have completed all levels."
		label.zPosition = 101
		addChild(label)

		let label2 = SKLabelNode(fontNamed: defaultFont)
		label2.position = CGPoint(x: self.frame.width / 2, y: ((self.frame.height-20) / 2) - 20)
		label2.fontSize = 200
		label2.fontColor = UIColor.white
		label2.numberOfLines = 2
		label2.horizontalAlignmentMode = .center
		label2.verticalAlignmentMode = .center
		label2.text = "New levels coming soon."
		label2.zPosition = 101
		//addChild(label2)
		
		stopTimer()
		let waitAction = SKAction.wait(forDuration: 1)
		let waitAction2 = SKAction.wait(forDuration: 5)
		let scaleDownAction = SKAction.scale(to: 0.14, duration: 1.5)
		scaleDownAction.timingMode = .easeOut
		let scaleActionSequence = SKAction.sequence([scaleDownAction, waitAction])
		let scaleActionSequence2 = SKAction.sequence([scaleDownAction, waitAction2])
		label.run(scaleActionSequence, completion: {
			self.addChild(label2)
			label2.run(scaleActionSequence2, completion: {
				label.removeFromParent()
				label2.removeFromParent()
				self.player.removeFromParent()
				self.undimScreen()
				self.gotoMenu()
			})
		})
		
		label2.run(scaleActionSequence)
		
//		let particles = SKEmitterNode(fileNamed: "Wow.sks")
//		if let particles = particles {
//			particles.position = CGPoint(x:100,y:100)
//			addChild(particles)
//		}
		
	}
	
	
	
	func gameOver(Message message:String) {
		dimScreen(0.4)
		let label = SKLabelNode(fontNamed: defaultFont)
		label.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height-20) / 2)
		label.fontSize = 200
		label.fontColor = UIColor.white
		label.text = message
		label.zPosition = 101
		addChild(label)

		self.player.removeFromParent()
		stopTimer()

		let waitAction = SKAction.wait(forDuration: 2)
		let scaleDownAction = SKAction.scale(to: 0.25, duration: 0.5)
		scaleDownAction.timingMode = .easeOut
		let scaleActionSequence = SKAction.sequence([scaleDownAction, waitAction])
		label.run(scaleActionSequence, completion: {
			label.removeFromParent()
			self.gotoMenu()
		})
	}
	
	
	func getReady() {
		player.removeFromParent()
		collisionsDisabled = true
		dimScreen(0.4)
		let label = SKLabelNode(fontNamed: defaultFont)
		label.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height-20) / 2)
		label.fontSize = 52
		label.fontColor = UIColor.white
		label.text = "Get Ready"
		label.zPosition = 101
		addChild(label)
		
		let waitAction = SKAction.wait(forDuration: 2)
		let scaleActionSequence = SKAction.sequence([waitAction])
		label.run(scaleActionSequence, completion: {
			label.removeFromParent()
			self.undimScreen()
			self.addChild(self.player)
			self.player.physicsBody?.affectedByGravity = false

			let sound = SKAction.playSoundFileNamed("ball_drop.wav", waitForCompletion: false)
			let scaleUpAction1 = SKAction.scale(to: 4, duration: 0.01)
			let scaleDownAction1 = SKAction.scale(to: 1, duration: 0.3)
			let scaleUpAction2 = SKAction.scale(to: 1.3, duration: 0.15)
			let scaleDownAction2 = SKAction.scale(to: 1, duration: 0.15)
			scaleUpAction2.timingMode = .easeOut

			let scaleActionSequence = SKAction.sequence([scaleUpAction1, scaleDownAction1, sound, scaleUpAction2, scaleDownAction2])
			self.player.run(scaleActionSequence, completion: {
				self.player.physicsBody?.affectedByGravity = true
				self.collisionsDisabled = false
				self.startTimer(from: 60)

			})
			
		})
	}

	
	
	func randomColor() -> UIColor {
		var result :UIColor
		result = colors[Int.random(in: 0...2)]
		return result
	}
	
	func randomBrickColor() -> String {
		var result :String
		result = brickColors[Int.random(in: 0...2)]
		return result
	}
	
	
	
	@objc func gotoMenu() {
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		let scene = SKScene(fileNamed: "MenuScene")!
//		(scene as! MenuScene).currentLevel = levelValue
		UserDefaults.standard.set(levelValue, forKey: "CurrentLevel")
		var hiScore = UserDefaults.standard.integer(forKey: "HiScore")
		if (scoreValue > hiScore) {
			hiScore = scoreValue
		}
		(scene as! MenuScene).hiScore = hiScore
		self.view?.presentScene(scene, transition: reveal)
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if (self.isPaused) {
			unpauseGame()
		} else {
			pauseGame()
		}
	}
	
	
	@objc func pauseGame() {
		unpauseGame()
		dimScreen(0.4)
		pauseLabel.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height-20) / 2)
		pauseLabel.fontSize = 26
		pauseLabel.fontColor = UIColor.white
		pauseLabel.text = "Paused"
		pauseLabel.zPosition = 101
		addChild(pauseLabel)
		self.isPaused = true
		UserDefaults.standard.set(levelValue, forKey: "CurrentLevel")
	}
	
	@objc func pauseAfterBecomeActive() {
		self.isPaused = true
	}
	
	func unpauseGame() {
		undimScreen()
		pauseLabel.removeFromParent()
		self.isPaused = false
	}
	
	
}
