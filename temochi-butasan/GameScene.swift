//
//  GameScene.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var buta: Butasan!
    private var currentPosition = CGPoint(x: 0, y: 0)
    private var previoustPosition = CGPoint(x: 0, y: 0)
    
    private var isPigTouching = false
    
    let lightFBGenerator = UIImpactFeedbackGenerator(style: .light)
    let mediumFBGenerator = UIImpactFeedbackGenerator(style: .medium)
    let heavyFBGenerator = UIImpactFeedbackGenerator(style: .heavy)
   
    override func didMove(to view: SKView) {
//        // 青い四角形を作る.
//        let rect = SKShapeNode(rectOf: CGSize(width: 200.0, height: 300.0))
//        // 線の色を青色に指定.
//        rect.strokeColor = UIColor.blue
//        // 線の太さを2.0に指定.
//        rect.lineWidth = 2.0
//        // 四角形の枠組みの剛体を作る.
//        rect.physicsBody = SKPhysicsBody(edgeLoopFrom: rect.frame)
//        rect.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        self.addChild(rect)
        
        lightFBGenerator.prepare()
        
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        
        self.buta = Butasan()
        self.buta.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(buta)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        self.currentPosition = pos
        self.previoustPosition = pos
    }
    
    //TODO:適切なメソッドに切り分けて、touchhasMovedに記述する
    func touchMoved(toPoint pos : CGPoint) {
        //TODO: タッチした位置と豚の位置の位置関係を保つようにする
        buta.position = pos
        self.currentPosition = buta.position
        //TODO: CGPointのectensionにする
        let dx = self.previoustPosition.x - self.currentPosition.x
        let dy = self.previoustPosition.y - self.currentPosition.y
        let norm = sqrt(dx*dx + dy*dy)
        if norm > 50 {
            self.previoustPosition = buta.position
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let dx = self.currentPosition.x - self.previoustPosition.x
        let dy = self.currentPosition.y - self.previoustPosition.y
//        self.buta.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
        self.buta.physicsBody!.velocity = CGVector(dx: 0, dy: 30)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let tochedNode = self.atPoint(t.location(in: self))
            if tochedNode.name == self.buta.name {
                self.isPigTouching = true
                self.touchDown(atPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if isPigTouching {
                self.touchMoved(toPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if isPigTouching {
                self.touchUp(atPoint: t.location(in: self))
                self.isPigTouching = false
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.isPigTouching = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
