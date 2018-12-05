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
    
    var dotNodeArray = [SCNNode]()
    
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
    
    //MARK: - Adding dots at the locations where the user touched
    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let colorMaterial = SCNMaterial()
        colorMaterial.diffuse.contents = UIColor.red
        dotGeometry.materials = [colorMaterial]
        
        let dotNode = SCNNode()
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y , hitResult.worldTransform.columns.3.z)
        
        dotNode.geometry = dotGeometry
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodeArray.append(dotNode)
        
        if dotNodeArray.count >= 2 {
            calculateDistance()
        }
        
    }
    
    //MARK: - Calculates the distance between two dots added to the scene in the real world
    func calculateDistance() {
        
        let startingPoint = dotNodeArray[0]
        let endPoint = dotNodeArray[1]
        
        let dx = endPoint.position.x - startingPoint.position.x
        let dy = endPoint.position.y - startingPoint.position.y
        let dz = endPoint.position.z - startingPoint.position.z
        
        let distance = sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2))
        
        displayMeasurement(text: "\(Int(distance * 100)) cm", at: endPoint.position)
    }
    
    //MARK: - Displays the distance measured in the scene with a 3D text
    func displayMeasurement(text: String, at position: SCNVector3) {
        
        let textMeasurement = SCNText(string: text, extrusionDepth: 1.5)
        textMeasurement.firstMaterial?.diffuse.contents = UIColor.red
        
        let textNode = SCNNode(geometry: textMeasurement)
        textNode.position = SCNVector3(position.x, position.y, position.z)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }

}
