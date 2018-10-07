/**
 A range that has a well defined representation for empty, conjunct and disjunct ranges.
 */
public struct RangeSet<Bound: Comparable> {
    /**
     The disjunct ranges that compose the range set.

     These ranges are guaranteed to be
     - not empty
     - ordered by lower bound, ascending
     - disjunct

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

     - Parameters:
        - range: A range to be converted to a set of ranges.
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

    /**
     Creates a range set from an existing array of ranges.

     - Parameters:
        - ranges: An array of ranges to convert to a set of ranges.
     */
    public init(_ ranges: [Range<Bound>]) {
        self.ranges = RangeSet.normalize(ranges)
    }

    /**
     Returns a canonic representation for an array of ranges.

     The ranges in the resulting array are guaranteed to be
     - not empty
     - ordered by lower bound, ascending
     - disjunct

     # Example
     ```
     [
         5..<6,
         5..<6,
         2..<3,
         1..<2,
         4..<4
     ]
     ```

     will be normalized to

     ```
     [
        1..<3,
        5..<6
     ]
     ```
     */
    static func normalize(_ ranges: [Range<Bound>]) -> [Range<Bound>] {
        let notEmpty = ranges.filter { $0.lowerBound < $0.upperBound }
        let sorted = notEmpty.sorted(by: { $0.lowerBound < $1.lowerBound })

        guard sorted.count > 0 else {
            return []
        }

        var previous: Range<Bound> = sorted[0]
        var disjunct: [Range<Bound>] = [previous]
        disjunct.reserveCapacity(sorted.count)

        for i in 1..<sorted.count {
            let next = sorted[i]

            guard next.lowerBound > previous.upperBound else {
                let union = previous.lowerBound..<next.upperBound

                disjunct[disjunct.count - 1] = union
                previous = union

                continue
            }

            disjunct.append(next)

            previous = next
        }

        return disjunct
    }
}

extension RangeSet: SetAlgebra {
    public typealias Element = Bound
    public typealias ArrayLiteralElement = Bound

    public func contains(_ member: Bound) -> Bool {
        fatalError("not implemented")
    }

    public func union(_ other: RangeSet<Bound>) -> RangeSet<Bound> {
        fatalError("not implemented")
    }

    public func intersection(_ other: RangeSet<Bound>) -> RangeSet<Bound> {
        fatalError("not implemented")
    }

    public func symmetricDifference(_ other: RangeSet<Bound>) -> RangeSet<Bound> {
        fatalError("not implemented")
    }

    public mutating func insert(_ newMember: Bound) -> (inserted: Bool, memberAfterInsert: Bound) {
        fatalError("not implemented")
    }

    public mutating func remove(_ member: Bound) -> Bound? {
        fatalError("not implemented")
    }

    public mutating func update(with newMember: Bound) -> Bound? {
        fatalError("not implemented")
    }

    public mutating func formUnion(_ other: RangeSet<Bound>) {
        fatalError("not implemented")
    }

    public mutating func formIntersection(_ other: RangeSet<Bound>) {
        fatalError("not implemented")
    }

    public mutating func formSymmetricDifference(_ other: RangeSet<Bound>) {
        fatalError("not implemented")
    }
}
