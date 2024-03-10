import UIKit
import CoreBluetooth
import CoreLocation

func styleButton(_ button: UIButton?, backgroundColor: UIColor, titleColor: UIColor) {
    var config = UIButton.Configuration.filled()
    config.baseBackgroundColor = backgroundColor
    config.baseForegroundColor = titleColor // For the text color
    config.cornerStyle = .medium // Adjusts the corner radius
    
    // Customizing the title
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
        var outgoing = incoming
        outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return outgoing
    }

    // Padding and content insets
    config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    
    // Shadow (UIButton.Configuration does not directly support shadows, so add them to the layer)
    button?.layer.shadowColor = UIColor.black.cgColor
    button?.layer.shadowOffset = CGSize(width: 0, height: 2)
    button?.layer.shadowRadius = 4
    button?.layer.shadowOpacity = 0.3

    // Optional: Add a border (since UIButton.Configuration does not support borders, add them to the layer)
    button?.layer.borderWidth = 0
    button?.layer.borderColor = backgroundColor.darker(by: 15)?.cgColor

    // Applying the configuration to the button only once, after all modifications
    button?.configuration = config
}
