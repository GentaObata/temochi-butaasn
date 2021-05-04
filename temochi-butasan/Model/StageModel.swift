//
//  StageModel.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/02.
//

import Foundation
import SpriteKit

class StageModel: NSObject {
    
    private var currentStage: Stage {
        didSet {
            if currentStage.remainingPoint != oldValue.remainingPoint {
                self.delegate?.updatedRemainingPoint(newPoint: self.remainingPoint)
                if currentStage.remainingPoint == 0 {
                    self.isPlaying = false
                }
            }
        }
    }
    
    weak var delegate: StageModelDelegate?
    private(set) var isPlaying = true {
        didSet {
            if isPlaying {
                self.delegate?.startGame()
            } else {
                self.delegate?.finishGame()
            }
        }
    }

    var remainingPoint: Int! {
        get {
            self.currentStage.remainingPoint
        }
    }
    
    override init() {
        self.currentStage = Stage()
    }
    
    func reducePoint(basedOn contact: SKPhysicsContact) {
        //TODO:vectorを元にポイントの減らし具合を変える
        if self.remainingPoint != 0 {
            self.currentStage.remainingPoint -= 1
        }
    }
    
    func startNextStage() {
        self.currentStage.toNext()
        self.isPlaying = true
    }
}

protocol StageModelDelegate: class {
    func updatedRemainingPoint(newPoint: Int)
    
    func startGame()
    
    func finishGame()
}
