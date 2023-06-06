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

protocol ReaderDriver: NSObject {

  /**
   * Returns details of the device, like firmware and serial number
   * @return an object with details about the device
   */
  func getDeviceDetails() throws -> [String: String]

  /**
   * Returns version of the driver/device, eg driver version, SDK version
   * @return an object with version info for the driver
   */
  func getDriverVersion() throws -> [String: String]

  /**
   * Returns whether the reader is available to be connected to (eg plugged in, connected via bluetooth)
   * @return true if it is available false if it is not
   */
  func isAvailable() -> Bool
  
  /**
   * Connects to the reader
   * @param address of the reader to connect to if needed
   * @throws ReaderNotFoundError if the reader is not found and could not connect
   */
  func connect(_ address: String) throws
  
  /**
   * Disconnects from the reader
   * @throws ReaderConnectionError if reader is not connected
   */
  func disconnect() throws
  
  /**
   * Returns whether the reader is connected
   * @return true if the reader and driver are connected, false otherwise
   */
  func isConnected() -> Bool
  
  /**
   * @return the battery percentage of the device
   */
  func getBatteryPercentage() throws -> Int
  
  /**
   * Switches to RFID reading mode, where RFID tags are read when the trigger
   * is pressed
   * @throws ReaderConnectionError if reader is not connected
   */
  func switchToRfidMode() throws
  
  /**
   * Makes the reader start reading RFID tags without needing a trigger press
   * @throws ReaderConnectionError if reader is not connected
   */
  func startRfidScan() throws
  
  /**
   * Makes the reader stop reading RFID tags without needing a trigger press
   * @throws ReaderConnectionError if reader is not connected
   */
  func stopRfidScan() throws
  
  /**
   * Starts searching for the given tag and will only send an event for this
   * tag with its signal strength
   * @param tagToFind the tag to search for
   */
  func activateSearchMode(_ tagToFind: String) throws
  
  /**
   * Stops searching for a tag, returning to the default mode of returning all
   * read tags
   */
  func stopSearchMode() throws
  
  /**
   * Switches to barcode scanning mode, where barcodes are read when the trigger
   * is pressed
   * @throws ReaderConnectionError if reader is not connected
   */
  func switchToBarcodeMode() throws
}
