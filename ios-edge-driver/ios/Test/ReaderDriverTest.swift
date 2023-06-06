@testable import AsReaderDockSDK
@testable import RNEdgeDriverIOS

import XCTest

class ReaderDriverTest: XCTestCase {
  
  let simulatedDriver: ReaderDriver = SimulatedDriver(onBarcodeScan: emptyMockBarcode, onRfidScan: emptyMockRfid)
  let asReaderDockDriver: ReaderDriver = AsReaderDockDriver(
    device: DeviceMock(),
    onBarcodeScan: emptyMockBarcode,
    onRfidScan: emptyMockRfid
  )
  
  var barcodes: [String] = []
  var tags: [Tag] = []
  
  override func setUpWithError() throws {
    barcodes = []
    tags = []
  }
  
  func testIsAvailable() throws {
    XCTAssertTrue(simulatedDriver.isAvailable(), "Simulated driver should always be available")
    XCTAssertTrue(asReaderDockDriver.isAvailable(), "Mocked AsReader driver should always be available")
  }

  func testIsConnected() throws {
    try simulatedDriver.connect("")
    XCTAssertTrue(simulatedDriver.isConnected(), "isConnected should return true after a call to connect")

    try simulatedDriver.disconnect()
    XCTAssertFalse(simulatedDriver.isConnected(), "isConnected should return false after a call to disconnect")

    print("Running testIsConnected for AsReaderDock")
    try asReaderDockDriver.connect("")
    XCTAssertTrue(asReaderDockDriver.isConnected(), "isConnected should return true after a call to connect")

    try asReaderDockDriver.disconnect()
    XCTAssertFalse(asReaderDockDriver.isConnected(), "isConnected should return false after a call to disconnect")
  }

  func testBarcodeScanSimulate() throws {
    let simul: SimulatedDriver = SimulatedDriver(onBarcodeScan: mockBarcode, onRfidScan: mockRfid)
    try testBarcodeScanSimulateHelper(driver: simul)
  }

  func testBarcodeScanSimulateHelper(driver: SimulatedDriver) throws {
    let barcodesToSim: [String] = ["100000", "100001", "100002"]

    XCTAssertThrowsError(try driver.simulateBarcodeScan(barcodesToSim),
                         "Should throw an error for simulating a barcode before connecting")

    try driver.connect("")
    try driver.switchToBarcodeMode()
    try driver.simulateBarcodeScan(barcodesToSim)
    try driver.disconnect()

    _ = XCTWaiter.wait(for: [expectation(description: "Wait for events to be sent")], timeout: 1.0)

    XCTAssertEqual(barcodesToSim.count, barcodes.count, "Simulated \(barcodesToSim.count) barcodes but only received \(barcodes.count) barcode events")

    if (barcodesToSim.count == barcodes.count) {
      for i in 0..<barcodesToSim.count {
        XCTAssertEqual(barcodesToSim[i], barcodes[i])
      }
    }
  }

  func testRfidReadSimulate() throws {
    let simul: SimulatedDriver = SimulatedDriver(onBarcodeScan: mockBarcode, onRfidScan: mockRfid)
    try testRfidReadSimulateHelper(driver: simul)
  }

  func testRfidReadSimulateHelper(driver: SimulatedDriver) throws {
    let tagsToSim: [Tag] = [
      Tag(epc: "10000", rssi: -50, tagCount: 1, tid: "900"),
      Tag(epc: "10001", rssi: -51, tagCount: 2, tid: "901"),
      Tag(epc: "10003", rssi: -52, tagCount: 3, tid: "902")
    ]

    XCTAssertThrowsError(
      try driver.simulateTagRead(tagsToSim),
      "Should throw an error for simulating a tag before connecting"
    )

    try driver.connect("")
    try driver.switchToRfidMode()
    try driver.startRfidScan()
    try driver.simulateTagRead(tagsToSim)
    try driver.disconnect()

    XCTAssertEqual(tagsToSim.count, tags.count, "Simulated \(tagsToSim.count) tags but only received \(tags.count) tag events")

    if (tagsToSim.count == tags.count) {
      for i in 0..<tagsToSim.count {
        XCTAssertEqual(tagsToSim[i], tags[i])
      }
    }
  }

  func testSearchMode() throws {
    let simul: SimulatedDriver = SimulatedDriver(onBarcodeScan: mockBarcode, onRfidScan: mockRfid)
    try testSearchModeHelper(driver: simul)
  }

  func testSearchModeHelper(driver: SimulatedDriver) throws {
    let tagsToSim: [Tag] = [
      Tag(epc: "10000", rssi: -50, tagCount: 1, tid: "900"),
      Tag(epc: "10001", rssi: -51, tagCount: 2, tid: "901"),
      Tag(epc: "10003", rssi: -52, tagCount: 3, tid: "902")
    ]
    var tagToFind = tagsToSim[0]

    try driver.connect("")
    try driver.switchToRfidMode()
    try driver.activateSearchMode(tagToFind.epc)
    try driver.startRfidScan()
    try driver.simulateTagRead(tagsToSim)

    XCTAssertEqual(tags.count, 1, "Only one tag, the tag being searched for, should be recieved")
    if (tags.count == 1) {
      XCTAssertEqual(tagsToSim[0], tagToFind, "Found tag not equal to the tag being searched for")
      XCTAssertNotEqual(tagsToSim[1], tagToFind, "Found tag equal to different tag than the one being searched for")
    }

    tags = []
    tagToFind = Tag(epc: "000000", rssi: -50, tagCount: 1, tid: "901")
    try driver.activateSearchMode(tagToFind.epc)
    try driver.simulateTagRead(tagsToSim)

    XCTAssertEqual(tags.count, 0, "No tags should be found")

    try driver.disconnect()
  }

  func testUnloadedDriver() throws {
    let unloaded: ReaderDriver = UnloadedDriver()

    XCTAssertThrowsError(try unloaded.connect("")) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.NoDriverLoadedError)
    }

    XCTAssertNoThrow(try unloaded.disconnect())

    XCTAssertThrowsError(try unloaded.switchToRfidMode()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.NoDriverLoadedError)
    }
  }
  
  func testPowerRange() throws {
    let simulPowerRange = try simulatedDriver.getReaderPowerRange()
    let expectedSimulPowerRange = (0, 30)
    XCTAssertEqual(simulPowerRange.0, expectedSimulPowerRange.0, accuracy: 0)
    XCTAssertEqual(simulPowerRange.1, expectedSimulPowerRange.1, accuracy: 0)
    
    let asrDockPowerRange = try simulatedDriver.getReaderPowerRange()
    XCTAssertGreaterThan(asrDockPowerRange.1, asrDockPowerRange.0, "Range upper bound should be greater than lower")
  }
  
  func testSetAndGetPower() throws {
    let expectedPower: Float = 50
    try simulatedDriver.connect("")
    try simulatedDriver.configureReaderPower(expectedPower)
    XCTAssertEqual(try simulatedDriver.getReaderPower(), expectedPower, accuracy: 0)
  }

  func testConnectionError() throws {
    try testThrowsReaderConnectionError(simulatedDriver)
    print("Running testConnectionError for AsReaderDock")
    try testThrowsReaderConnectionError(asReaderDockDriver)
  }

  func testThrowsReaderConnectionError(_ driver: ReaderDriver) throws {
    try driver.disconnect()

    XCTAssertFalse(driver.isConnected(), "Driver reports being connected after call to disconnect method")

    let errorMessage: String = "Driver is disconnected so call should throw a ReaderConnectionError"

    XCTAssertThrowsError(try driver.switchToRfidMode()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }

    XCTAssertThrowsError(try driver.startRfidScan()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }

    XCTAssertThrowsError(try driver.stopRfidScan()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }

    XCTAssertThrowsError(try driver.activateSearchMode("")) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }

    XCTAssertThrowsError(try driver.stopReading()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }

    XCTAssertThrowsError(try driver.switchToBarcodeMode()) {
      error in XCTAssertEqual(error as! ReaderDriverError, ReaderDriverError.ReaderConnectionError, errorMessage)
    }
  }

  func testTag() throws {
    // given
    let epc = "10000"
    let rssi = -50
    let tagCount = 3
    let tid = "01"

    // when
    let testTag: Tag = Tag(epc: epc, rssi: rssi, tagCount: tagCount, tid: tid)

    // then
    XCTAssertEqual(testTag.epc, epc, "Tag object's EPC is incorrect")
    XCTAssertEqual(testTag.rssi, rssi, "Tag object's RSSI is incorrect")
    XCTAssertEqual(testTag.tagCount, tagCount, "Tag object's tag count is incorrect")
    XCTAssertEqual(testTag.tid, tid, "Tag object's TID is incorrect")
    
    XCTAssertEqual(testTag, Tag(epc: epc, rssi: rssi, tagCount: tagCount, tid: tid), "Tags with same values should be equal")
  }
  
  func mockBarcode(barcode: String) {
    self.barcodes.append(barcode)
  }

  func mockRfid(tag: Tag) {
    self.tags.append(tag)
  }
  
}

func emptyMockBarcode(barcode: String) {}

func emptyMockRfid(tag: Tag) {}
