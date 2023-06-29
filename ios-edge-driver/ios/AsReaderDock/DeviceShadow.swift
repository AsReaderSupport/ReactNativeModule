import Foundation

protocol DeviceShadow {
  
  func setDelegate(_ assignDelegateTo: AsReaderDockDriver)

  func isOpened() -> Bool
  
  func getCurrentBattery() -> Int32
  
  @discardableResult
  func setReaderPower(
    _ isOn: Bool,
    beep isBeep: Bool,
    vibration isVib: Bool,
    led isLed: Bool,
    illumination isIllu: Bool,
    mode nDeviceType: Int32
  ) -> Int32
  
  func getSDKVersion() -> String!
  
  func setTriggerModeDefault(_ isDefault: Bool)
  
  func activateBarcodeReader()
  
  func activateRfidReader()
  
  func turnOff()
  
  @discardableResult
  func startReadTagsAndRssi(withTagNum maxTags: Int32, maxTime: Int32, repeatCycle: Int32) -> Bool
  
  @discardableResult
  func startReadTagAndTid(withTagNum maxTags: Int32, maxTime: Int32, repeatCycle: Int32) -> Bool
  
  @discardableResult
  func getOutputPowerLevel() -> Bool
  
  @discardableResult
  func setOutputPowerLevel(_ powerLevel: Int32) -> Bool
  
  @discardableResult
  func stopScan() -> Bool

}
