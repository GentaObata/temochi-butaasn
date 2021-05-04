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
    private var tutorialImage: UIImageView!
    private var finishView: FinishView!
    
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
        
        // チュートリアルの表示
        self.tutorialImage = UIImageView(image: UIImage(named: "tutorialImage"))
        self.tutorialImage.center = self.view!.center
        self.tutorialImage.alpha = 0.5
        self.view?.addSubview(self.tutorialImage)
        
        // フィニッシュ画面の配置
        self.finishView = FinishView()
        self.finishView.center = self.view!.center
        self.finishView.delegate = self
        
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
        
//        self.view?.addSubview(self.finishView)
//        self.finishView.show()
    }
    
    func ajustNodePositionBySafeArea(edgeInsets: UIEdgeInsets) {
        if edgeInsets.top != 0 {
            self.pointLabel.position = CGPoint(
                x:self.frame.maxX - 16,
                y:self.frame.maxY - 16 - edgeInsets.top + 16
            )
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchPoint = t.location(in: self)
            let tochedNode = self.atPoint(touchPoint)
            if tochedNode.name == self.buta.name && self.stageModel.isPlaying {
                self.buta.beeingTouched = true
                self.buta.touchDown(atPoint: touchPoint)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.touchMoved(toPoint: self.notCollisonPoint(atPoint: t.location(in: self), touchingNode: self.buta))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.beeingTouched = false
                self.buta.touchUp(atPoint: self.notCollisonPoint(atPoint: t.location(in: self), touchingNode: self.buta))
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if self.buta.beeingTouched {
                self.buta.beeingTouched = false
                self.buta.touchUp(atPoint: self.notCollisonPoint(atPoint: t.location(in: self), touchingNode: self.buta))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //TODO: 角度によって端までつかない位置で止まってしまうことを解決する
    private func notCollisonPoint(atPoint pos: CGPoint, touchingNode node: SKSpriteNode) -> CGPoint {
        var notCollisonPoint = pos
        
        let borderLineNotCollisionMinX = self.frame.minX + node.frame.width / 2
        if pos.x < borderLineNotCollisionMinX {
            notCollisonPoint.x = borderLineNotCollisionMinX
        }
        let borderLineNotCollisionMaxX = self.frame.maxX - node.frame.width / 2
        if pos.x > borderLineNotCollisionMaxX {
            notCollisonPoint.x = borderLineNotCollisionMaxX
        }
        let borderLineNotCollisionMinY = self.frame.minY + node.frame.height / 2
        if pos.y < borderLineNotCollisionMinY {
            notCollisonPoint.y = borderLineNotCollisionMinY
        }
        let borderLineNotCollisionMaxY = self.frame.maxY - node.frame.height / 2
        if pos.y > borderLineNotCollisionMaxY {
            notCollisonPoint.y = borderLineNotCollisionMaxY
        }
        
        return notCollisonPoint
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
                self.tutorialImage.isHidden = true
                self.previousCollisionTimePlayAreaAndButa = Date()
                self.playArea.collide(with: contact)
                self.stageModel.reducePoint(basedOn: contact)
            }
        }
    }
}

extension GameScene: StageModelDelegate {
    func updatedRemainingPoint(newPoint: Int) {
        self.pointLabel.text = String(newPoint)
    }
    
    func startGame() {
        self.finishView.removeFromSuperview()
    }
    
    func finishGame() {
        self.buta.updateVelocityToFinish()
        self.view?.addSubview(self.finishView)
        self.finishView.show()
    }
}

extension GameScene: FinishViewDelegate {
    func didTappdNextButton() {
        self.stageModel.startNextStage()
    }
}
