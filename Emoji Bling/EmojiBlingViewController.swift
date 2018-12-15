//
//  ViewController.swift
//  Emoji Bling
//
//  Created by Subhransu Behera on 14/12/18.
//  Copyright © 2018 Subhransu Behera. All rights reserved.
//

import UIKit
import ARKit

class EmojiBlingViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var picker: MustachePicker!
    let noseOptions = ["-"]

    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }

        sceneView.delegate = self
        setupPicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1
        let configuration = ARFaceTrackingConfiguration()

        // 2
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 1
        sceneView.session.pause()
    }

    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        // 1
        let child = node.childNode(withName: "mustache", recursively: false) as? EmojiNode

        // 2
        let vertices = [anchor.geometry.vertices[22]]

        // 3
        child?.updatePosition(for: vertices)
    }
    
    func setupPicker() {
        let viewHt : CGFloat = 150
        let x: CGFloat = 0
        let y: CGFloat = self.view.frame.maxY - viewHt
        let wt: CGFloat = view.frame.width
        
        let frame = CGRect(x: x, y: y, width: wt, height: viewHt)
        picker = MustachePicker(frame: frame)
        self.view.addSubview(picker)
    }

    @IBAction func handleTap(_ sender: Any) {
//        // 1
//        let location = (sender as AnyObject).location(in: sceneView)
//
//        // 2
//        let results = sceneView.hitTest(location, options: nil)
//
////        // 3
////        if let result = results.first,
////            let node = result.node as? EmojiNode {
////
////            // 4
////            node.next()
////        }

    }
}

// 1
extension EmojiBlingViewController: ARSCNViewDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        // 3
        guard let device = sceneView.device else {
            return nil
        }

        // 4
        let faceGeometry = ARSCNFaceGeometry(device: device)

        // 5
        let node = SCNNode(geometry: faceGeometry)

        // 1
        node.geometry?.firstMaterial?.transparency = 0.0

        // 2
        let noseNode = EmojiNode(with: noseOptions)

        // 3
        noseNode.name = "mustache"

        // 4
        node.addChildNode(noseNode)

        guard let faceAnchor = anchor as? ARFaceAnchor else {
                return nil
        }

        // 5
        updateFeatures(for: node, using: faceAnchor)

        return node
    }

    // 1
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {

        // 2
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }

        // 3
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}

