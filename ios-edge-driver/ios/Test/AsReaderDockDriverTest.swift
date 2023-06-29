@testable import RNEdgeDriverIOS

import XCTest

class AsReaderDockDriverTest: XCTestCase {
  var barcodes: [String] = []
  var tags: [Tag] = []
  
  override func setUpWithError() throws {
    barcodes = []
    tags = []
    continueAfterFailure = false
  }
  
  func testBarcodeDataReceived() throws {
    let asReaderDockDriver = AsReaderDockDriver(
      device: DeviceMock(),
      onBarcodeScan: mockBarcode,
      onRfidScan: mockRfid
    )
    
    asReaderDockDriver.barcodeDataReceived(Data([]))
    XCTAssertTrue(barcodes.isEmpty, "If barcodeDataReceived recieves 0 bytes, should not send a barcode scan event")
    
    barcodes = []
    var barcode = "a"
    asReaderDockDriver.barcodeDataReceived(Data(barcode.utf8))
    XCTAssertEqual(barcode, barcodes[0], "Incorrect barcode decoding received")
    
    barcodes = []
    barcode = "1020"
    asReaderDockDriver.barcodeDataReceived(Data(barcode.utf8))
    XCTAssertEqual(barcode, barcodes[0], "Incorrect barcode decoding received")
    
    barcodes = []
    barcode = "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM`-=[];',./~!@#$%^&*()_+{}|:<>?"
    asReaderDockDriver.barcodeDataReceived(Data(barcode.utf8))
    XCTAssertEqual(barcode, barcodes[0], "Incorrect barcode decoding received")
  }
  
  func testRfidTagProcessing() throws {
    let asReaderDockDriver = AsReaderDockDriver(
      device: DeviceMock(),
      onBarcodeScan: mockBarcode,
      onRfidScan: mockRfid
    )
    
    let rssi: Int32 = -50
    
    asReaderDockDriver.pcEpcRssiReceived(Data([]), rssi: rssi)
    
    XCTAssertTrue(tags.isEmpty, "If pcEpcRssiReceived receives 0 bytes, should not send a RFID read event")
    
    tags = []
    var pcEpc = "a1"
    var tid = ""
    asReaderDockDriver.pcEpcRssiReceived(Data([0x18, 0x00, 0xa1]), rssi: rssi)

    XCTAssertTrue(tags.count == 1, "1 tag should be sent")
    XCTAssertEqual(Tag(epc: pcEpc, rssi: Int(rssi), tagCount: 1, tid: tid), tags[0], "Incorrect tag received")
    
    tags = []
    pcEpc = "0099aaff"
    tid = ""
    let pcEpcAsData = Data([0x18, 0x00, 0x00, 0x99, 0xaa, 0xff])

    asReaderDockDriver.pcEpcRssiReceived(pcEpcAsData, rssi: rssi)
    
    XCTAssertTrue(tags.count == 1, "1 tag should be sent")
    XCTAssertEqual(Tag(epc: pcEpc, rssi: Int(rssi), tagCount: 1, tid: tid), tags[0], "Incorrect tag received")
  }
  
  func testSearchMode() throws {
    let asReaderDockDriver = AsReaderDockDriver(
      device: DeviceMock(),
      onBarcodeScan: mockBarcode,
      onRfidScan: mockRfid
    )
    try testSearchModeHelper(driver: asReaderDockDriver)
  }

  func testSearchModeHelper(driver: AsReaderDockDriver) throws {
    let tagsToSim: [Tag] = [
      Tag(epc: "102000", rssi: -50, tagCount: 1, tid: ""),
      Tag(epc: "103001", rssi: -51, tagCount: 1, tid: ""),
      Tag(epc: "104003", rssi: -52, tagCount: 1, tid: ""),
      Tag(epc: "102000", rssi: -53, tagCount: 1, tid: ""),
    ]
    let hexEncodedTags = [
      Data([0x18, 0x00, 0x10, 0x20, 0x00]),
      Data([0x18, 0x00, 0x10, 0x30, 0x00]),
      Data([0x18, 0x00, 0x10, 0x40, 0x03]),
      Data([0x18, 0x00, 0x10, 0x20, 0x00]),
    ]
    var tagToFind = tagsToSim[0]

    try driver.connect("")
    try driver.switchToRfidMode()
    try driver.activateSearchMode(tagToFind.epc)
    
    XCTAssertEqual(
      tagsToSim.count,
      hexEncodedTags.count,
      "tagsToSim and hexEncodedTags should have same number of elements"
    )
    
    for i in 0..<tagsToSim.count {
      driver.pcEpcRssiReceived(hexEncodedTags[i], rssi: Int32(tagsToSim[i].rssi))
    }
    XCTAssertEqual(tags.count, 2, "Two tags with EPC '102000', should be recieved")
    XCTAssertEqual(tags[0], tagToFind, "Found tag not equal to the tag being searched for")

    tags = []
    tagToFind = Tag(epc: "000000", rssi: -50, tagCount: 1, tid: "901")
    try driver.activateSearchMode(tagToFind.epc)
    
    for i in 0..<tagsToSim.count {
      driver.pcEpcRssiReceived(hexEncodedTags[i], rssi: Int32(tagsToSim[i].rssi))
    }
    XCTAssertEqual(tags.count, 0, "No tags should be found")

    try driver.disconnect()
  }
  
  func mockBarcode(barcode: String) {
    self.barcodes.append(barcode)
  }

  func mockRfid(tag: Tag) {
    self.tags.append(tag)
  }
}
