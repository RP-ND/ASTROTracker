### Notre Dame Rocketry Data Communication App

This **Swift iOS application** is designed for effective communication with the University of Notre Dame's rocketry modules. The app plays a crucial role in the data transmission process, facilitating real-time monitoring and analysis of rocketry system performance as well as transmission of GPS coordinates to find the rocket after landing. Here's how it works:

#### Data Transmission Flow:
1. **Rocketry Modules**: 
    - The starting point of the data transmission chain.
    - Transmit data over **LoRa frequencies**.

2. **LilyGo-TBeam Device**:
    - Receives data from the rocketry modules.
    - Equipped with an **ESP32 BLE (Bluetooth Low Energy) system**.
    - Acts as an intermediary, preparing the received data for the iOS device.

3. **iOS Application**:
    - Connects to the LilyGo-TBeam via BLE.
    - Reads and interprets the data made available through the ESP32's BLE characteristics.

#### Key Components:
- **LoRa Frequencies**: Utilized for long-range communication between the rocketry modules and the LilyGo-TBeam.
- **LilyGo-TBeam**: A versatile board that combines LoRa communication capabilities with ESP32's BLE functionality.
- **ESP32 BLE System**: Facilitates wireless data transfer from the LilyGo-TBeam to the iOS device.
- **Swift iOS App**: Provides a user-friendly interface for data analysis and real-time monitoring of the rocketry system.

This setup ensures seamless and efficient data transfer from the rocketry modules to the iOS app, enhancing the capabilities of the University of Notre Dame's rocketry team to monitor and analyze their projects with precision and ease.
