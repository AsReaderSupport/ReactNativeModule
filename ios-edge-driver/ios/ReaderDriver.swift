import Foundation

// Exceptions that reader drivers can throw
enum ReaderDriverError: Error {
  case ReaderNotFoundError
  case ReaderConnectionError
  case NoDriverLoadedError
}

extension ReaderDriverError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .ReaderNotFoundError:
      return NSLocalizedString("ReaderNotFoundError: Reader is not available, make sure it is plugged in or connected via bluetooth", comment: "")
    case .ReaderConnectionError:
      return NSLocalizedString("ReaderConnectionError: Reader has not been connected to", comment: "")
    case .NoDriverLoadedError:
      return NSLocalizedString("NoDriverLoadedError: No driver has been successfully loaded", comment: "")
    }
  }
}

protocol ReaderDriver {

  /// Returns details of the device, like firmware and serial number
  ///
  /// - Returns: An object with details about the device
  /// TODO: create type for DeviceDetails
  func getDeviceDetails() throws -> [String: String]

   /// Returns version of the driver/device, eg driver version, SDK version
   ///
   /// - Returns mapping from driver to its version
   /// - Throws
   ///   - ReaderConnectionError if reader has not been connected to
   ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func getDriverVersion() throws -> [String: String]

  /// Returns whether the reader is available to be connected to (eg plugged in, connected via bluetooth)
  ///
  /// - Returns: the availability of this reader
  func isAvailable() -> Bool
  
  
  /// Connects to the reader
  ///
  /// - Parameter address: The address of the reader to connect to if needed
  /// - Throws ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func connect(_ address: String) throws
  
  
  ///Disconnects from the reader
  ///
  /// - Throws ReaderConnectionError if reader is not connected
  func disconnect() throws
  
  /// Returns whether the reader is connected
  ///
  /// - Returns: The connection status of the reader
  func isConnected() -> Bool
  
   /// Returns the battery percentage of the device
   ///
   /// - Returns: The battery percentage of the device
   /// - Throws
   ///   - ReaderConnectionError if reader has not been connected to
   ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func getBatteryPercentage() throws -> Int
  
  /// Switches to RFID reading mode, where RFID tags are read when the trigger is pressed
  ///
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func switchToRfidMode() throws
  
  /// Makes the reader start reading RFID tags without needing a trigger press
  /// 
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func startRfidScan() throws
  
  ///  Makes the reader stop reading RFID tags without needing a trigger press
  ///
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func stopRfidScan() throws
  
  /// Starts searching for the given tag and will only send an event for this tag with its signal strength
  ///
  /// - Parameter tagToFind: The tag to search for
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func activateSearchMode(_ tagToFind: String) throws
  
  /// Stops reading/scanning, turning off barcode or RFID reader
  ///
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func stopReading() throws
  
  
  /// Switches to barcode scanning mode, where barcodes are read when the trigger is pressed
  ///
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func switchToBarcodeMode() throws
  
  /// Gets the range of the power for the RFID reader
  ///
  /// - Returns: The min and maximum power in tuple (min, max)
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func getReaderPowerRange() throws -> (Int, Int)
  
  /// Gets the percentage of the power of the RFID reader
  ///
  /// - Returns: The percentage of the power of the RFID reader
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func getReaderPower() throws -> Float
  

  /// Sets the RFID reader strength to given power
  ///
  /// - Parameter power: The percentage of the power to set the reader to
  /// - Throws
  ///   - ReaderConnectionError if reader has not been connected to
  ///   - ReaderNotFoundError if the reader is not available via bluetooth or USB/lightning port
  func configureReaderPower(_ powerPercentage: Float) throws
}
