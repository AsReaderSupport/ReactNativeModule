import Foundation

class SimulatedDriver : NSObject, ReaderDriver {
  private var isReaderConnected: Bool
  private var tagToFind: String?
  private var isRfidOn: Bool
  private var isRfidScan: Bool
  private var isBarcodeOn: Bool
  private var sendBarcode: (String) -> Void
  private var sendRfid: (Tag) -> Void
  
  required init(onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {
    isReaderConnected = false
    tagToFind = nil
    isRfidOn = false
    isRfidScan = false
    isBarcodeOn = false
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
    if (isReaderConnected) {
      isBarcodeOn = false
      isRfidOn = true
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  func startRfidScan() throws {
    if (isReaderConnected) {
      isRfidOn = true
      isRfidScan = true
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  func stopRfidScan() throws {
    if (isReaderConnected && isRfidOn) {
      isRfidScan = false
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    if (isReaderConnected) {
      self.tagToFind = tagToFind
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  func stopSearchMode() throws {
    if (isReaderConnected) {
      tagToFind = nil
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  func switchToBarcodeMode() throws {
    if (isReaderConnected) {
      isRfidOn = false
      isRfidScan = false
      isBarcodeOn = true
    } else {
      throw ReaderDriverError.ReaderConnectionError
    }
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
    if (isReaderConnected && isRfidOn) {
      for tag in tags {
        if (tagToFind == nil || (tagToFind != nil && tag.epc == tagToFind)) {
          sendRfid(tag)
        }
      }
    } else {
      throw NSError(domain: "RFIDReaderNotActivatedError", code: 403)
    }
  }
}
