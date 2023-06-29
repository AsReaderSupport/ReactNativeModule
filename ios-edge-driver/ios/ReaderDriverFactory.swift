enum ReaderDriverFactory {
  static func create(
    reader: SupportedReader,
    onBarcodeScan: @escaping (String) -> Void,
    onRfidScan: @escaping (Tag) -> Void
  ) -> ReaderDriver {
    switch reader.modelType {
      case "AsReaderDock":
        return AsReaderDockDriver(device: DeviceAsReader(), onBarcodeScan: onBarcodeScan, onRfidScan: onRfidScan)
      case "AsReaderGun":
        return AsReaderGunDriver(onBarcodeScan: onBarcodeScan, onRfidScan: onRfidScan)
      case "simulated":
        return SimulatedDriver(onBarcodeScan: onBarcodeScan, onRfidScan: onRfidScan)
      default:
        return UnloadedDriver()
    }
  }
}
