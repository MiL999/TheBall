//
//  MapManager.swift
//  TheBall
//
//  Created by Miłosz on 3/28/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class MapManager {
	
	var scene:GameScene
	var currentMap = [[Int]]()
	var currentLevel = 1
	var mapMargin = 0
	var verticalMapMargin = 0
	
	let backgrounds = [
						"BackgroundWood2", "BackgroundWood2", "BackgroundWood", "BackgroundSteel", "BackgroundRain", "BackgroundWood2",
						"BackgroundWood", "BackgroundWood2", "BackgroundWood", "BackgroundSteel", "BackgroundRain", "BackgroundWood2",
						"BackgroundWood2", "BackgroundWood", "BackgroundWood", "BackgroundSteel", "BackgroundRain", "BackgroundWood2",
						]
	
	
	
	init(_ scene:GameScene) {
		self.scene = scene
		var a = scene.frame.size.width
		var b = scene.maxX
		var c = (Int(a) - b) / 2
		mapMargin = c
		
		a = scene.frame.size.height
		b = scene.maxY
		c = (Int(a) - b) / 2
		verticalMapMargin = c - 4
		
	}

	func loadMap(_ level:String) {
		currentMap = self.loadMap(level)
		createFloor()
		drawMap()
		//drawFieldLines()
	}
	
	fileprivate func loadMap(_ title:String) -> [[Int]] {
		var result = [[Int]]()
		let path = Bundle.main.path(forResource: title, ofType: "csv")
		
		do {
			let a = try String(contentsOfFile: path!)
			print(a)
			let array = a.components(separatedBy: .newlines)
			
			for row in array {
				let rowArray = row.components(separatedBy: ",")
				if (rowArray.count > 2) {
					let intArray = rowArray.map { Int($0)! }
					result.append(intArray)
				}
			}
		} catch {
			
		}
		
		return result
		
	}
	
	func createDashboard() {
		//	if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
		createPadDashboard()
		//	} else {
		//		createPhoneDashboard()
		//	}
	}
	
	func createPadDashboard() {
		let maxY = Int(scene.frame.size.height)
		let maxX = Int(scene.frame.size.width)
		
		scene.scoreLabel.fontColor = .lightGray
		scene.scoreLabel.text = "Score: 0"
		scene.scoreLabel.fontSize = 18
		scene.scoreLabel.horizontalAlignmentMode = .left
		scene.scoreLabel.position = CGPoint(x: mapMargin, y: maxY - 19)
		scene.scoreLabel.zPosition = 150
		scene.addChild(scene.scoreLabel)
		
		scene.timeLabel.fontColor = .lightGray
		scene.timeLabel.text = "Time: 60"
		scene.timeLabel.fontSize = 18
		scene.timeLabel.horizontalAlignmentMode = .center
		scene.timeLabel.position = CGPoint(x: (maxX / 2) , y: maxY - 19)
		scene.timeLabel.zPosition = 150
		scene.addChild(scene.timeLabel)
		
		scene.levelLabel.fontColor = .lightGray
		scene.levelLabel.text = "Level:"
		scene.levelLabel.fontSize = 18
		scene.levelLabel.horizontalAlignmentMode = .right
		scene.levelLabel.position = CGPoint(x: maxX - mapMargin, y: maxY - 19)
		scene.levelLabel.zPosition = 150
		scene.addChild(scene.levelLabel)
		
	}
	
	func createFloor() {
		let rect = CGRect(x: mapMargin, y: verticalMapMargin, width: scene.maxX, height: scene.maxY)
		let floor = SKShapeNode(rect: rect)
		let texture = SKTexture(imageNamed: backgrounds[currentLevel])
		floor.name = "Floor"
		floor.fillColor = UIColor.white
		floor.fillTexture = texture
		floor.strokeColor = UIColor.black
		floor.physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
		floor.physicsBody!.affectedByGravity = false
		floor.physicsBody!.restitution = 0.8
		floor.physicsBody!.linearDamping = 0
		floor.physicsBody!.friction = 0.3
		floor.physicsBody?.isDynamic = true
		floor.physicsBody!.mass = 0.5
		floor.physicsBody!.allowsRotation = false
		floor.physicsBody!.categoryBitMask = CollisionType.Frame.rawValue
		floor.physicsBody!.contactTestBitMask = floor.physicsBody!.collisionBitMask
		scene.addChild(floor)
	}
	
	func createBackground() {
		let rect = self.scene.frame
		let background = SKShapeNode(rect: rect)
		let texture = SKTexture(imageNamed: "Background")
		background.name = "Background"
		background.fillColor = UIColor.white
		background.fillTexture = texture
		background.strokeColor = UIColor.black
		scene.addChild(background)
	}
	
	func drawMap() {
		clearMap()
		for (y,row) in currentMap.reversed().enumerated() {
			for (x,brick) in row.enumerated() {
				switch(brick) {
				case 6:
					addBrick(Color: "Blue", x: x, y: y)
				case 7:
					addColoringBrick(Color: "Blue", x: x, y: y)
				case 8:
					addBrick(Color: "Red", x: x, y: y)
				case 9:
					addColoringBrick(Color: "Red", x: x, y: y)
				case 10:
					addBrick(Color: "Yellow", x: x, y: y)
				case 11:
					addColoringBrick(Color: "Yellow", x: x, y: y)
				case 12:
					addEnemyBrick(Name: "SkullEnemyBrick", x: x, y: y, animation: .None)
				case 13:
					createPlayer(x: x, y: y)
				case 14:
					addBonusBrick(Name: "StarBonus", x: x, y: y, animation: .Bouncing)
				case 16:
					addEnemyBrick(Name: "Saw2EnemyBrick", x: x, y: y, animation: .Rotating)
				case 17:
					addMovableBrick(Name: "Crate1", x: x, y: y, animation: .None)
				case 18:
					addDiamondBrick(Color: "Red", x: x, y: y)
				case 19:
					addDiamondBrick(Color: "Yellow", x: x, y: y)
				case 20:
					addDiamondBrick(Color: "Blue", x: x, y: y)
				case 21:
					addWallBrick("1", x: x, y: y)
				case 22:
					addWallBrick("2", x: x, y: y)

				default:
					break
				}
			}
		}
	}
	
	
	func clearMap() {
		for node in scene.children {
			if (["Brick","ColoringBrick", "EnemyBrick", "StarBonus", "MovableBrick", "Wall"].contains(node.name)) {
				node.removeFromParent()
			}
		}
	}
	
	
	func drawFieldLines() {
		for x in 0...scene.numColumns {
			drawLine(from: CGPoint(x: x * scene.brickSize, y: 0), to: CGPoint(x: x * scene.brickSize, y: scene.numRows * scene.brickSize))
		}
		
		for y in 0...scene.numRows {
			drawLine(from: CGPoint(x: 0, y: y * scene.brickSize), to: CGPoint(x: scene.numColumns * scene.brickSize, y: y * scene.brickSize))
		}
	}
	
	func drawLine(from: CGPoint, to: CGPoint) {
		var line = SKShapeNode()
		let path = CGMutablePath()
		path.move(to: from)
		path.addLine(to: to)
		line = SKShapeNode(path: path)
		scene.addChild(line)
	}
	
	
	func createPlayer(x:Int, y:Int) {
		scene.player = Player(imageNamed: "Ball")
		scene.player.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		scene.playerStartPosition = scene.player.position
		scene.player.size = CGSize(width: scene.ballSize, height: scene.ballSize)
		scene.player.playerColor = "Gray"
		scene.player.blendMode = .alpha
		scene.player.name = "Player"
		scene.player.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(scene.ballSize / 2) )
		scene.player.physicsBody!.affectedByGravity = true
		scene.player.physicsBody!.restitution = 0.9
		scene.player.physicsBody!.linearDamping = 0.9
		scene.player.physicsBody!.friction = 0.9
		scene.player.physicsBody?.isDynamic = true
		scene.player.physicsBody!.mass = 5
		scene.player.physicsBody!.allowsRotation = false
		scene.player.physicsBody!.categoryBitMask = CollisionType.Ball.rawValue
		scene.player.physicsBody!.contactTestBitMask = scene.player.physicsBody!.collisionBitMask
		scene.player.physicsBody?.collisionBitMask = ~CollisionType.BonusBrick.rawValue
		scene.addChild(scene.player)
	}
	
	
	func addBrick(Color color:String, x:Int, y:Int) {
		let brick = Brick(imageNamed: color+"Brick")
		brick.brickType = .Brick
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.name = "Brick"
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.8
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.9
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 5
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.Brick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.brickColor = color
		brick.hitSound = SKAction.playSoundFileNamed("Metal bang 2.wav", waitForCompletion: false)
		brick.destroySound = SKAction.playSoundFileNamed("Impact1.wav", waitForCompletion: false)
		scene.addChild(brick)
		scene.brickCount += 1
	}
	
	func addDiamondBrick(Color color:String, x:Int, y:Int) {
		let brick = Brick(imageNamed: color+"Diamond")
		brick.brickType = .Brick
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.name = "Brick"
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.8
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.9
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 5
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.Brick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.brickColor = color
		brick.hitSound = SKAction.playSoundFileNamed("Metal bang 2.wav", waitForCompletion: false)
		brick.destroySound = SKAction.playSoundFileNamed("Impact1.wav", waitForCompletion: false)
		scene.addChild(brick)
		scene.brickCount += 1
	}
	
	
	func addColoringBrick(Color color:String, x:Int, y:Int) {
		let brick = Brick(imageNamed: color+"ColoringBrick")
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.brickType = .ColoringBrick
		brick.brickColor = color
		brick.name = "ColoringBrick"
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.8
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.9
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 5
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.ColoringBrick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.hitSound = SKAction.playSoundFileNamed("paint.wav", waitForCompletion: false)
		scene.addChild(brick)
	}
	
	
	func addEnemyBrick(Name name:String, x:Int, y:Int, animation:BrickAnimation) {
		let brick = Brick(imageNamed: name)
		brick.brickType = .EnemyBrick
		brick.name = "EnemyBrick"
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.8
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.9
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 5
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.EnemyBrick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.hitSound = SKAction.playSoundFileNamed("death.wav", waitForCompletion: false)
		addAnimation(brick, animation: animation)
		scene.addChild(brick)
	}
	
	
	func addBonusBrick(Name name:String, x:Int, y:Int, animation:BrickAnimation) {
		let brick = Brick(imageNamed: name)
		brick.brickType = .BonusBrick
		brick.name = "StarBonus"
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.8
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.9
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 5
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.BonusBrick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.physicsBody!.collisionBitMask = 0
		brick.hitSound = SKAction.playSoundFileNamed("Bim.mp3", waitForCompletion: false)
		addAnimation(brick, animation: animation)
		scene.addChild(brick)
	}
	
	func addMovableBrick(Name name:String, x:Int, y:Int, animation:BrickAnimation) {
		let brick = Brick(imageNamed: name)
		brick.brickType = .MovableBrick
		brick.name = "MovableBrick"
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.9
		brick.physicsBody!.linearDamping = 1.0
		brick.physicsBody!.angularDamping = 0.2
		brick.physicsBody!.friction = 0.05
		brick.physicsBody?.isDynamic = true
		brick.physicsBody!.mass = 20
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.MovableBrick.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		//brick.physicsBody!.collisionBitMask = 0
		brick.hitSound = SKAction.playSoundFileNamed("Bim.mp3", waitForCompletion: false)
		addAnimation(brick, animation: animation)
		scene.addChild(brick)
	}
	
	func addWallBrick(_ number: String, x:Int, y:Int) {
		let brick = Brick(imageNamed: "Wall"+number)
		brick.brickType = .Brick
		brick.size = CGSize(width: scene.brickSize, height: scene.brickSize)
		brick.name = "Wall"
		brick.position = CGPoint(x: (x * scene.brickSize) + (scene.brickSize/2) + mapMargin, y: (y * scene.brickSize) + (scene.brickSize/2) + verticalMapMargin)
		brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
		brick.physicsBody!.affectedByGravity = false
		brick.physicsBody!.restitution = 0.1
		brick.physicsBody!.linearDamping = 0
		brick.physicsBody!.friction = 0.1
		brick.physicsBody?.isDynamic = false
		brick.physicsBody!.mass = 1
		brick.physicsBody!.allowsRotation = false
		brick.physicsBody!.categoryBitMask = CollisionType.Wall.rawValue
		brick.physicsBody!.contactTestBitMask = brick.physicsBody!.collisionBitMask
		brick.physicsBody!.collisionBitMask = 0
		brick.hitSound = SKAction.playSoundFileNamed("WallHit.wav", waitForCompletion: false)
	//	brick.destroySound = SKAction.playSoundFileNamed("Impact1.mp3", waitForCompletion: false)
		scene.addChild(brick)
	}
	
	func addAnimation(_ brick:Brick, animation:BrickAnimation) {
		switch(animation) {
		case .Bouncing:
				let scaleDownAction = SKAction.scaleX(to: 0.7, duration: 0.3)
				let scaleUpAction = SKAction.scaleX(to: 0.9, duration: 0.3)
				scaleDownAction.timingMode = .easeOut
				scaleUpAction.timingMode = .easeOut
				let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction])
				let repeatAction = SKAction.repeatForever(scaleActionSequence)
				brick.run(repeatAction)
		case .Rotating:
				let rotation = SKAction.rotate(byAngle: 1.0, duration: 0.3)
				let repeatAction = SKAction.repeatForever(rotation)
				brick.run(repeatAction)
		default:
			break
		}
	}
	
	
	
}
