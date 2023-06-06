import Foundation
import AsReaderDockSDK

class AsReaderDockDriver: NSObject, ReaderDriver, AsreaderBarcodeDeviceDelegate, AsReaderRFIDDeviceDelegate, AsReaderDeviceDelegate {
  private let device: DeviceShadow
  private var isReaderConnected: Bool
  private var tagToFind: String?
  private var sendBarcode: (String) -> Void
  private var sendRfid: (Tag) -> Void
  
  required init(device: DeviceShadow, onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {
    self.device = device
    isReaderConnected = false
    tagToFind = nil
    sendBarcode = onBarcodeScan
    sendRfid = onRfidScan
    super.init()
    self.device.setDelegate(self)
  }
  
  func getDeviceDetails() throws -> [String: String] {
    if (device.isOpened()) {
      let info = AsReaderInfo()
      return [
        "name": "AsReaderDock",
        "firmware": info.deviceFirmware,
        "hardware": info.deviceHardware,
        "deviceID": info.deviceID,
        "manufacturer": info.deviceManufacturer,
        "model number": info.deviceModelNumber,
        "serial number": info.deviceSerialNumber,
        "deviceName": info.deviceName
      ]
    }
    throw ReaderDriverError.ReaderNotFoundError
  }

  func getDriverVersion() throws -> [String: String] {
    return ["driverVersion": "1.0", "sdkVersion": device.getSDKVersion()]
  }

  func isAvailable() -> Bool {
    return device.isOpened()
  }
  
  func connect(_ address: String) throws {
    if (!device.isOpened()) {
      throw ReaderDriverError.ReaderNotFoundError
    }
    isReaderConnected = true
    tagToFind = nil
  }
  
  func disconnect() throws {
    if (!device.isOpened()) {
      throw ReaderDriverError.ReaderNotFoundError
    }
    isReaderConnected = false
    tagToFind = nil
    _ = device.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: 0)
    _ = device.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: 1)
  }
  
  func isConnected() -> Bool {
    return isReaderConnected
  }
  
  func getBatteryPercentage() -> Int {
    return Int(device.getCurrentBattery())
  }
  
  func switchToRfidMode() throws {
    try checkConnection()
    device.setTriggerModeDefault(false)
    _ = device.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: 0)
    _ = device.setReaderPower(true, beep: true, vibration: true, led: true, illumination: true, mode: 1)
  }
  
  func startRfidScan() throws {
    try switchToRfidMode()
    do {
        sleep(1)
    }
    _ = device.startReadTagsAndRssi(withTagNum: 0, maxTime: 0, repeatCycle: 0)
  }
  
  func stopRfidScan() throws {
    try checkConnection()
    _ = device.stopScan()
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    try checkConnection()
    self.tagToFind = tagToFind
  }
  
  func stopSearchMode() throws {
    try checkConnection()
    tagToFind = nil
  }
  
  func switchToBarcodeMode() throws {
    try checkConnection()
    device.setTriggerModeDefault(true)
    _ = device.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: 1)
    _ = device.setReaderPower(true, beep: true, vibration: true, led: true, illumination: true, mode: 0)
  }
  
  func checkConnection() throws {
    if (!device.isOpened()) {
      throw ReaderDriverError.ReaderNotFoundError
    } else if (!isReaderConnected) {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
  // Delegate/overwritten functions
  
  func barcodeDataReceived(_ data: Data!) {
    var bytes = [UInt8](data)
    // Scanned barcodes have extraneous 0x80 byte and trigger press sends 0x0 or 0xFF so we remove these
    if (!bytes.isEmpty && (bytes[0] == 0x0 || bytes[0] == 0x80 || bytes[0] == 0xFF)) {
      bytes.removeFirst()
    }
    if !bytes.isEmpty, let tag = String(bytes: bytes, encoding: .utf8) {
      sendBarcode(tag)
    }
  }
  
  func pcEpcRssiReceived(_ pcEpc: Data!, rssi: Int32) {
    let pcEpc = pcEpc.hexEncodedString()
    if (
      !pcEpc.isEmpty &&
      (tagToFind == nil || (tagToFind != nil && pcEpc == tagToFind))
    ) {
      sendRfid(Tag(epc: pcEpc, rssi: Int(rssi), tagCount: 1, tid:""))
    }
  }
  
  func pushedTriggerButton() {
    _ = device.startReadTagsAndRssi(withTagNum: 0, maxTime: 0, repeatCycle: 0)
  }
  
  func releasedTriggerButton() {
    _ = device.stopScan()
  }
  
  // required to extend AsReaderDeviceDelegate 
  func plugged(_ plug: Bool) {}
  
  func readerConnected(_ status: Int32) {}
  
}

extension Data {
  func hexEncodedString() -> String {
    return map { String(format: "%02hhx", $0) }.joined()
  }
}
