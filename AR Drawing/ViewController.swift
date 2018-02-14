//
//  ViewController.swift
//  AR Drawing
//
//  Created by deepak yadav on 11/02/18.
//  Copyright © 2018 deepak yadav. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var draw: UIButton!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.showsStatistics =  true
        self.sceneView.session.run(configuration)
        
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //run 60 sec per second
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
      
        
       
        
        //getting camera point
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        //orientation of camera
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                print("render")
                let sphereNode = SCNNode(geometry :SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }else {
                
                let pointer = SCNNode(geometry :SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                                pointer.position = currentPositionOfCamera
                
                                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                                    if node.name == "pointer" {
                                         node.removeFromParentNode()
                                    }
                
                                })
                
                
//                let pointer = SCNNode(geometry :SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
//                pointer.position = currentPositionOfCamera
//
//                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
//                    if node.geometry is SCNBox {
//                         node.removeFromParentNode()
//                    }
//
//                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
                
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
            }
        }
        
    }

  
}
func +(left : SCNVector3 , right : SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
