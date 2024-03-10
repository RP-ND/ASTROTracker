import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocations(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, heading: CLLocationDirection)
    func didFailWithError(error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    weak var delegate: LocationManagerDelegate?
    private var lastValidHeading: CLLocationDirection = -1
    
    // Computed property to expose the current location
    var location: CLLocation? {
        return locationManager.location
    }

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading() // Start receiving heading updates if available
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let altitude = userLocation.altitude

        delegate?.didUpdateLocations(latitude: latitude, longitude: longitude, altitude: altitude, heading: userLocation.course)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard let currentLocation = locationManager.location else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        let altitude = currentLocation.altitude
        let heading = newHeading.magneticHeading  // Get magnetic heading

//        var heading = newHeading.trueHeading
//        
//        if heading < 0 { // If the true heading is invalid
//            if lastValidHeading >= 0 { // And we have a previously valid heading
//                heading = lastValidHeading // Use the last valid heading
//            } else {
//                // Here you could choose to do nothing or use magnetic heading or another placeholder
//                // For example, if you want to use magnetic heading when true heading is not available:
//                heading = newHeading.magneticHeading
//            }
//        } else {
//            lastValidHeading = heading // Update last valid heading with the new valid value
//        }

        delegate?.didUpdateLocations(latitude: latitude, longitude: longitude, altitude: altitude, heading: heading)
    }



    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
}
