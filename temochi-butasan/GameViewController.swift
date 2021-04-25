//
//  GameViewController.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        print("UIScreen.main.bounds.size")
        print(UIScreen.main.bounds.size)
        super.viewDidLoad()
        print(self.view.frame.size)
        self.view.frame.size = CGSize(width: 200,height: 100)
        print(self.view.frame.size)
        
        if let view = self.view as! SKView? {
            view.backgroundColor = UIColor.red
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
