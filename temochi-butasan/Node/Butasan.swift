//
//  Butasan.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/26.
//

import SpriteKit

class Butasan: SKSpriteNode {

    init(categoryBitMask: UInt32, contactTestBitMask: UInt32) {
        let texture = SKTexture(imageNamed: "pig")
        let resizeWidth = UIScreen.main.bounds.size.width / Settings.butaResizeRatio
        let resizeHeight = texture.size().height
            * resizeWidth / texture.size().width
        let size = CGSize(width: resizeWidth, height: resizeHeight)
        super.init(texture: texture, color: .clear, size: size)
        self.name = "buta"
        
        // テストのための設定
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "buta"
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.contactTestBitMask = contactTestBitMask
        self.physicsBody!.friction = Settings.butaFriction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

