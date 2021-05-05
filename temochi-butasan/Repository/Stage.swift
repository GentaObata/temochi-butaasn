//
//  Stage.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import Foundation
import UIKit

struct Stage: Codable {
    
    var stageNumber: Int
    var targetCount: Int
    var remainingPoint: Int
    var startDate: Date?
    var finishDate: Date?
    var status: StageStatus
    
    // ステージ1として初期化
    init() {
        self.stageNumber = 1
        self.targetCount = 10
        self.remainingPoint = self.targetCount
        self.startDate = nil
        self.finishDate = nil
        self.status = .redy
    }
}

enum StageStatus: Codable {
    case redy
    case playing
    case finished

    
    enum Key: CodingKey {
            case rawValue
        }
        
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .redy
        case 1:
            self = .playing
        case 2:
            self = .finished
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .redy:
            try container.encode(0, forKey: .rawValue)
        case .playing:
            try container.encode(1, forKey: .rawValue)
        case .finished:
            try container.encode(2, forKey: .rawValue)
        }
    }
}
