//
//  Area.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/29.
//

import SpriteKit

class PlayArea: SKShapeNode {
    
    let lightFBGenerator = UIImpactFeedbackGenerator(style: .light)
    let mediumFBGenerator = UIImpactFeedbackGenerator(style: .medium)
    let heavyFBGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    init(categoryBitMask: UInt32) {
        super.init()
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: self.frame.minX, y: self.frame.minY), size: UIScreen.main.bounds.size), transform: nil)
//        self.strokeColor = .gray
//        self.lineWidth = 16
        self.lineWidth = 0
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = categoryBitMask
        self.physicsBody!.restitution = Settings.restitution

        lightFBGenerator.prepare()
        mediumFBGenerator.prepare()
        heavyFBGenerator.prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collide(with node: SKPhysicsContact) {
        // TODO: ぶつかってきたノードの速度によって衝撃を変える
        lightFBGenerator.impactOccurred()
    }
}
