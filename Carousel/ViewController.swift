//
//  ViewController.swift
//  HeartsandDiamonds
//
//  Created by Dhau' Embun Azzahra on 28/04/24.
//

import UIKit
import SceneKit
import ARKit

import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    //variable to hold shape nodes
    var oxyNode: SCNNode?
    var hidroNode: SCNNode?
    var hidroNode2: SCNNode?
    var backNode: SCNNode?
    var imageNode = [SCNNode]()
    var isJumping = false
    var isJumping2 = false
    
    var audioPlayer: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //enable lighting
        sceneView.autoenablesDefaultLighting = true
        
        //variable for scene
        let oxyScene = SCNScene(named: "art.scnassets/animated-oxygen2.scn")
        let hidroScene = SCNScene(named: "art.scnassets/animated-hidrogen2.scn")
        let hidroScene2 = SCNScene(named: "art.scnassets/animated-hidrogen2.scn")
        let backCardScene = SCNScene(named: "art.scnassets/water2.scn")
        
        //assign node
        oxyNode = oxyScene?.rootNode
        hidroNode = hidroScene?.rootNode
        hidroNode2 = hidroScene2?.rootNode
        backNode = backCardScene?.rootNode

        
        
    }
    
    //image tracking (untuk posisi keluar arnya)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //ar image tracking configuration --> A configuration that tracks known images using the rear-facing camera.
        let configuration = ARImageTrackingConfiguration()
        
        // Set the AR reference images (detect card images)
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "PlayingCards", bundle: Bundle.main){
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 4
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //ARSCNViewDelegate
    //create an ar image anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            let size = imageAnchor.referenceImage.physicalSize
            
            // Creating a plane geometry
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0) //nanti 1 ganti ke 0.3/0 biar transparent
            plane.cornerRadius = 0.005
            
            // Creating a plane node
            let planeNode = SCNNode(geometry: plane)
            
            //rotate plane --> biar flat
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            
            //show node (condition/card --> arnya keluar apa based on kartu)
            var shapeNode: SCNNode?
            switch imageAnchor.referenceImage.name{
            case CardType.oxygen.rawValue :
                shapeNode = oxyNode
                shapeNode?.name = "oxyNode"
            case CardType.hydrogen.rawValue :
                shapeNode = hidroNode
                shapeNode?.name = "hidroNode"
            case CardType.hydrogen2.rawValue :
                shapeNode = hidroNode2
                shapeNode?.name = "hidroNode2"
            case CardType.backCard.rawValue :
                shapeNode = backNode
                shapeNode?.name = "backnode"
            default :
                break
            }
           

            
            
            //rotate element
            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            let repeatSpin = SCNAction.repeatForever(shapeSpin)
            shapeNode?.runAction(repeatSpin)
            
            
            guard let shape = shapeNode else{
                return nil
            }
            node.addChildNode(shape)
            imageNode.append(node)
            return node
            
            
            
        }
        
        return nil
    }
    
    //distance manipulation
    func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if imageNode.count == 3{
            //            var oxygenNode: SCNNode?
            //            var hydrogenNode: SCNNode?
            //            var hydrogenNode2: SCNNode?
            //            var position1: GLKVector3? //oxygenNode
            //            var position2: GLKVector3? //hydro
            //            var position3: GLKVector3? //hydro
            //            var oxygenPosition: SCNVector3?
            
            //            for theNode in imageNode{
            //                if theNode.name == "oxyNode"{
            //                    oxygenNode = theNode
            //                    print("oxygenNode exist")
            //                } else if theNode.name == "hidroNode"{
            //                    hydrogenNode = theNode
            //                    print("hydrogenNode exist")
            //                } else{
            //                    hydrogenNode2 = theNode
            //                    print("hydrogenNode2 exist")
            //                }
            //            }
            
            
            
            
            let position1 = SCNVector3ToGLKVector3(imageNode[0].position)
            let position2 = SCNVector3ToGLKVector3(imageNode[1].position)
            var position3 = SCNVector3ToGLKVector3(imageNode[2].position)
            
            var maxDistance = Float(0.08)
            
            if(imageNode[0].childNodes[1].name == "oxyNode"){
                //distance, 0 jump betweeen 1 and 2
//                print("on image node 0")
                let distance = GLKVector3Distance(position1, position2)
                let distance2 = GLKVector3Distance(position1, position3)
                if (distance < maxDistance) && (distance2 < maxDistance){
                    bondElement(firstNode: imageNode[0], secondNode: imageNode[1])
                    bondElement(firstNode: imageNode[0], secondNode: imageNode[2])
                    isJumping = true
                }
                else if ((isJumping && (distance > maxDistance)) || (isJumping && (distance2 > maxDistance))){
                    print("reset jumping image node 0")
                    resetShapeNodePosition(node: imageNode[1])
                    resetShapeNodePosition(node: imageNode[2])
                    isJumping = false
                }
                else{
                    isJumping = false
                }
            }else if (imageNode[1].childNodes[1].name == "oxyNode"){
//                print("on image node 1")
                //1 jump between 0 and 2
                let distance = GLKVector3Distance(position2, position1)
                let distance2 = GLKVector3Distance(position2, position3)
                if (distance < maxDistance) && (distance2 < maxDistance){
                    bondElement(firstNode: imageNode[1], secondNode: imageNode[0])
                    bondElement(firstNode: imageNode[1], secondNode: imageNode[2])
                    isJumping = true
                }
                else if ((isJumping && (distance > maxDistance)) || (isJumping && (distance2 > maxDistance))){
                    print("reset jumping image node 1")
                    resetShapeNodePosition(node: imageNode[0])
                    resetShapeNodePosition(node: imageNode[2])
                    isJumping = false
                }
                else{
                    isJumping = false
                }
            }else{
                //2 jump between 1 and 2
//                print("on image node 2")
                print(imageNode[2].childNodes[1].name)
                let distance = GLKVector3Distance(position2, position3)
                let distance2 = GLKVector3Distance(position1, position3)
                print("distance")
                print(distance)
                print("distance2")
                print(distance2)
                if (distance < maxDistance) && (distance2 < maxDistance){
                    bondElement(firstNode: imageNode[2], secondNode: imageNode[0])
                    bondElement(firstNode: imageNode[2], secondNode: imageNode[1])
                    isJumping = true
                }
                else if ((isJumping && (distance > maxDistance)) || (isJumping && (distance2 > maxDistance))){
                    print("reset jumping image node 2")
                    resetShapeNodePosition(node: imageNode[2])
                    resetShapeNodePosition(node: imageNode[1])
                    isJumping = false
                }
                else{
                    isJumping = false
                }
            }
            
            //if node exist, calculate the distance
            //            if let oxygenNode = oxygenNode{
            //                position1 = SCNVector3ToGLKVector3(oxygenNode.position)
            //                if let hydrogenNode = hydrogenNode{
            //                    position2 = SCNVector3ToGLKVector3(hydrogenNode.position)
            //                    let distance = GLKVector3Distance(position1!, position2!)
            //
            //                    if distance < 0.07{
            //                        bondElement(firstNode: oxygenNode, secondNode: hydrogenNode, isJumping: isJumping)
            //                        isJumping = true
            //                    }
            //                    else if (isJumping && (distance > 0.07)){
            //                        resetShapeNodePosition(node: hydrogenNode)
            //                        isJumping = false
            //                    }
            //                    else{
            //                        isJumping = false
            //                    }
            //                }
            //                if let hydrogenNode2 = hydrogenNode2{
            //                    position3 = SCNVector3ToGLKVector3(hydrogenNode2.position)
            //                    let distance = GLKVector3Distance(position1!, position3!)
            //
            //                    if distance < 0.07{
            //                        bondElement(firstNode: oxygenNode, secondNode: hydrogenNode2, isJumping: isJumping2)
            //                        isJumping2 = true
            //                    }
            //                    else if (isJumping && (distance > 0.07)){
            //                        resetShapeNodePosition(node: hydrogenNode2)
            //                        isJumping2 = false
            //                    }
            //                    else{
            //                        isJumping2 = false
            //                    }
            //                }
            //
            //            }
            
            
            
            
            
            
            
            //
            //
            //            if distance < 0.07{
            //                bondElement(firstNode: imageNode[0], secondNode: imageNode[1])
            //                isJumping = true
            //            }
            //            else if (isJumping && (distance > 0.07)){
            //                resetShapeNodePosition(node: imageNode[1])
            //                isJumping = false
            //            }
            //            else{
            //                isJumping = false
            //            }
            
        }
    }
    
    //balikan posisi awal
    func resetShapeNodePosition(node: SCNNode){
        let shapeNode = node.childNodes[1]
        
        // Move the shape node back to its initial position
        let moveBack = SCNAction.move(to: node.childNodes[0].position, duration: 0.5)
        shapeNode.runAction(moveBack)
    }
    
    // Function to play the jump sound
        func playJumpSound() {
            guard let url = Bundle.main.url(forResource: "twinkle-sound-effect", withExtension: "mpeg") else {
                print("Sound file not found")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    
    
    
    //function animasi gabungin element (bonding)
    func bondElement(firstNode: SCNNode, secondNode: SCNNode) {
        
        if isJumping {
            return
        }
        
        playJumpSound()
        
        let shapeNode = secondNode.childNodes[1]
        
        let sourcePosition = firstNode.position
        let targetPosition = secondNode.position
        
        //cari selisih jarak antara 2 object
        let displacementVector = SCNVector3(
            targetPosition.x - sourcePosition.x,
            targetPosition.y - sourcePosition.y,
            targetPosition.z - sourcePosition.z
        )
        
        print(secondNode.childNodes[1].name)
        
        print("source position")
        print(sourcePosition)
        
        print("target position")
        print(targetPosition)
        
        print("displacement vector")
        print(displacementVector)
        
        print("x ke kanan")
        let positiveRight = (secondNode.boundingBox.min.x) < (secondNode.boundingBox.max.x)
        print((secondNode.boundingBox.min.x) < (secondNode.boundingBox.max.x))
        
        //ambil selisih jarak dari setiap koordinat
        let deltaX = displacementVector.x
        let deltaY = displacementVector.y
        let deltaZ = displacementVector.z
        
        
        var direction = 1
        

        if positiveRight && (deltaX > 0){
             direction = -1
        }
        if !positiveRight && (deltaX < 0){
             direction = -1
        }
        
        //spin faster
        let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 0.5)
        shapeSpin.timingMode = .easeInEaseOut
        
        //jump
        let up = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 0.5)
        up.timingMode = .easeInEaseOut
        let down = up.reversed()
        let upDown = SCNAction.sequence([up, down])
        
        //move to compund
//        let move = SCNAction.moveBy(x: CGFloat(-deltaX+0.0005*(deltaX>0 ? -1 : 1)), y: 0, z:0, duration: 0.5)
        
//        let move = SCNAction.moveBy(x: CGFloat(Float(direction)*abs(deltaX)+0.008*(deltaX>0 ? -1 : 1)), y: 0, z:0, duration: 0.5)
        
        let move = SCNAction.moveBy(x: 0, y: 0, z:CGFloat(Float(direction)*abs(deltaX)+0.008*(deltaX>0 ? -1 : 1)), duration: 0.5)

        
        print("move by")
        print(CGFloat(Float(direction)*abs(deltaX)))

        
    
        move.timingMode = .easeIn
        
        shapeNode.runAction(move){
            // Now the action has completed, so we can query the global position
            let globalPosition = shapeNode.presentation.worldPosition
            print("global position")
            print(globalPosition)
            
            let squaredDifferenceX = pow(globalPosition.x - sourcePosition.x, 2)
            
            let squaredDeltaX = pow(deltaX, 2)
            if(squaredDifferenceX > squaredDeltaX){
//                let moveAgain = SCNAction.moveBy(x: CGFloat(2*(deltaX)+0.008*(deltaX>0 ? -1 : 1)), y: 0, z:0, duration: 0.5)
                let moveAgain = SCNAction.moveBy(x: 0, y: 0, z:CGFloat(2*(deltaX)+0.008*(deltaX>0 ? -1 : 1)), duration: 0.5)
                shapeNode.runAction(moveAgain)
                shapeNode.runAction(shapeSpin)
                shapeNode.runAction(upDown)
            }
        }
        
        shapeNode.runAction(shapeSpin)
        shapeNode.runAction(upDown)
        

    }
    
    
    
    //kartu"
    enum CardType :  String {
        case queen = "queen"
        case joker = "joker"
        case minion = "minion"
        case king = "king"
        case oxygen = "OxygenCard"
        case hydrogen = "HydrogenCard"
        case hydrogen2 = "HydrogenCard2"
        case backCard = "back"
    }
    
    
}
