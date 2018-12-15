import UIKit
import ARKit
import ARVideoKit

class EmojiBlingViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var picker: MustachePicker!
    let noseOptions = ["-"]
    var recorder: RecordAR?
    let pickerHt : CGFloat = 150

    // Recorder UIButton. This button will start and stop a video recording.
    lazy var recorderButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Record", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
        let y: CGFloat = view.frame.maxY - (pickerHt + 32)
        btn.center = CGPoint(x: UIScreen.main.bounds.width/2, y: y)
        btn.layer.cornerRadius = btn.bounds.height/2
        btn.tag = 0
        return btn
    }()

    // Pause UIButton. This button will pause a video recording.
    lazy var pauseButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Pause", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let y: CGFloat = view.frame.maxY - (pickerHt + 32)
        btn.center = CGPoint(x: UIScreen.main.bounds.width*0.15, y: y)
        btn.layer.cornerRadius = btn.bounds.height/2
        btn.alpha = 0.3
        btn.isEnabled = false
        return btn
    }()

    // GIF UIButton. This button will capture a GIF image.
    lazy var gifButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("GIF", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let y: CGFloat = view.frame.maxY - (pickerHt + 32)
        btn.center = CGPoint(x: UIScreen.main.bounds.width*0.85, y: y)
        btn.layer.cornerRadius = btn.bounds.height/2
        return btn
    }()

    var emojiNode: EmojiNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }

        sceneView.delegate = self
        setupPicker()

        self.view.addSubview(recorderButton)
        self.view.addSubview(pauseButton)
        self.view.addSubview(gifButton)

        // Initialize with SpriteKit scene
        recorder = RecordAR(ARSceneKit: sceneView)

        // Specifiy supported orientations
        recorder?.inputViewOrientations = [.portrait]


        recorderButton.addTarget(self, action: #selector(recorderAction(sender:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseAction(sender:)), for: .touchUpInside)
        gifButton.addTarget(self, action: #selector(gifAction(sender:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1
        let configuration = ARFaceTrackingConfiguration()

        // 2
        sceneView.session.run(configuration)
        recorder?.prepare(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 1
        sceneView.session.pause()
        recorder?.rest()
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
        let x: CGFloat = 0
        let y: CGFloat = self.view.frame.maxY - pickerHt
        let wt: CGFloat = view.frame.width
        
        let frame = CGRect(x: x, y: y, width: wt, height: pickerHt)
        picker = MustachePicker(frame: frame)
        self.view.addSubview(picker)
        picker.delegate = self
    }

    @objc func recorderAction(sender:UIButton) {

        if recorder?.status == .readyToRecord {
            // Start recording
            recorder?.record()

            // Change button title
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(.red, for: .normal)

            // Enable Pause button
            pauseButton.alpha = 1
            pauseButton.isEnabled = true

            // Disable GIF button
            gifButton.alpha = 0.3
            gifButton.isEnabled = false
        }else if recorder?.status == .recording || recorder?.status == .paused {
            // Stop recording and export video to camera roll
            recorder?.stopAndExport()

            // Change button title
            sender.setTitle("Record", for: .normal)
            sender.setTitleColor(.black, for: .normal)

            // Enable GIF button
            gifButton.alpha = 1
            gifButton.isEnabled = true

            // Disable Pause button
            pauseButton.alpha = 0.3
            pauseButton.isEnabled = false
        }

    }

    @objc func pauseAction(sender:UIButton) {
        if recorder?.status == .recording {
            // Pause recording
            recorder?.pause()

            // Change button title
            sender.setTitle("Resume", for: .normal)
            sender.setTitleColor(.blue, for: .normal)
        } else if recorder?.status == .paused {
            // Resume recording
            recorder?.record()

            // Change button title
            sender.setTitle("Pause", for: .normal)
            sender.setTitleColor(.black, for: .normal)
        }
    }

    @objc func gifAction(sender:UIButton) {
        self.gifButton.isEnabled = false
        self.gifButton.alpha = 0.3
        self.recorderButton.isEnabled = false
        self.recorderButton.alpha = 0.3

        recorder?.gif(forDuration: 1.5, export: true) { _, _, _ , exported in
            if exported {
                DispatchQueue.main.sync {
                    self.gifButton.isEnabled = true
                    self.gifButton.alpha = 1.0
                    self.recorderButton.isEnabled = true
                    self.recorderButton.alpha = 1.0
                }
            }
        }
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
//        let noseNode = EmojiNode(with: noseOptions)
        emojiNode = EmojiNode(with: noseOptions)
        

        // 3
        emojiNode?.name = "mustache"

        // 4
        node.addChildNode(emojiNode!)

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


extension EmojiBlingViewController : PickerDelegate {
    
    func didPickMustache(pos: Int) {
        emojiNode?.update(with: pos)
    }
}
