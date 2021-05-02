//
//  GameScene.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var area: Area!
    private var buta: Butasan!
    
    private let areaMask: UInt32 = 0x1 << 1
    private let butaMask: UInt32 = 0x1 << 2
   
    override func didMove(to view: SKView) {
        // シーン自体の設定
        self.physicsWorld.contactDelegate = self
        self.size = view.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        
        // 周りの枠を配置
        self.area = Area(categoryBitMask: areaMask)
        self.area.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        self.addChild(area)
        
        // ブタを配置
        self.buta = Butasan(categoryBitMask: butaMask, contactTestBitMask: areaMask)
        self.buta.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(buta)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let dx = pos.x - self.buta.previoustPosition.x
        let dy = pos.y - self.buta.previoustPosition.y
        let interval = CGFloat(Date().timeIntervalSince(self.buta.previousTime))
        self.buta.physicsBody!.velocity = CGVector(dx: dx / interval, dy: dy / interval)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchPoint = t.location(in: self)
            let tochedNode = self.atPoint(touchPoint)
            if tochedNode.name == self.buta.name {
                self.buta.beeingTouched = true
                self.buta.touchDown(atPoint: touchPoint)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.touchMoved(toPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.beeingTouched = false
                self.buta.touchUp(atPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.beeingTouched = false
                self.buta.touchUp(atPoint: t.location(in: self))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == self.areaMask &&
            contact.bodyB.categoryBitMask == self.butaMask {
            self.area.collide(with: self.buta)
        }
    }
}
