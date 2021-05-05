//
//  StageModel.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/02.
//

import Foundation
import SpriteKit

class StageModel: NSObject {
    
    private(set) var currentStage: Stage {
        set(newValue) {
            let oldValue = currentStage
            StageRepository.shared.setStage(newValue)
            // ステータスの変化を通知する
            if oldValue.status != newValue.status {
                switch newValue.status {
                case .redy:
                    self.delegate?.redyToGame()
                case .playing:
                    self.delegate?.startPlayGame()
                case .finished:
                    self.delegate?.finishGame()
                }
            }
        }
        get {
            // 保存されたデータが見つからない時は初期化してステージ1からスタートとする
            return StageRepository.shared.getStage() ?? Stage()
        }
    }
    
    weak var delegate: StageModelDelegate?
    
    var isPlaying: Bool {
        get {
            self.currentStage.status == .playing || self.currentStage.status == .redy
        }
    }
    
    override init() {
        super.init()
        // ステージをリセットしたい時にコメントイン
//        StageRepository.shared.deleteStage()
    }
    
    func handleCollision(contact: SKPhysicsContact) {
        // 最初の衝突をステージ開始をみなす
        if self.currentStage.targetCount == self.currentStage.remainingPoint {
            self.currentStage.startDate = Date()
            self.currentStage.status = .playing
        }
        
        self.reducePoint(basedOn: contact)
        self.delegate?.updatedRemainingPoint(newPoint: currentStage.remainingPoint)
        
        // 0になった時をステージ終了とみなす
        if currentStage.remainingPoint == 0 {
            self.currentStage.finishDate = Date()
            self.currentStage.status = .finished
        }
    }
    
    func startNextStage() {
        self.currentStage.stageNumber += 1
        self.currentStage.targetCount = self.calculateTargetPoint(self.currentStage.stageNumber)
        self.currentStage.remainingPoint = self.currentStage.targetCount
        self.currentStage.status = .redy
        self.delegate?.updatedRemainingPoint(newPoint: currentStage.remainingPoint)
    }
    
    //TODO:vectorを元にポイントの減らし具合を変える
    private func reducePoint(basedOn contact: SKPhysicsContact) {
        if self.currentStage.remainingPoint != 0 {
            self.currentStage.remainingPoint -= 1
        }
    }
    
    private func calculateTargetPoint(_ i: Int) -> Int {
        #if DEBUG
            return 2
        #endif
        var point = 0
        switch i {
        case 1:
            point = 10
        case 2...100:
            point = i * 25
        case 100...:
            point = 2500 + i * 15
        default:
            point = 10
        }
        return point
    }
}

protocol StageModelDelegate: class {
    func updatedRemainingPoint(newPoint: Int)
    
    func redyToGame()
    
    func startPlayGame()
    
    func finishGame()
}
