//
//  Butasan.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/26.
//

import UIKit
import SpriteKit

class Butasan: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "pig")
        let resizeWidth = UIScreen.main.bounds.size.width / 3
        let resizeHeight = texture.size().height
            * resizeWidth / texture.size().width
        let size = CGSize(width: resizeWidth, height: resizeHeight)
        super.init(texture: texture, color: .clear, size: size)
        self.name = "butasan"
        
        // テストのための設定
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "buta"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

