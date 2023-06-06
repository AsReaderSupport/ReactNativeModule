import Foundation

protocol DeviceShadow {
  
  func setDelegate(_ assignDelegateTo: AsReaderDockDriver)

  func isOpened() -> Bool
  
  func getCurrentBattery() -> Int32
  
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
  
  func startReadTagsAndRssi(withTagNum maxTags: Int32, maxTime: Int32, repeatCycle: Int32) -> Bool
  
  func stopScan() -> Bool

}
