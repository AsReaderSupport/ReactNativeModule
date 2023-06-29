import XCTest

class UtilsTest: XCTestCase {
  func test_valueToPercentage() throws {
    XCTAssertEqual(valueToPercentage(0, min: 0, max: 0), 0)
    XCTAssertEqual(valueToPercentage(5, min: 0, max: 1), 100)
    XCTAssertEqual(valueToPercentage(-1, min: 0, max: 10), 0)
    XCTAssertEqual(valueToPercentage(11, min: 11, max: 111), 0)
    XCTAssertEqual(valueToPercentage(111, min: 11, max: 111), 100)
    XCTAssertEqual(valueToPercentage(5, min: 0, max: 10), 50)
    XCTAssertEqual(valueToPercentage(-35, min: -100, max: -20), 81.25)
  }
  
  func test_percentageToValue() throws {
    XCTAssertEqual(percentageToValue(0, min: 0, max: 0), 0)
    XCTAssertEqual(percentageToValue(-10, min: 1, max: 3), 1)
    XCTAssertEqual(percentageToValue(110, min: 1, max: 3), 3)
    XCTAssertEqual(percentageToValue(75, min: 1, max: 1), 1)
    XCTAssertEqual(percentageToValue(100, min: 1, max: 30), 30)
    XCTAssertEqual(percentageToValue(0, min: 1, max: 30), 1)
    XCTAssertEqual(percentageToValue(10, min: 1, max: 3), 1.2)
    XCTAssertEqual(percentageToValue(50, min: 0, max: 17), 8.5)
    XCTAssertEqual(percentageToValue(81.25, min: -100, max: -20), -35)
  }
}
