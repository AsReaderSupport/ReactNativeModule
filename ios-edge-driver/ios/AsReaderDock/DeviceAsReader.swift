import Foundation
import AsReaderDockSDK

class DeviceAsReader: AsReaderRFIDDevice, DeviceShadow  {
  
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
}
