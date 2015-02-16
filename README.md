Allsorts
========

A Swift library implementing various algorithms for comparable types.

`Ordering`, and the 3-way comparison operator `<=>`
---------------------------------------------------

As of Swift 1.2, the [Swift standard library][] is defined in terms of [equality][Equatable] and [less-than inequality][Comparable]. Sometimes though, it's more efficient or just more convenient to write algorithms in terms of three-way comparisons, returning either *less-than* (`.LT`), *equal-to* (`.EQ`), or *greater-than* (`.GT`) in one function call.

For making comparisons fun and *pattern-matchy*, Allsorts defines the necessary `enum` type `Ordering` and the binary operator `<=>` (read: *three-way-compare*) which returns an `Ordering`:

```swift
enum Ordering : Int {
    case LT = -1
    case EQ = 0
    case GT = 1
}

infix operator <=> { associativity none precedence 131 } // one above ==, <, etc.

func <=> <T : Comparable>(left: T, right: T) -> Ordering
```

Allsorts defines `<=>` for any [`Comparable`][Comparable] type, and adds a number of convenience overloads for lexicographical comparisons of generic types (see below).

For using `<=>` in a generically typed function, the compared types need to implement the protocol `Orderable`:

```swift
public protocol Orderable : _Orderable, Comparable {}
public protocol _Orderable {
    func <=> (lhs: Self, rhs: Self) -> Ordering
}
```

In practice, it's enough to define either both `==` and `<`, or just `<=>`, and then declare conformance to `Orderable`. For any [`Comparable`][Comparable] type, it is enough to declare the conformance to `Orderable`, and the default behaviour kicks in defining `<=>` for you. Indeed, that's exactly what Allsorts does with the structs found in the standard library:

```swift
extension Double : Orderable {}
extension Int    : Orderable {}
extension UInt   : Orderable {}
// ...
extension String : Orderable {} // uses the case-sensitive, locale-insensitive `String.compare` method
public func <=> (lhs: String, rhs: String) -> Ordering
```

In addition, Allsorts overloads the `<=>` operator for:

- tuples of 2 to 5 `Orderable`s (sorry, no nested tuples; too much boilerplate involved),
- `Optional<T>` where `T` is an `Orderable`; by convention, `nil` sorts last (because… who cares seeing `(NULL)` sorted first?), and
- sequences of `Orderable`s, up to three nestings (think `[[[T]]]` where `T` conforms to `Orderable`).

Comparators
-----------

For composing comparators, you can use the following combinator functions:

```swift
public func || (left: Ordering, right: @autoclosure () -> Ordering) -> Ordering
```

The `||` operator can be used to simplify the definition of lexicographical comparisons. Similarly to `bool1 || bool2` or `expr1 ?? expr2`, it lazily evaluates the right-hand side comparison expression `right`, only returning its value if `left` is `.EQ`:

```swift
let names: [(first: String, last: String, year: Int)] =
    [("Thom",   "Yorke",     1968),
     ("Jonny",  "Greenwood", 1971),
     ("Colin",  "Greenwood", 1969),
     ("Ed",     "O'Brien",   1968),
     ("Philip", "Selway",    1967)]
sorted(names) {a, b in a.last <=> b.last || a.first <=> b.first}
```

```swift
extension Ordering {
    static func Ordering.to<T : Comparable>(right: T) -> T -> Ordering
    static func Ordering.to<T : Orderable> (right: T) -> T -> Ordering
}
```

```swift
extension Ordering {
    static func reverse<Args>(compare: Args -> Ordering) -> Args -> Ordering
}
```

Binary search
-------------

A binary search finds an index in a sorted random access container in `O(log N)` time. There is more than one kind of binary search. Allsorts implements the following:

```swift
// indices:          0,   1,  2,   3,  4,  5,   6,  7,  8,  9
let xs: [Double] = [10,  20, 20,  30, 30, 30,  40, 40, 40, 40]

// `binarySearch` returns an arbitrary sort-preserving insertion index
let i29: Int = binarySearch(xs, Ordering.to(29)) // returns 3
let i30: Int = binarySearch(xs, Ordering.to(30)) // returns 3, 4, or 5
let i31: Int = binarySearch(xs, Ordering.to(31)) // returns 6

// `binaryFind` returns an index of an equal element, or `nil` if none
let j29: Int? = binaryFind(xs, Ordering.to(29)) // returns nil
let j30: Int? = binaryFind(xs, Ordering.to(30)) // returns 3, 4, or 5 (as Int?)
let j31: Int? = binaryFind(xs, Ordering.to(31)) // returns nil

/// `lowerBound` returns the lowest sort-preserving insertion index
let l29: Int = lowerBound(xs, Ordering.to(29)) // returns 3
let l30: Int = lowerBound(xs, Ordering.to(30)) // returns 3
let l31: Int = lowerBound(xs, Ordering.to(31)) // returns 6

/// `upperBound` returns the lowest sort-preserving insertion index
let u29: Int = upperBound(xs, Ordering.to(29)) // returns 3
let u30: Int = upperBound(xs, Ordering.to(30)) // returns 6
let u31: Int = upperBound(xs, Ordering.to(31)) // returns 6

/// `equalRange` returns range of equal elements
let r29: Range<Int> = equalRange(xs, Ordering.to(29)) // returns 3 ..< 3
let r30: Range<Int> = equalRange(xs, Ordering.to(30)) // returns 3 ..< 6
let r31: Range<Int> = equalRange(xs, Ordering.to(31)) // returns 6 ..< 6
```

All of the above functions are actually convenience wrappers for the following four functions on `RandomAccessIndexType`s, which all find their result using a logarithmic number of `ord(i)` lookups in `range`:

```swift
func binarySearch<Ix : RandomAccessIndexType>(range: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   lowerBound<Ix : RandomAccessIndexType>(range: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   upperBound<Ix : RandomAccessIndexType>(range: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   equalRange<Ix : RandomAccessIndexType>(range: Range<Ix>, ord: Ix -> Ordering) -> Range<Ix>
```

____
[Swift standard library]: http://swiftdoc.org/
[Comparable]: http://swiftdoc.org/protocol/Comparable/
[Equatable]: http://swiftdoc.org/protocol/Equatable/