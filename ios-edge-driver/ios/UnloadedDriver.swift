class UnloadedDriver: ReaderDriver {
  init() {}
  
  required init(onBarcodeScan: @escaping (String) -> Void, onRfidScan: @escaping (Tag) -> Void) {}

  func getDeviceDetails() throws -> [String: String] {
    throw ReaderDriverError.NoDriverLoadedError
  }

  func getDriverVersion() throws -> [String: String] {
    throw ReaderDriverError.NoDriverLoadedError
  }

  func isAvailable() -> Bool {
    return false
  }
  
  func connect(_ address: String) throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func disconnect() throws {}
  
  func isConnected() -> Bool {
      return false
  }
  
  func getBatteryPercentage() -> Int {
    return -1
  }
  
  func switchToRfidMode() throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func startRfidScan() throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func stopRfidScan() throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func activateSearchMode(_ tagToFind: String) throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func stopReading() throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func switchToBarcodeMode() throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func getReaderPowerRange() throws -> (Int, Int) {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func getReaderPower() throws -> Float {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func configureReaderPower(_ powerPercentage: Float) throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func onBarcodeScan(callback: @escaping (String) -> Void) throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
  func onRfidScan(callback: @escaping (Tag) -> Void) throws {
    throw ReaderDriverError.NoDriverLoadedError
  }
  
}
