import Foundation

class SimulatedDriver : NSObject, ReaderDriver {
  private var isReaderConnected: Bool
  private var tagToFind: String?
  private var isRfidOn: Bool
  private var isRfidScan: Bool
  private var isBarcodeOn: Bool
  private var powerPercentage: Float
  private var sendBarcode: (String) -> Void
  private var sendRfid: (Tag) -> Void
  
  required init(onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {
    isReaderConnected = false
    tagToFind = nil
    isRfidOn = false
    isRfidScan = false
    isBarcodeOn = false
    powerPercentage = 100
    sendBarcode = onBarcodeScan
    sendRfid = onRfidScan
  }
  
  func getDeviceDetails() throws -> [String: String] {
    return ["name": "simulated"]
  }

  func getDriverVersion() throws -> [String: String] {
    return ["driverVersion": "1.0"]
  }
  
  func isAvailable() -> Bool {
    return true
  }
  
  func connect(_ address: String) throws {
    isReaderConnected = true
  }
  
  func disconnect() throws {
    isReaderConnected = false
    tagToFind = nil
    isRfidOn = false
    isRfidScan = false
    isBarcodeOn = false
  }
  
  func isConnected() -> Bool {
    return isReaderConnected
  }
  
  func getBatteryPercentage() -> Int {
    return 99
  }
  
  func switchToRfidMode() throws {
    try checkConnection()
    isBarcodeOn = false
    isRfidOn = true
  }
  
  func startRfidScan() throws {
    try checkConnection()
    try switchToRfidMode()
    isRfidOn = true
    isRfidScan = true
  }
  
  func stopRfidScan() throws {
    try checkConnection()
    isRfidScan = false
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    try checkConnection()
    self.tagToFind = tagToFind
  }
  
  func stopReading() throws {
    try checkConnection()
    tagToFind = nil
    isRfidOn = false
    isBarcodeOn = false
  }
  
  func switchToBarcodeMode() throws {
    try checkConnection()
    isRfidOn = false
    isRfidScan = false
    isBarcodeOn = true
  }
  
  func getReaderPowerRange() throws -> (Int, Int) {
    return (0, 30)
  }
  
  func getReaderPower() throws -> Float {
    try checkConnection()
    return powerPercentage
  }
  
  func configureReaderPower(_ powerPercentage: Float) throws {
    try checkConnection()
    self.powerPercentage = powerPercentage
  }
  
  func simulateBarcodeScan(_ barcodes: [String]) throws {
    if (isReaderConnected && isBarcodeOn) {
      for barcode in barcodes {
        sendBarcode(barcode)
      }
    } else {
      throw NSError(domain: "BarcodeReaderNotActivatedError", code: 403)
    }
  }
  
  func simulateTagRead(_ tags: [Tag]) throws {
    try checkConnection()
    if (isReaderConnected && isRfidOn && isRfidScan) {
      for tag in tags {
        if (tagToFind == nil || (tagToFind != nil && tag.epc == tagToFind)) {
          sendRfid(tag)
        }
      }
    } else {
      throw NSError(domain: "RFIDReaderNotActivatedError", code: 403)
    }
  }
  
  func checkConnection() throws {
    if (!isReaderConnected) {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
}
