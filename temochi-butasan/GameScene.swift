//
//  GameScene.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    private var pigNode: SKSpriteNode!
    
    private var isPigTouching = false
   
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
        
        self.pigNode = SKSpriteNode(imageNamed: "pig")
        self.pigNode.name = "pig"
        let resizeWidth = self.size.width / 3
        let resizeHeight = self.pigNode.size.height * resizeWidth / self.pigNode.size.width
        self.pigNode.size = CGSize(width: resizeWidth, height: resizeHeight)
        self.pigNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(pigNode)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
        
    func touchMoved(toPoint pos : CGPoint) {
        //TODO: タッチした位置と豚の位置の位置関係を保つようにする
        pigNode.position = pos
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let tochedNode = self.atPoint(t.location(in: self))
            if tochedNode.name == self.pigNode.name {
                self.isPigTouching = true
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
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.isPigTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        self.isPigTouching = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
