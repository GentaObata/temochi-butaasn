//
//  StageRepository.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import Foundation

class StageRepository {
    
    let stageKey = "stage"
    
    static let shared = StageRepository()
    private var stage: Stage? = nil
    
    func setStage(_ stage: Stage) {
        self.stage = stage
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(stage)
        UserDefaults.standard.set(String(data: encoded, encoding: .utf8)!, forKey: stageKey)
    }
    
    func getStage() -> Stage? {
        if let stage = self.stage {
            return stage
        }
        if let stage = UserDefaults.standard.string(forKey: stageKey) {
            if let stage = try? JSONDecoder().decode(Stage.self, from: stage.data(using: .utf8)!) {
                return stage
            }
        }
        return nil
    }
    
    func deleteStage() {
        UserDefaults.standard.removeObject(forKey: stageKey)
    }
}
