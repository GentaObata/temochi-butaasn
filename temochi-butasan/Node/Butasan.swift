//
//  Butasan.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/26.
//

import SpriteKit

class Butasan: SKSpriteNode {
    
    private var previoustPosition = CGPoint(x: 0, y: 0)
    private var previousTime = Date()
    private let lightFBGenerator = UIImpactFeedbackGenerator(style: .light)
    var beeingTouched = false

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
        
        lightFBGenerator.prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        self.previoustPosition = pos
        self.previousTime = Date()
        self.resetVelocity()
        lightFBGenerator.impactOccurred()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.position = pos
        let interval = Date().timeIntervalSince(self.previousTime)
        if interval > 1 {
            self.previoustPosition = self.position
            self.previousTime = Date()
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.beeingTouched = false
        self.updateVelocity(atPoint: pos)
    }
    
    private func resetVelocity() {
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody!.angularVelocity = 0.0
    }
    
    private func updateVelocity(atPoint pos : CGPoint) {
        let dx = pos.x - self.previoustPosition.x
        let dy = pos.y - self.previoustPosition.y
        let interval = CGFloat(Date().timeIntervalSince(self.previousTime))
        self.physicsBody!.velocity = CGVector(dx: dx / interval, dy: dy / interval)
    }
    
    func updateVelocityToFinish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let finishingSpeed = 20
            let newVectorX = self.physicsBody!.velocity.dx >= 0 ? finishingSpeed : -finishingSpeed
            let newVectorY = self.physicsBody!.velocity.dy >= 0 ? finishingSpeed : -finishingSpeed
            self.physicsBody!.velocity = CGVector(dx: newVectorX, dy: newVectorY)
            self.physicsBody!.angularVelocity = CGFloat(self.physicsBody!.angularVelocity / 5)
        }
    }
}

