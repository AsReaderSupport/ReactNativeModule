import Foundation
import AsReaderDockSDK

class AsReaderDockDriver: NSObject, ReaderDriver, AsreaderBarcodeDeviceDelegate, AsReaderRFIDDeviceDelegate, AsReaderDeviceDelegate {
  private static let POWER_MIN: Float = 13
  private static let POWER_MAX: Float = 24
  private static let RSSI_MIN: Float = -75
  private static let RSSI_MAX: Float = -15
  private let device: DeviceShadow
  private var curTag: Tag?
  private var isReaderConnected: Bool
  private var isContinuousScanMode: Bool
  private var tagToFind: String?
  private var sendBarcode: (String) -> Void
  private var sendRfid: (Tag) -> Void
  private var battery: Int
  
  required init(device: DeviceShadow, onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {
    self.device = device
    isReaderConnected = false
    tagToFind = nil
    sendBarcode = onBarcodeScan
    sendRfid = onRfidScan
    battery = 0
    isContinuousScanMode = false
    super.init()
    self.device.setDelegate(self)
    self.device.getOutputPowerLevel()
  }
  
  func getDeviceDetails() throws -> [String: String] {
    if (device.isOpened()) {
      let info = AsReaderInfo()
      return [
        "name": "AsReaderDock",
        "firmware_version": info.deviceFirmware,
        "hardware": info.deviceHardware,
        "device_id": info.deviceID,
        "manufacturer": info.deviceManufacturer,
        "model_number": info.deviceModelNumber,
        "serial_number": info.deviceSerialNumber,
        "device_name": info.deviceName
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
    isContinuousScanMode = false
    isReaderConnected = true
    tagToFind = nil
  }
  
  func disconnect() throws {
    if (!device.isOpened()) {
      throw ReaderDriverError.ReaderNotFoundError
    }
    isReaderConnected = false
    self.tagToFind = nil
    device.turnOff()
  }
  
  func isConnected() -> Bool {
    return isReaderConnected
  }
  
  func getBatteryPercentage() throws -> Int {
    try checkConnection()
    return max(Int(device.getCurrentBattery()), battery)
  }
  
  func switchToRfidMode() throws {
    try checkConnection()
    self.tagToFind = nil
    device.setTriggerModeDefault(false)
    device.activateRfidReader()
    isContinuousScanMode = false
  }
  
  func startRfidScan() throws {
    try switchToRfidMode()
    do {
        sleep(1)
    }
    device.startReadTagsAndRssi(withTagNum: 1, maxTime: 0, repeatCycle: 0)
    isContinuousScanMode = true
  }
  
  func stopRfidScan() throws {
    try checkConnection()
    device.stopScan()
    isContinuousScanMode = false
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    try checkConnection()
    try startRfidScan()
    self.tagToFind = tagToFind
  }
  
  func stopReading() throws {
    try checkConnection()
    self.tagToFind = nil
    device.turnOff()
  }
  
  func switchToBarcodeMode() throws {
    try checkConnection()
    device.setTriggerModeDefault(true)
    device.activateBarcodeReader()
    isContinuousScanMode = false
  }
  
  func getReaderPowerRange() throws -> (Int, Int) {
    return (Int(AsReaderDockDriver.POWER_MIN), Int(AsReaderDockDriver.POWER_MAX))
  }
  
  func getReaderPower() throws -> Float {
    try checkConnection()
    let info = AsReaderInfo()
    return valueToPercentage(info.rfidPower, min: AsReaderDockDriver.POWER_MIN, max: AsReaderDockDriver.POWER_MAX)
  }
  
  func configureReaderPower(_ powerPercentage: Float) throws {
    try checkConnection()
    device.setOutputPowerLevel(Int32(percentageToValue(
      powerPercentage,
      min: AsReaderDockDriver.POWER_MIN,
      max: AsReaderDockDriver.POWER_MAX)
    ))
    device.getOutputPowerLevel()
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
    let tag = pcEpc.hexEncodedString()
    if (tagToFind == nil || tag == tagToFind) {
      curTag = Tag(
        epc: String(tag.dropFirst(4)),
        rssi: Int(rssi),
        scaledRssi: Int(valueToPercentage(Float(rssi), min: AsReaderDockDriver.RSSI_MIN, max: AsReaderDockDriver.RSSI_MAX)),
        tagCount: 1,
        tid: ""
      )
      device.startReadTagAndTid(withTagNum: 0, maxTime: 0, repeatCycle: 0)
      // TODO: Consider adding Swift equivalent of Java ticket to only send this once, not for each tag.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.curTag = nil
        self.device.stopScan()
        if (self.isContinuousScanMode) {
          self.device.startReadTagsAndRssi(withTagNum: 1, maxTime: 0, repeatCycle: 0)
        }
      }
    }
  }

// Having to read twice harms performance, and is only needed for QC Checker app so
  func epcReceived(_ epc: Data, tid: Data) {
    if (curTag == nil) {
      device.stopScan()
    } else {
      let tag = epc.hexEncodedString()
      if (curTag!.epc.contains(tag)) {
        let maxLength: Int = 32
        curTag?.tid = String(tid.hexEncodedString().prefix(maxLength))
        sendRfid(curTag!)
        curTag = nil
        device.stopScan()
      }
    }
  }
  
  func pushedTriggerButton() {
    device.startReadTagsAndRssi(withTagNum: 1, maxTime: 0, repeatCycle: 0)
  }
  
  func releasedTriggerButton() {
    if (!isContinuousScanMode) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.device.stopScan()
      }
    }
  }
  
  func batteryReceived(_ battery: Int32) {
    self.battery = Int(battery)
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
