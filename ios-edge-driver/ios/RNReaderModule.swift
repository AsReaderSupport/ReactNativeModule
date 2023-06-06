import Foundation
import React

@objc(RNReaderModule)
class RNReaderModule : RCTEventEmitter {
  private var reader: ReaderDriver = UnloadedDriver()
  
  @objc func getAvailable(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    var available: [String] = []
    let asReaderDockDriver: ReaderDriver = AsReaderDockDriver(device: DeviceAsReader(), onBarcodeScan: sendBarcode, onRfidScan: sendRfid)
    let simulatedDriver: ReaderDriver = SimulatedDriver(onBarcodeScan: sendBarcode, onRfidScan: sendRfid)

    simulatedDriver.isAvailable() ? available.append("simulated") : nil
    asReaderDockDriver.isAvailable() ? available.append("AsReaderDock") : nil

    resolve(available)
  }

  @objc func loadDriver(
    _ deviceName: String,
    resolve:RCTPromiseResolveBlock,
    reject:RCTPromiseRejectBlock
  ) {
    do {
      try reader.disconnect()
    } catch {
      // Could not disconnect because the device is not plugged/connected
    }
    reader = UnloadedDriver()
    
    switch deviceName {
    case "AsReaderDock":
      reader = AsReaderDockDriver(device: DeviceAsReader(), onBarcodeScan: sendBarcode, onRfidScan: sendRfid)
      resolve("Loaded AsReaderDock driver")
      
    case "simulated":
      reader = SimulatedDriver(onBarcodeScan: sendBarcode, onRfidScan: sendRfid)
      resolve("Loaded simulated driver")
      
    default:
      reject("LoadDriverError", "LoadDriverError: Unsupported device name in call to loadDriver", NSError(domain: "", code: 400))
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
  
  @objc func getBatteryPercentage(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.getBatteryPercentage()
      resolve("SUCCESS")
    } catch let error {
      reject("GetBatteryPercentageError", "\(error.localizedDescription) prior to call to \(#function)", error)
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
  
  @objc func stopSearchMode(_ resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    do {
      try reader.stopSearchMode()
      resolve("SUCCESS")
    } catch let error {
      reject("StopSearchModeError", "\(error.localizedDescription) prior to call to \(#function)", error)
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
  
  func sendBarcode(barcode: String) {
    sendEvent(withName: "barcodeScan", body: barcode)
  }
  
  func sendRfid(tag: Tag) {
    sendEvent(withName: "rfidRead", body: ["epc": tag.epc, "rssi": tag.rssi, "tagCount": tag.tagCount, "tid": tag.tid])
  }
  
  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
  
  override func supportedEvents() -> [String]! {
    return ["barcodeScan", "rfidRead"]
  }
}

