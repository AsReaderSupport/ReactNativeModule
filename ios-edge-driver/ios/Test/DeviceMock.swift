import Foundation

class DeviceMock: DeviceShadow {
  func setDelegate(_ assignDelegateTo: AsReaderDockDriver) {}
  
  func isOpened() -> Bool {
    return true
  }
  
  func getCurrentBattery() -> Int32 {
    return -1
  }
  
  func setReaderPower(
    _ isOn: Bool,
    beep isBeep: Bool,
    vibration isVib: Bool,
    led isLed: Bool,
    illumination isIllu:
    Bool,
    mode nDeviceType: Int32
  ) -> Int32 {
    return 1
  }
  
  func getSDKVersion() -> String! {
    return "1.0"
  }
  
  func setTriggerModeDefault(_ isDefault: Bool) {}
  
  func activateBarcodeReader() {}
  
  func activateRfidReader() {}
  
  func turnOff() {}
  
  func startReadTagsAndRssi(withTagNum maxTags: Int32, maxTime: Int32, repeatCycle: Int32) -> Bool {
    return true
  }
    
  func startReadTagAndTid(withTagNum maxTags: Int32, maxTime: Int32, repeatCycle: Int32) -> Bool {
    return true
  }
  
  func stopScan() -> Bool {
    return true
  }
  
  func setOutputPowerLevel(_ poweLevel: Int32) -> Bool {
    return true
  }
  
  func getOutputPowerLevel() -> Bool {
    return true
  }
}
