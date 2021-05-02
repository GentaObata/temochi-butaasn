//
//  GameScene.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var playArea: PlayArea!
    private var buta: Butasan!
    private var pointLabel: PointLabel!
    
    private var previousCollisionTimePlayAreaAndButa: Date?
    
    private let playAreaMask: UInt32 = 0x1 << 1
    private let butaMask: UInt32 = 0x1 << 2
    
    private let stageModel = StageModel()
   
    override func didMove(to view: SKView) {
        // シーン自体の設定
        self.physicsWorld.contactDelegate = self
        self.size = view.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: 0.0 )
        
        self.stageModel.delegate = self
        
        // 周りの枠を配置
        self.playArea = PlayArea(categoryBitMask: playAreaMask)
        self.playArea.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        self.addChild(self.playArea)
        
        // ブタを配置
        self.buta = Butasan(categoryBitMask: butaMask, contactTestBitMask: playAreaMask)
        self.buta.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(self.buta)
        
        // ポイントラベルを配置
        self.pointLabel = PointLabel(point: self.stageModel.remainingPoint)
        self.pointLabel.position = CGPoint(x: self.frame.maxX - 16, y: self.frame.maxY  - 16)
        self.addChild(self.pointLabel)
    }
    
    func ajustNodePositionBySafeArea(edgeInsets: UIEdgeInsets) {
        if edgeInsets.top != 0 {
            self.pointLabel.position = CGPoint(
                x:self.pointLabel.position.x,
                y:self.pointLabel.position.y - edgeInsets.top + 16
            )
        }
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
                //TODO: ブタがplayAreaを超えないような処理を追加する（一定以上外側に持っていけないようにするとか）
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
}
    
extension GameScene: SKPhysicsContactDelegate {
    // 衝撃が0のノイズが発生するため、衝突の衝撃が0のものを除外する
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.collisionImpulse == 0 { return }
        
        // プレイエリアに何かがぶつかった時の処理。bodyAがプレイエリア、bodyBが当たってきたもの
        if contact.bodyA.categoryBitMask == self.playAreaMask {
            // ブタがぶつかってきた時の処理
            if contact.bodyB.categoryBitMask == self.butaMask {
                // ブタを掴んでいる時は衝突とはみなさない
                if buta.beeingTouched { return }
                
                // 連続しての衝突を除外する
                let collisionIntervalSecond = 0.05
                if self.previousCollisionTimePlayAreaAndButa != nil &&
                    Date().timeIntervalSince(self.previousCollisionTimePlayAreaAndButa!) < collisionIntervalSecond {
                        return
                }
                self.previousCollisionTimePlayAreaAndButa = Date()
                self.playArea.collide(with: contact.bodyB)
                self.stageModel.reducePoint(basedOn: contact)
            }
        }
    }
}

extension GameScene: StageModelDelegate {
    func updatedRemainingPoint(newPoint: Int) {
        self.pointLabel.text = String(newPoint)
    }
}
