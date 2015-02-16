Allsorts
========

A Swift library implementing various algorithms for comparable types.

`Ordering` and the 3-way comparison `<=>`
-----------------------------------------

As of Swift 1.2, the [Swift standard library][] is defined in terms of [equality][Equatable] and [less-than inequality][Comparable]. Sometimes though, it's more efficient or just more convenient to write algorithms in terms of three-way comparisons, returning either *less-than* *equal-to*, or *greater-than*, in one function call.

For making comparisons fun and pattern-matchy, Allsorts defines the necessary `enum` type `Ordering` and the binary operator `<=>` (read: *three-way-compare*) which returns an `Ordering`:

```swift
enum Ordering : Int {
    case LT = -1
    case EQ = 0
    case GT = 1
}

infix operator <=> { associativity none precedence 131 }

func <=> <T : Comparable>(left: T, right: T) -> Ordering
```

Allsorts defines `<=>` for any [`Comparable`][Comparable] type, and adds a number of convenience overloads for lexicographical comparisons of generic types (see further below).

For using `<=>` in a generically typed function, the compared types need to implement the protocol `Orderable`:

```swift
public protocol Orderable : _Orderable, Comparable {}
public protocol _Orderable {
    func <=> (lhs: Self, rhs: Self) -> Ordering
}
```

In practice, it's enough to define either both `==` and `<`, or just `<=>`, and then declare conformance to `Orderable`.

For any [`Comparable`][Comparable] type, just declare conformance to `Orderable`, and the default behaviour kicks in defining `<=>` for you! That's exactly what Allsorts does to the types found in the standard library:

```swift
extension Double : Orderable {}
extension Int    : Orderable {}
extension UInt   : Orderable {} // ...

// Uses the case-sensitive, locale-insensitive `String.compare`:
public func <=> (lhs: String, rhs: String) -> Ordering
extension String : Orderable {}
```

In addition, Allsorts overloads the `<=>` operator for…

- **tuples** `(A, B)` to `(A, B, C, D, E)` of `Orderable`s.
    - Sorry, no nested tuples; too much boilerplate involved!
- **optionals** `T?` where `T` conforms to `Orderable`.
    - by convention, `nil` sorts last because… who cares seeing `"(NULL)"` on top of their `UITableView`?
- **sequences** of `Orderable`s, up to three nestings.
    - Huh, nestings? Think `[[[T]]]` where `T` conforms to `Orderable`.

Comparators
-----------

For composing comparators, you can use the following combinator functions:

### `Ordering.by(key)` — binary comparator

```swift
typealias Musician = (first: String, last: String, year: Int)
let byFirst = Ordering.by {(m: Musician) in m.first}
let byLast  = Ordering.by {(m: Musician) in m.last}
let byYear  = Ordering.by {(m: Musician) in m.year}
//=> (Musician, Musician) -> Ordering
```

### Comparator composition operator `<|>`

```swift
let musicians: [Musician] = [("Thom",   "Yorke",     1968),
                             ("Jonny",  "Greenwood", 1971),
                             ("Colin",  "Greenwood", 1969),
                             ("Ed",     "O'Brien",   1968),
                             ("Philip", "Selway",    1967)]

sorted(names, byLast <|> byFirst).map {$0.first}
//=> ["Colin", "Jonny", "Ed", "Philip", "Thom"]

sorted(names, Ordering.by {countElements($0.last)}
          <|> Ordering.reverse(byYear)
).map {$0.first}
//=> ["Thom", "Philip", "Ed", "Jonny", "Colin"]
```

### `Ordering.to(rightValue)` — unary comparator

```swift
let ord = Ordering.to(42)
ord(41) //=> Ordering.LT
ord(42) //=> Ordering.EQ
ord(43) //=> Ordering.GT
```

### `Ordering.within(interval)` — unary bounds comparator

```swift
let ord = Ordering.within(1987 ... 1994)
ord(1986) //=> Ordering.LT
ord(1987) //=> Ordering.EQ
ord(1991) //=> Ordering.EQ
ord(1994) //=> Ordering.EQ
ord(1995) //=> Ordering.GT
```

### `Ordering.reverse(comparator)` — reversed comparator

```swift
let byRevName = Ordering.reverse(byLast <|> byFirst)
byRevName(("ZZ",  "Top",      1969),
          ("Led", "Zeppelin", 1968)) //=> Ordering.GT

let rev = Ordering.reverse(Ordering.to(42))
ord(41) //=> Ordering.GT
ord(42) //=> Ordering.EQ
ord(43) //=> Ordering.LT
```

### Lexicographical "OR" operator `||`

The `||` operator can be used to simplify the definition of lexicographical comparisons. Similarly to `bool1 || bool2` or `expr1 ?? expr2`, it lazily evaluates the right-hand side comparison expression `right`, only returning its value if `left` is `.EQ`:

```swift
let ord = a.dateOfBirth <=> b.dateOfBirth
       || a.lastName    <=> b.lastName
       || a.firstName   <=> b.firstName
```

Sorting
-------

Allsorts doesn't currently add much to tasks involving sorting, but the following simple wrappers to `Swift.sorted` exist:

```swift
let musiciansByName = sorted(musicians, byLast <|> byFirst)
//=> Greenwood Colin, Greenwood Jonny, O'Brien Ed, Selway Philip, Yorke Thom

let musiciansByYear = stableSorted(musicians, byYear)
//=> Philip 1967, Thom 1968, Ed 1968, Colin 1969, Jonny 1971
```

Binary search
-------------

A binary search algorithm finds an index in a sorted random access container in `O(log N)` time. There is more than one kind of binary searches. Allsorts implements the following:

```swift
// indices:          0,   1,  2,   3,  4,  5,   6,  7,  8,  9
let xs: [Double] = [10,  20, 20,  30, 30, 30,  40, 40, 40, 40]

// Find an arbitrary sort-preserving insertion index
let i29: Int = binarySearch(xs, Ordering.to(29)) //=> 3
let i30: Int = binarySearch(xs, Ordering.to(30)) //=> 3, 4, or 5
let i31: Int = binarySearch(xs, Ordering.to(31)) //=> 6

// Find index of an equal element, or `nil` if not found
let j29: Int? = binaryFind(xs, Ordering.to(29)) //=> nil
let j30: Int? = binaryFind(xs, Ordering.to(30)) //=> 3, 4, or 5
let j31: Int? = binaryFind(xs, Ordering.to(31)) //=> nil

/// Find the lowest sort-preserving insertion index
let l29: Int = lowerBound(xs, Ordering.to(29)) //=> 3
let l30: Int = lowerBound(xs, Ordering.to(30)) //=> 3
let l31: Int = lowerBound(xs, Ordering.to(31)) //=> 6

/// Find the lowest sort-preserving insertion index
let u29: Int = upperBound(xs, Ordering.to(29)) //=> 3
let u30: Int = upperBound(xs, Ordering.to(30)) //=> 6
let u31: Int = upperBound(xs, Ordering.to(31)) //=> 6

/// Find the range of equal elements
let r29: Range<Int> = equalRange(xs, Ordering.to(29)) //=> 3 ..< 3
let r30: Range<Int> = equalRange(xs, Ordering.to(30)) //=> 3 ..< 6
let r31: Range<Int> = equalRange(xs, Ordering.to(31)) //=> 6 ..< 6

let r20 = equalRange(xs, Ordering.between(20 ... 30)) //=> 1 ..< 6
```

All of the above functions are actually convenience wrappers for the following four functions on `RandomAccessIndexType`s, which all find their result using a logarithmic number of `ord(i)` lookups in `range`:

```swift
typealias RA = RandomAccessIndexType
func binarySearch<Ix : RA>(r: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   lowerBound<Ix : RA>(r: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   upperBound<Ix : RA>(r: Range<Ix>, ord: Ix -> Ordering) -> Ix
func   equalRange<Ix : RA>(r: Range<Ix>, ord: Ix -> Ordering) -> Range<Ix>
```

Other
-----

Ported to Swift from [libc++][] Allsorts implements the push and pop operations for array-backed binary trees. This feature isn't very performant, and should be considered experimental. (For the time being, you're probably better off just sorting an array instead.)

```swift
func pushHeap<T: Comparable>(inout heap: [T], value: T)
func pushHeap<T>(inout heap: [T], value: T, isOrderedBefore: (T, T) -> Bool)
func pushHeap<T: Comparable>(inout heap: [T], value: T)

func popHeap<T: Comparable>(inout heap: [T]) -> T
func popHeap<T>(inout heap: [T], isOrderedBefore: (T, T) -> Bool) -> T
func popHeap<T>(inout heap: [T], compare: (T, T) -> Ordering) -> T
```


____
[Swift standard library]: http://swiftdoc.org/
[Comparable]: http://swiftdoc.org/protocol/Comparable/
[Equatable]: http://swiftdoc.org/protocol/Equatable/
[libc++]: http://libcxx.llvm.org/
