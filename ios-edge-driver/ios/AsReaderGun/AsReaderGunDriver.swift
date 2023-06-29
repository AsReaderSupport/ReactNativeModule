import AsReaderGunSDK

class AsReaderGunDriver: NSObject, ReaderDriver, AsReaderDelegate {
  private static let RSSI_MIN: Float = -80
  private static let RSSI_MAX: Float = -30
  private var device: AsReader?
//  If AsReaderGUN() is closed then recreated, is seemingly is not able to connect
//  properly, so only create and connect to the reader once
  private static var asReaderGun: AsReaderGUN = AsReaderGUN(deviceModel: "com.asreader.gun")
  private var isReaderConnected: Bool
  private let sendBarcode: (String) -> Void
  private let sendRfid: (Tag) -> Void
    
  required init(onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {
    isReaderConnected = false
    sendBarcode = onBarcodeScan
    sendRfid = onRfidScan
    super.init()
  }
  
  func getDeviceDetails() throws -> [String : String] {
    try checkConnection()
    return [
      "name": "AsReaderGun",
      "firmware_version": device!.firmwareVersion(),
      "serial_number": device!.serialNumber,
    ]
  }
  
  func getDriverVersion() throws -> [String : String] {
    return ["driverVersion": "1.0"]
  }
  
  func isAvailable() -> Bool {
    return DispatchQueue.main.sync {
      return AsReaderGunDriver.asReaderGun.isConnect
    }
  }
  
  func connect(_ address: String) throws {
    DispatchQueue.main.sync {
      self.device = AsReader(asReaderGUN: AsReaderGunDriver.asReaderGun, delegate: self)
      self.device?.setDelegate(self)
      self.device!.rssiMode = true
      self.device!.operationTime = Int32(0)
      self.isReaderConnected = AsReaderGunDriver.asReaderGun.isConnect
    }
    
    if !isReaderConnected {
      self.device?.setDelegate(nil)
      self.device = nil
      throw ReaderDriverError.ReaderNotFoundError
    }
  }
  
  func disconnect() throws {
    try checkConnection()
    try stopReading()
    isReaderConnected = false
    device?.setDelegate(nil)
    device = nil
  }
  
  func isConnected() -> Bool {
    return isReaderConnected
  }
  
  func getBatteryPercentage() throws -> Int {
    try checkConnection()
    return Int(self.device!.batteryStatus() * 25)
  }
  
  func switchToRfidMode() throws {
    try checkConnection()
    DispatchQueue.main.sync {
      device!.stop()
      device?.maskTypeValue = 0
      device!.setScanMode(RFIDScanMode)
    }
  }
  
  func startRfidScan() throws {
    try checkConnection()
    DispatchQueue.main.sync {
      device?.maskTypeValue = 0
      device!.setScanMode(RFIDScanMode)
//      withTidOffset set how much the TID is offset, length is how many bytes of TID to read.
//      Other parameters set the session of the read
      device!.inventory(
        withTidOffset: 0,
        length: 6,
        inventorySession: Session_S0,
        sessionFlag: SessionFlag_AB
      )
    }
  }
  
  func stopRfidScan() throws {
    try checkConnection()
    DispatchQueue.main.sync {
      device!.stop()
    }
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    try checkConnection()
    DispatchQueue.main.sync {
      device!.clearEpcMask()
      device!.maskTypeValue = 2
      
//      First parameter is offset and seemingly needs to be 32 to actually compare to EPC
      device!.addEpcMask(32, length: Int32(tagToFind.count * 4), mask: tagToFind)
      device!.epcMaskMatchMode = false
      device!.setScanMode(RFIDScanMode)
      device!.inventory(
        withTidOffset: 0,
        length: 6,
        inventorySession: Session_S0,
        sessionFlag: SessionFlag_AB
      )
      device!.saveEpcMask()
    }
  }
  
  func stopReading() throws {
    try checkConnection()
    DispatchQueue.main.sync {
      device!.stop()
      device!.stopSync()
    }
  }
  
  func switchToBarcodeMode() throws {
    try checkConnection()
    DispatchQueue.main.async {
      self.device!.setScanMode(BarcodeScanMode)
      self.device!.setBarcodeMode(true, isKeyAction: true)
    }
  }
  
  func getReaderPowerRange() throws -> (Int, Int) {
    let powerRange = device!.powerGainRange()
    return (Int(powerRange.min), Int(powerRange.max))
  }
  
  func getReaderPower() throws -> Float {
    try checkConnection()
    return DispatchQueue.main.sync {
      let powerRange = device!.powerGainRange()
      return valueToPercentage(Float(device!.powerGain), min: Float(powerRange.min), max: Float(powerRange.max))
    }
  }
  
  func configureReaderPower(_ powerPercentage: Float) throws {
    try checkConnection()
    DispatchQueue.main.sync {
      let powerRange = device!.powerGainRange()
//      self.device!.powerGain = Int32(percentageToValue(powerPercentage, min: Float(powerRange.min), max: Float(powerRange.max)))
      device!.powerGain = 300
      device!.powerGain = Int32(percentageToValue(
        powerPercentage,
        min: Float(powerRange.min),
        max: Float(powerRange.max)
      ))
    }
  }
  
  func checkConnection() throws {
    if (!async{ return AsReaderGunDriver.asReaderGun.isConnect }) {
      throw ReaderDriverError.ReaderNotFoundError
    } else if !self.isReaderConnected {
      throw ReaderDriverError.ReaderConnectionError
    }
  }
  
//  from https://stackoverflow.com/questions/40879662/how-to-get-return-value-in-dispatch-block
//  2nd answer.
  @discardableResult func async<T>(_ block: @escaping () -> T) -> T {
    let queue = DispatchQueue.global()
    let group = DispatchGroup()
    var result: T?
    group.enter()
    queue.async(group: group) { result = block(); group.leave(); }
    group.wait()
    return result!
  }

//  AsReaderDelegate functions
  func on(asReaderTriggerKeyEvent status: Bool) -> Bool {
    if (device!.getScanMode() == RFIDScanMode) {
      DispatchQueue.main.async {
        if (status == true) {
          self.device!.inventory(
            withTidOffset: 0,
            length: 6,
            inventorySession: Session_S0,
            sessionFlag: SessionFlag_AB
          )
        } else {
          self.device!.stop()
        }
      }
      return false
    }
    return true
  }
  
  func readTag(
    withTid error: ResultCode,
    actionState action: CommandType,
    epc: String!,
    tid data: String!,
    rssi: Float,
    phase: Float,
    frequency: Float
  ) {
    if (error == ResultNoError) {
      sendRfid(Tag(
        epc: String(epc.dropFirst(4)),
        rssi: Int(rssi),
        scaledRssi: Int(valueToPercentage(rssi, min: AsReaderGunDriver.RSSI_MIN, max: AsReaderGunDriver.RSSI_MAX)),
        tagCount: 1,
        tid: data)
      )
    }
  }
  
  func detect(_ barcodeType: BarcodeType, codeId: String!, barcode: String!) {
   if (barcodeType != BarcodeTypeNoRead && barcode != nil) {
      sendBarcode(barcode)
   }
  }
  
  func updateDeviceState(_ error: ResultCode) {
    if error == ResultNotConnected {
      isReaderConnected = false
    }
  }
}
