/**
 A set that has a well defined representation for empty, continuous and
 disjoint ranges.

 Use this data structure if you need to do set algebra with ranges (e.g.
 compute a union or intersection of multiple ranges). Is uses an array of
 `Range<Bound>` for internal representation.

 If you only need to iterate over a continuous range, use `Range<Bound>`
 instead.
 */
public struct RangeSet<Bound: Comparable> {
    /**
     The disjoint ranges that compose the range set.

     These ranges are guaranteed to be
     - not empty
     - ordered by lower bound, ascending
     - disjoint

     Where the number of ranges in the array has a defined meaning:

     - `range.count == 0`: empty range set
     - `range.count == 1`: set with one continuous range
     - `range.count > 1`: set with multiple disjoint, continuous ranges
     */
    public var ranges: [Range<Bound>]

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
        - range: A range to convert to a set of ranges.
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
        var sorted = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })

        RangeSet.normalize(sorted: &sorted)

        self.ranges = sorted
    }

    /**
     Removes empty ranges and merges overlapping ranges from a given sorted
     array of ranges.

     After this operation the array is guaranteed to only contain ranges that
     are
     - ordered by lower bound, ascending (precondition)
     - not empty
     - disjoint

     # Example
     ```
     [
         1..<2,
         2..<3,
         4..<4
         5..<6,
         5..<6,
     ]
     ```

     will be normalized to

     ```
     [
         1..<3,
         5..<6
     ]
     ```

     - Parameters:
        - ranges: An array of ranges, sorted ascending by lower bound, to
          normalize.
     */
    static func normalize(sorted ranges: inout [Range<Bound>]) {
        guard ranges.count > 0 else {
            return
        }

        _debugPrecondition((1..<ranges.count).first(where: {
            ranges[$0].lowerBound < ranges[$0 - 1].lowerBound
        }) == nil, "Ranges must be sorted ascending by lower bound")

        var disjointUntil = -1
        let firstNonEmpty = ranges.firstIndex(where: { !$0.isEmpty })

        if let firstNonEmpty = firstNonEmpty {
            disjointUntil = disjointUntil + 1

            var previous: Range<Bound> = ranges[firstNonEmpty]

            for i in (firstNonEmpty + 1)..<ranges.count {
                let next = ranges[i]

                guard !next.isEmpty else {
                    continue
                }

                guard next.lowerBound > previous.upperBound else {
                    let union = previous.lowerBound..<next.upperBound

                    ranges[disjointUntil] = union
                    previous = union

                    continue
                }

                disjointUntil = disjointUntil + 1
                previous = next
                ranges[disjointUntil] = next
            }
        }

        ranges.removeSubrange((disjointUntil + 1)..<ranges.count)
    }
}

extension RangeSet: SetAlgebra {
    public typealias Element = Bound
    public typealias ArrayLiteralElement = Bound

    public func contains(_ member: Bound) -> Bool {
        fatalError("not implemented")
    }

    public func union(_ other: RangeSet<Bound>) -> RangeSet<Bound> {
        return RangeSet(ranges + other.ranges)
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
        ranges.append(contentsOf: other.ranges)
        ranges.sort(by: { $0.lowerBound < $1.lowerBound })
        RangeSet.normalize(sorted: &ranges)
    }

    public mutating func formIntersection(_ other: RangeSet<Bound>) {
        fatalError("not implemented")
    }

    public mutating func formSymmetricDifference(_ other: RangeSet<Bound>) {
        fatalError("not implemented")
    }
}
