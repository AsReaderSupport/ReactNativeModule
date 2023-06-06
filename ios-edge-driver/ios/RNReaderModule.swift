import React

@objc(RNReaderModule)
class RNReaderModule : RCTEventEmitter {
  private var reader: ReaderDriver = UnloadedDriver()
  private static let supportedReaders: [SupportedReader] = [
    SupportedReader(vendor: "AsReader", model: "ASR-0230D", modelType: "AsReaderDock", inputType: .usb),
    SupportedReader(vendor: "AsReader", model: "ASR-L251G", modelType: "AsReaderGun", inputType: .usb),
  ]
  
  @objc func getSupportedReaders(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    resolve(RNReaderModule.supportedReaders.map { $0.asDictionary() })
  }
  
  @objc func getAvailable(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    var available: [[String: String]] = []
    for supportedReader in RNReaderModule.supportedReaders {
      let r = ReaderDriverFactory.create(reader: supportedReader, onBarcodeScan: sendBarcode, onRfidScan: sendRfid)
      if r.isAvailable() {
        var readerDetails = supportedReader.asDictionary()
        do {
          try r.connect("")
          readerDetails["serialNumber"] = try r.getDeviceDetails()["serial_number"]
        } catch {
          readerDetails["serialNumber"] = ""
        }
        
        available.append(readerDetails)
      }
    }
    resolve(available)
  }

  @objc func loadDriver(
    _ vendor: String,
    model: String,
    modelType: String,
    inputType: String,
    resolve:RCTPromiseResolveBlock,
    reject:RCTPromiseRejectBlock
  ) {
    do {
      try reader.disconnect()
    } catch {
      // Could not disconnect because the device is not plugged/connected
    }
    let readerToLoad = SupportedReader(
      vendor: vendor,
      model: model,
      modelType: modelType,
      inputType: ReaderInputType(string: inputType)
    )
    
    if readerToLoad.inputType == nil {
      reject(
        "LoadDriverError",
        "LoadDriverError: Unsupported input type \(inputType) in call to loadDriver",
        NSError(domain: "", code: 400)
      )
    }

    reader = ReaderDriverFactory.create(
      reader: readerToLoad,
      onBarcodeScan: sendBarcode,
      onRfidScan: sendRfid
    )
    if !(reader is UnloadedDriver) {
      resolve("Loaded \(readerToLoad.model) driver")
    } else {
      reject(
        "LoadDriverError",
        "LoadDriverError: Unsupported device type \(modelType) in call to loadDriver",
        NSError(domain: "", code: 400)
      )
    }
  }

  @objc func getDriverName(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    resolve("\(type(of: reader))")
  }

  @objc func getDriverVersion(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      resolve(try reader.getDriverVersion())
    } catch let error {
      reject("GetDriverNameError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }

  @objc func getDeviceDetails(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      resolve(try reader.getDeviceDetails())
    } catch let error {
      reject("GetDeviceDetailsError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }

  @objc func connect(
    _ address:String,
    resolve:RCTPromiseResolveBlock,
    reject:RCTPromiseRejectBlock
  ) {
    do {
      try reader.connect(address)
      resolve("SUCCESS")
    } catch let error {
      reject("ConnectError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func disconnect(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.disconnect()
      resolve("SUCCESS")
    } catch let error {
      reject("DisconnectError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }

  @objc func isConnected(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    resolve(reader.isConnected())
  }
  
  @objc func getBatteryPercentage(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      do {
        resolve(try self.reader.getBatteryPercentage())
      } catch let error {
        reject("GetBatteryPercentageError", "\(error.localizedDescription) prior to call to \(#function)", error)
      }
    }
  }
  
  @objc func switchToScanRfidMode(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.switchToRfidMode()
      resolve("SUCCESS")
    } catch let error {
      reject("SwitchToScanRfidModeError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func startRfidScan(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.startRfidScan()
      resolve("SUCCESS")
    } catch let error {
      reject("StartRfidScanError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func stopRfidScan(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.stopRfidScan()
      resolve("SUCCESS")
    } catch let error {
      reject("StopRfidScanError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }

  @objc func activateSearchMode(
    _ tagToFind:String,
    resolve:RCTPromiseResolveBlock,
    reject:RCTPromiseRejectBlock
  ) {
    do {
      try reader.activateSearchMode(tagToFind)
      resolve("SUCCESS")
    } catch let error {
      reject("ActivateSearchModeError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func stopReading(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.stopReading()
      resolve("SUCCESS")
    } catch let error {
      reject("StopReadingError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func switchToScanBarcodeMode(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.switchToBarcodeMode()
      resolve("SUCCESS")
    } catch let error {
      reject("SwitchToScanBarcodeModeError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func getReaderPowerRange(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    do {
      let range = try reader.getReaderPowerRange()
      resolve(["minPower": range.0, "maxPower": range.1])
    } catch let error {
      reject("GetReaderPowerRange", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func getReaderPower(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    do {
      resolve(try reader.getReaderPower())
    } catch let error {
      reject("GetReaderPower", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
  
  @objc func configureReaderPower(
    _ powerPercentage: Double,
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) {
    do {
      try reader.configureReaderPower(Float(powerPercentage))
      resolve("SUCCESS")
    } catch let error {
      reject("ActivateSearchModeError", "\(error.localizedDescription) prior to call to \(#function)", error)
    }
  }
    
  func sendBarcode(barcode: String) {
    sendEvent(withName: "barcodeScan", body: [barcode])
  }
  
  func sendRfid(tag: Tag) {
//    TODO: add caching so that each tag is not sent individually, preventing lag if many tags are continuously read
    sendEvent(withName: "rfidRead", body: [[
      "epc": tag.epc,
      "rssi": tag.rssi,
      "scaledRssi": tag.scaledRssi,
      "tagCount": tag.tagCount,
      "tid": tag.tid
    ]])
  }
  
  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  override func supportedEvents() -> [String]! {
    return ["barcodeScan", "rfidRead"]
  }
}
