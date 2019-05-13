//
//  ControllerProtocol.swift
//  TheBall
//
//  Created by Miłosz on 4/4/19.
//  Copyright © 2019 Miłosz. All rights reserved.
//

import Foundation

protocol ControllerProtocol: AnyObject {
	func gameDidEnd(atLevel level:Int)
}
