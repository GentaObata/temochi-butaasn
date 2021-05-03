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
    
    private(set) var remainingPoint: Int! {
        didSet {
            delegate?.updatedRemainingPoint(newPoint: self.remainingPoint)
        }
    }
    
    override init() {
        remainingPoint = 1000
    }
    
    func reducePoint(basedOn contact: SKPhysicsContact) {
        //TODO:vectorを元にポイントの減らし具合を変える
        self.remainingPoint -= 1
    }
}

protocol StageModelDelegate: class {
    func updatedRemainingPoint(newPoint: Int)
}
