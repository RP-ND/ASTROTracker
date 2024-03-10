import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var sendText1Button: UIButton!
    @IBOutlet weak var sendText2Button: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arrowView: UIImageView!
    
    var bluetoothManager: BluetoothManager!
    var locationManager: LocationManager!
    var shouldRotateArrow = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize BluetoothManager and LocationManager
        bluetoothManager = BluetoothManager()
        bluetoothManager.delegate = self
        
        locationManager = LocationManager()
        locationManager.delegate = self

        setupUI()
        
        rotateArrow()
    }
    
    public func setupUI() {
        updateUIForDisconnectedState()

        // Setup for the logo image view
        imageView.image = UIImage(named: "NDRT_Logo_Shamrock_VF_V1._Transparent") // Replace with your actual image name
        imageView.contentMode = .scaleAspectFit

        // Style the buttons
        styleButton(connectButton, backgroundColor: UIColor.systemGreen, titleColor: UIColor.white)
        styleButton(sendText1Button, backgroundColor: UIColor.systemBlue, titleColor: UIColor.white)
        styleButton(sendText2Button, backgroundColor: UIColor.systemBlue, titleColor: UIColor.white)
        styleButton(disconnectButton, backgroundColor: UIColor.systemRed, titleColor: UIColor.white)

        // Style the coordinates label
        styleCoordinatesLabel()
    }
    
    func pointArrowTowardsCoordinate(_ targetCoordinate: CLLocationCoordinate2D) {
        shouldRotateArrow = false // Stop the arrow rotation

        guard let currentLocation = locationManager.location?.coordinate else { return }

        let bearing = calculateBearing(from: currentLocation, to: targetCoordinate)
        let bearingRadians = CGFloat(bearing.degreesToRadians)

        // Animate the arrow to point towards the target coordinate
        UIView.animate(withDuration: 0.5) {
            self.arrowView.transform = CGAffineTransform(rotationAngle: bearingRadians)
        }
    }
    
    func rotateArrow() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
            self.arrowView.transform = self.arrowView.transform.rotated(by: CGFloat.pi)
        }) { finished in
            if self.shouldRotateArrow {
                self.rotateArrow()
            }
        }
    }
    
    func styleCoordinatesLabel() {
        coordinatesLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.8) // Semi-transparent white background
        coordinatesLabel.textColor = UIColor.black
        coordinatesLabel.layer.cornerRadius = 8
        coordinatesLabel.layer.masksToBounds = true // Needed to respect the cornerRadius
        coordinatesLabel.textAlignment = .center
        coordinatesLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular) // Monospaced font for better alignment
        
        // Add padding inside the label
        coordinatesLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // Adjust the 10 to increase/decrease padding
        
        // Shadow
        coordinatesLabel.layer.shadowColor = UIColor.black.cgColor
        coordinatesLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        coordinatesLabel.layer.shadowRadius = 10
        coordinatesLabel.layer.shadowOpacity = 0.3
    }



    public func updateUIForConnectedState() {
        connectButton?.isEnabled = false
        disconnectButton?.isEnabled = true
        sendText1Button?.isHidden = false
        sendText2Button.isHidden = false
    }

    public func updateUIForDisconnectedState() {
        connectButton?.isEnabled = true
        disconnectButton?.isEnabled = false
        sendText1Button?.isHidden = true
        sendText2Button?.isHidden = true
    }

    @IBAction func scanButtonTouched(_ sender: Any) {
        bluetoothManager.scanForPeripherals()
    }

    @IBAction func sendText1Touched(_ sender: Any) {
        // Example text to send
        bluetoothManager.sendText(text: "Hello from Text 1!")
    }

    @IBAction func sendText2Touched(_ sender: Any) {
        // Another example text to send
        bluetoothManager.sendText(text: "Hello from Text 2!")
    }

    @IBAction func disconnectTouched(_ sender: Any) {
        bluetoothManager.disconnect()
    }
}
