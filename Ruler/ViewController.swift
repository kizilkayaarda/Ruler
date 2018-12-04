//
//  ViewController.swift
//  Ruler
//
//  Created by Cemal Arda KIZILKAYA on 4.12.2018.
//  Copyright © 2018 Cemal Arda KIZILKAYA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
       sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
        
            let testResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResults = testResults.first {
                
                addDot(at: hitResults)
                
            }
        
        }
        
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let colorMaterial = SCNMaterial()
        colorMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [colorMaterial]
        
        let dotNode = SCNNode()
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y , hitResult.worldTransform.columns.3.z)
        
        dotNode.geometry = dotGeometry
        sceneView.scene.rootNode.addChildNode(dotNode)
        
    }

}
