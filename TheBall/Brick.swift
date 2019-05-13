//
//  Brick.swift
//  TheBall
//
//  Created by Miłosz on 3/22/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import Foundation
import SpriteKit


enum CollisionType: UInt32 {
	case Frame = 1
	case Ball = 2
	case Brick = 4
	case ColoringBrick = 8
	case EnemyBrick = 16
	case BonusBrick = 32
	case MovableBrick = 64
	case Wall = 128
}


enum BrickType: UInt32 {
	case Brick = 1
	case ColoringBrick = 2
	case EnemyBrick = 3
	case StoneBrick = 4
	case BonusBrick = 5
	case MovableBrick = 6
	case Wall = 7
}

enum BrickAnimation: UInt32 {
	case None = 0
	case Bouncing = 1
	case Rotating = 2

}

class Brick: SKSpriteNode {
	
	var brickType: BrickType = .Brick
	var brickColor: String = ""
	var hitSound: SKAction?
	var destroySound: SKAction?
	
	
}
