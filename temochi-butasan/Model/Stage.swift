//
//  Stage.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import Foundation
import UIKit

struct Stage: Codable{
    
    var stageNumber: Int
    var targetCount: Int
    var remainingPoint: Int
    var startDate: Date
    
    init(stageNumber: Int, targetCount: Int, remainingPoint: Int, startDate: Date) {
        self.stageNumber = stageNumber
        self.targetCount = targetCount
        self.remainingPoint = remainingPoint
        self.startDate = startDate
    }
    
    // 初めてゲームを行った時
    init() {
        self.stageNumber = 1
        self.targetCount = Stage.calculateTargetPoint(self.stageNumber)
        self.remainingPoint = self.targetCount
        self.startDate = Date()
    }
    
    mutating func toNext() {
        self.stageNumber += 1
        self.targetCount = Stage.calculateTargetPoint(self.stageNumber)
        self.remainingPoint = self.targetCount
        self.startDate = Date()
    }
    
    private static func calculateTargetPoint(_ i: Int) -> Int {
        var point = 0
        switch i {
        case 1:
            point = i * 10
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
