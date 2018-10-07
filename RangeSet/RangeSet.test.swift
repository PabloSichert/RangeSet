import XCTest
@testable import RangeSet

class RangeSetTests: XCTestCase {
    func testInitWithoutRange() {
        let set = RangeSet<Int>()

        XCTAssert(set.ranges.count == 0)
    }

    func testInitWithRangeEmpty() {
        let set = RangeSet(0..<0)

        XCTAssert(set.ranges.count == 0)
    }

    func testInitWithRangeContinuous() {
        let set = RangeSet(0..<1)

        XCTAssert(set.ranges.count == 1)
        XCTAssert(set.ranges[0] == 0..<1)
    }

    func testInitWithRangeDisjoint() {
        let set = RangeSet([0..<1, 2..<3])

        XCTAssert(set.ranges.count == 2)
        XCTAssert(set.ranges == [0..<1, 2..<3])
    }

    func testInitWithRangesEmpty() {
        let set = RangeSet<Int>([])

        XCTAssert(set.ranges.count == 0)
    }

    func testEmptyRangeEmpty() {
        let set = RangeSet<Int>()

        XCTAssert(set.isEmpty)
    }

    func testEmptyRangeContinuous() {
        let set = RangeSet(0..<1)

        XCTAssert(!set.isEmpty)
    }

    func testEmptyRangeDisjoint() {
        let set = RangeSet([0..<1, 2..<3])

        XCTAssert(!set.isEmpty)
    }

    func testBoundsRangeEmpty() {
        let set = RangeSet(0..<0)

        XCTAssert(set.lowerBound == nil)
        XCTAssert(set.upperBound == nil)
    }

    func testBoundsRangeContinuous() {
        let set = RangeSet(0..<1)

        XCTAssert(set.lowerBound == 0)
        XCTAssert(set.upperBound == 1)
    }

    func testBoundsRangeDisjoint() {
        let set = RangeSet([0..<1, 2..<3])

        XCTAssert(set.lowerBound == 0)
        XCTAssert(set.upperBound == 3)
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
