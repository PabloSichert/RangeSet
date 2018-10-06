import XCTest
import RangeSet

class RangeSetTests: XCTestCase {
    func testInit() {
        let range = RangeSet<Int>()

        XCTAssert(range.ranges.count == 0)
    }

    func testInitWithEmptyRange() {
        let range = RangeSet(0..<0)

        XCTAssert(range.ranges.count == 0)
    }

    func testInitWithDenseRange() {
        let range = RangeSet(0..<1)

        XCTAssert(range.ranges.count == 1)
        XCTAssert(range.ranges[0] == 0..<1)
    }

    func testEmptyEmptyRange() {
        let range = RangeSet<Int>()

        XCTAssert(range.isEmpty)
    }

    func testEmptyDenseRange() {
        let range = RangeSet(0..<1)

        XCTAssert(!range.isEmpty)
    }

    func testBoundsEmptyRange() {
        let range = RangeSet(0..<0)

        XCTAssert(range.lowerBound == nil)
        XCTAssert(range.upperBound == nil)
    }

    func testBoundsDenseRange() {
        let range = RangeSet(0..<1)

        XCTAssert(range.lowerBound == 0)
        XCTAssert(range.upperBound == 1)
    }
}
