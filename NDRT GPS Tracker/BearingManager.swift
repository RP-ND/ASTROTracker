import UIKit
import CoreBluetooth
import CoreLocation

func calculateBearing(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
    let lat1 = source.latitude.degreesToRadians
    let lon1 = source.longitude.degreesToRadians

    let lat2 = destination.latitude.degreesToRadians
    let lon2 = destination.longitude.degreesToRadians

    let deltaLon = lon2 - lon1
    let y = sin(deltaLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
    let bearing = atan2(y, x).radiansToDegrees

    return (bearing + 360).truncatingRemainder(dividingBy: 360) // Normalize to 0-360
}

extension CLLocationDegrees {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
