/**
 A range that has a well defined representation for empty, conjunct and disjunct ranges.
 */
public struct RangeSet<Bound: Comparable> {
    /**
     The disjunct ranges that compose the range set.

     These ranges are guaranteed to be
     - disjunct
     - ordered by lower bound, ascending

     Where the number of ranges in the array has a defined meaning:

     - `range.count == 0`: empty range set
     - `range.count == 1`: set with one conjunct range
     - `range.count > 1`: set with multiple disjoint ranges
     */
    public let ranges: [Range<Bound>]

    /**
     The lowest lower bound in the range set.

     `nil` when the range is empty.
     */
    public var lowerBound: Bound? {
        return ranges.first?.lowerBound
    }

    /**
     The upmost upper bound in the range set

     `nil` when the range is empty.
     */
    public var upperBound: Bound? {
        return ranges.last?.upperBound
    }

    /**
     Returns `true` when the empty set is represented.
     */
    public var isEmpty: Bool {
        return ranges.isEmpty
    }

    /**
     Creates an empty range set.
     */
    public init() {
        ranges = []
    }

    /**
     Creates a range set from an existing range.
     */
    public init(_ range: Range<Bound>) {
        guard range.lowerBound < range.upperBound else {
            ranges = []

            return
        }

        ranges = [
            range
        ]
    }
}
