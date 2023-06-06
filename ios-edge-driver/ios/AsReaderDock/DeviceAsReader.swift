import Foundation
import AsReaderDockSDK

class DeviceAsReader: AsReaderRFIDDevice, DeviceShadow  {
  var BARCODE_MODE: Int32 = 0
  let RFID_MODE: Int32 = 1
  
  func setDelegate(_ assignDelegateTo: AsReaderDockDriver) {
    let barcodeDeviceShared = AsReaderBarcodeDevice.sharedInstance()
    let RfidDeviceShared = AsReaderRFIDDevice.sharedInstance()
    barcodeDeviceShared?.delegateDevice = assignDelegateTo
    barcodeDeviceShared?.delegateBarcode = assignDelegateTo
    RfidDeviceShared?.delegateDevice = assignDelegateTo
    RfidDeviceShared?.delegateRFID = assignDelegateTo
  }
  
  func getSDKVersion() -> String! {
    return AsReaderDevice.getSDKVersion()
  }
  
  func setTriggerModeDefault(_ isDefault: Bool) {
    AsReaderDevice.setTriggerModeDefault(isDefault)
  }
  
  func activateBarcodeReader() {
    self.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: RFID_MODE)
    self.setReaderPower(true, beep: true, vibration: true, led: true, illumination: true, mode: BARCODE_MODE)
  }
  
  func activateRfidReader() {
    self.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: BARCODE_MODE)
    self.setReaderPower(true, beep: true, vibration: true, led: true, illumination: true, mode: RFID_MODE)
  }
  
  func turnOff() {
    self.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: BARCODE_MODE)
    self.setReaderPower(false, beep: true, vibration: true, led: true, illumination: true, mode: RFID_MODE  )
  }
}
