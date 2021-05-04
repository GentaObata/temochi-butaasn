//
//  StageModel.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/02.
//

import Foundation
import SpriteKit

class StageModel: NSObject {
    
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

    private(set) var remainingPoint: Int! {
        didSet {
            self.delegate?.updatedRemainingPoint(newPoint: self.remainingPoint)
            if remainingPoint == 0 {
                self.isPlaying = false
            }
        }
    }
    
    override init() {
        remainingPoint = 1
    }
    
    func reducePoint(basedOn contact: SKPhysicsContact) {
        //TODO:vectorを元にポイントの減らし具合を変える
        if self.remainingPoint != 0 {
            self.remainingPoint -= 1
        }
    }
}

protocol StageModelDelegate: class {
    func updatedRemainingPoint(newPoint: Int)
    
    func startGame()
    
    func finishGame()
}
