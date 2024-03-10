import UIKit
import CoreBluetooth
import CoreLocation

extension ViewController: BluetoothManagerDelegate {
    func didUpdateConnectionState(connected: Bool) {
        DispatchQueue.main.async {
            if connected {
                self.updateUIForConnectedState()
            } else {
                self.updateUIForDisconnectedState()
            }
        }
    }

    func didDiscoverPeripheral(peripheral: CBPeripheral) {
        bluetoothManager.connect(peripheral: peripheral)
    }

    func didReceiveValue(value: String) {
        print("Received value: \(value)")
    }
}

extension ViewController: LocationManagerDelegate {
    func didUpdateLocations(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, heading: CLLocationDirection) {
        DispatchQueue.main.async {
            self.coordinatesLabel.text = """
            Lat: \(latitude)
            Long: \(longitude)
            Altitude: \(altitude) meters
            Heading: \(heading)°
            """
        }
    }
    
    func didFailWithError(error: Error) {
            print("Location Error: \(error.localizedDescription)")
            // Handle the error appropriately in your app, maybe show an alert to the user
        }
}

extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
}

