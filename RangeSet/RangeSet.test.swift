import XCTest
@testable import RangeSet

class RangeSetTests: XCTestCase {
    func testInitWithoutRange() {
        let range = RangeSet<Int>()

        XCTAssert(range.ranges.count == 0)
    }

    func testInitWithRangeEmpty() {
        let range = RangeSet(0..<0)

        XCTAssert(range.ranges.count == 0)
    }

    func testInitWithRangeContinuous() {
        let range = RangeSet(0..<1)

        XCTAssert(range.ranges.count == 1)
        XCTAssert(range.ranges[0] == 0..<1)
    }

    func testInitWithRangeDisjoint() {
        let range = RangeSet([0..<1, 2..<3])

        XCTAssert(range.ranges.count == 2)
        XCTAssert(range.ranges == [0..<1, 2..<3])
    }

    func testInitWithRangesEmpty() {
        let range = RangeSet<Int>([])

        XCTAssert(range.ranges.count == 0)
    }

    func testEmptyRangeEmpty() {
        let range = RangeSet<Int>()

        XCTAssert(range.isEmpty)
    }

    func testEmptyRangeContinuous() {
        let range = RangeSet(0..<1)

        XCTAssert(!range.isEmpty)
    }

    func testEmptyRangeDisjoint() {
        let range = RangeSet([0..<1, 2..<3])

        XCTAssert(!range.isEmpty)
    }

    func testBoundsRangeEmpty() {
        let range = RangeSet(0..<0)

        XCTAssert(range.lowerBound == nil)
        XCTAssert(range.upperBound == nil)
    }

    func testBoundsRangeContinuous() {
        let range = RangeSet(0..<1)

        XCTAssert(range.lowerBound == 0)
        XCTAssert(range.upperBound == 1)
    }

    func testBoundsRangeDisjoint() {
        let range = RangeSet([0..<1, 2..<3])

        XCTAssert(range.lowerBound == 0)
        XCTAssert(range.upperBound == 3)
    }

    func testNormalizeEmpty() {
        let ranges = [
            1..<1
        ]

        let normalized: [Range<Int>] = []

        XCTAssert(RangeSet.normalize(ranges) == normalized)
    }

    func testNormalizeUnordered() {
        let ranges = [
            3..<4,
            1..<2,
        ]

        let normalized = [
            1..<2,
            3..<4
        ]

        XCTAssert(RangeSet.normalize(ranges) == normalized)
    }

    func testNormalizeDuplicate() {
        let ranges = [
            1..<2,
            1..<2,
        ]

        let normalized = [
            1..<2
        ]

        XCTAssert(RangeSet.normalize(ranges) == normalized)
    }

    func testNormalizeOverlapping() {
        let ranges = [
            1..<2,
            2..<3,
        ]

        let normalized = [
            1..<3
        ]

        XCTAssert(RangeSet.normalize(ranges) == normalized)
    }

    func testNormalizeEmptyUnorderedDuplicateOverlapping() {
        let ranges = [
            5..<6,
            5..<6,
            2..<3,
            1..<2,
            4..<4
        ]

        let normalized = [
            1..<3,
            5..<6
        ]

        XCTAssert(RangeSet.normalize(ranges) == normalized)
    }
}
