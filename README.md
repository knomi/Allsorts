Allsorts
========

Algorithms on sorted collections and comparable types in Swift.

Quick demo
----------

Sort people by surname (primarily), then given name, then ascending age (i.e. descending date of birth):

```swift
let phoneBook = people.sorted(ordering: Ordering.by {$0.surname}
                                    <|> Ordering.by {$0.givenName}
                                    <|> Ordering.reverse(Ordering.by {$0.dob}))
```

Find all J. Smiths in logarithmic time:

```swift
let jSmithRange = phoneBook.equalRange {p in
    p.surname <=> "Smith" || p.givenName <=> "J" ..< "K"
}
```

Ordering
--------

As of Swift 1.2, the [Swift standard library][] is defined in terms of [equality][Equatable] and [less-than inequality][Comparable]. Sometimes though, it's more efficient or just more convenient to write algorithms in terms of three-way comparisons, returning either *less-than* *equal-to*, or *greater-than*, in one function call.

For making comparisons fun and pattern-matchy, Allsorts defines comparison results in terms of the `enum` type `Ordering`:

```swift
enum Ordering : Int {
    case less = -1
    case equal = 0
    case greater = 1
}
```

Three-way comparisons
---------------------

The binary operator `<=>` (read: *three-way-compare*) always returns an `Ordering`:

```swift
infix operator <=> : ComparisonPrecedence

func <=> <T : Comparable>(left: T, right: T) -> Ordering
```

Allsorts defines `<=>` for any [`Comparable`][Comparable] type, and adds a number of convenience overloads for lexicographical comparisons of generic types (see further below).

For using `<=>` in a generically typed function, the compared types need to implement the protocol `Orderable`:

```swift
protocol Orderable {
    func <=> (left: Self, right: Self) -> Ordering
}
```

In practice, it's enough to define either `==` and `<` or just `<=>`, and then declare conformance to `Orderable` and `Comparable`.

For any already [`Comparable`][Comparable] type, just declare conformance to `Orderable`, and the default behaviour kicks in defining `<=>` for you! That's exactly what Allsorts does to the types found in the standard library:

```swift
extension Double : Orderable {}
extension Int    : Orderable {}
extension UInt   : Orderable {} // ...

// Uses the case-sensitive, locale-insensitive `String.compare`:
public func <=> (left: String, right: String) -> Ordering
extension String : Orderable {}
```

Sometimes, it's useful to compare a value to an interval. The expression `x <=> a ... b` simply tells, whether `x` falls within the interval, or which side of it if not:

```swift
func <=> <T>(left: T, rightInterval: Range<T>) -> Ordering
func <=> <T>(left: T, rightInterval: ClosedRange<T>) -> Ordering
```

In addition to the above, Allsorts overloads the `<=>` operator for…

- **tuples** `(A, B)`, `(A, B, C)`, `(A, B, C, D)` and `(A, B, C, D, E)` of `Orderable`s.
    - Sorry, no nested tuples; too much boilerplate involved!
- **optionals** `T?` where `T` conforms to `Orderable`.
    - by convention, `nil` sorts last because… who cares seeing `"(NULL)"` on top of their `UITableView`?
- **sequences** of `Orderable`s, for up to three nestings (read: `[T]`, `[[T]]`, and `[[[T]]]`).

Comparators
-----------

For composing comparators, you can use the following combinator functions:

### `Ordering.by(key)` — binary by-key comparator

Create a binary comparator on a mapping on both comparison operands. Shorthand for `{key($0) <=> key($1)}`.

```swift
typealias Musician = (first: String, last: String, year: Int)
let byFirst = Ordering.by {(m: Musician) in m.first}
let byLast  = Ordering.by {(m: Musician) in m.last}
let byYear  = Ordering.by {(m: Musician) in m.year}
//=> (Musician, Musician) -> Ordering
```

### Comparator composition operator `<|>`

Compose comparators lexicographically (inequality on the left-hand side wins).

```swift
let musicians: [Musician] = [("Thom",   "Yorke",     1968),
                             ("Jonny",  "Greenwood", 1971),
                             ("Colin",  "Greenwood", 1969),
                             ("Ed",     "O'Brien",   1968),
                             ("Philip", "Selway",    1967)]

sorted(names, byLast <|> byFirst).map {$0.first}
//=> ["Colin", "Jonny", "Ed", "Philip", "Thom"]

sorted(names, Ordering.by {$0.last.characters.count}
          <|> Ordering.reverse(byYear)
).map {$0.first}
//=> ["Thom", "Philip", "Ed", "Jonny", "Colin"]
```

### `Ordering.to(rightValue)` — unary comparator

Named version of `{$0 <=> rightValue}`.

```swift
let ord = Ordering.to(1999)
ord(1998) //=> Ordering.less
ord(1999) //=> Ordering.equal
ord(2000) //=> Ordering.greater
```

### `Ordering.within(interval)` — unary bounds comparator

Named version of `{$0 <=> inverval}`.

```swift
let ord = Ordering.within(1987 ... 1994)
ord(1986) //=> Ordering.less
ord(1987) //=> Ordering.equal
ord(1991) //=> Ordering.equal
ord(1994) //=> Ordering.equal
ord(1995) //=> Ordering.greater
```

### `Ordering.reverse(comparator)` — reversed comparator

```swift
let byRevName = Ordering.reverse(byLast <|> byFirst)
byRevName(("ZZ",  "Top",      1969) as Musician,
          ("Led", "Zeppelin", 1968) as Musician) //=> Ordering.greater

let rev = Ordering.reverse(Ordering.to(1999))
ord(1998) //=> Ordering.greater
ord(1999) //=> Ordering.equal
ord(2000) //=> Ordering.less
```

### Lexicographical "OR" operator `||`

The `||` operator can be used to simplify the definition of lexicographical comparisons. Similarly to `bool1 || bool2` or `expr1 ?? expr2`, it lazily evaluates the right-hand side comparison expression `right`, only returning its value if `left` is `.equal`:

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

let musiciansByYear = musicians.sort(ordering: byYear)
//=> Philip 1967, Thom 1968, Ed 1968, Colin 1969, Jonny 1971
```

Binary search
-------------

A binary search algorithm finds an index in a sorted random access collection in `O(log N)` time, and in principle also works for sorted, non-random access collections while less efficiently (making `O(log N)` comparisons but `O(N)` index increments).

There are more than one kind of binary searches. Allsorts implements the following:

```swift
// indices:          0,   1,  2,   3,  4,  5,   6,  7,  8,  9
let xs: [Double] = [10,  20, 20,  30, 30, 30,  40, 40, 40, 40]

// Find an arbitrary sort-preserving insertion index
let i28: Int = xs.binarySearch {x in x <=> 28} //=> 3
let i29: Int = xs.binarySearch(29) //=> 3
let i30: Int = xs.binarySearch(30) //=> 3, 4, or 5
let i31: Int = xs.binarySearch(31) //=> 6

// Find index of an equal element, or `nil` if not found
let j28: Int? = xs.binaryFind {x in x <=> 28} //=> nil
let j29: Int? = xs.binaryFind(29) //=> nil
let j30: Int? = xs.binaryFind(30) //=> 3, 4, or 5
let j31: Int? = xs.binaryFind(31) //=> nil

/// Find the lowest sort-preserving insertion index
let l28: Int = xs.lowerBound {x in x <=> 28} //=> 3
let l29: Int = xs.lowerBound(of: 29) //=> 3
let l30: Int = xs.lowerBound(of: 30) //=> 3
let l31: Int = xs.lowerBound(of: 31) //=> 6

/// Find the lowest sort-preserving insertion index
let u28: Int = xs.upperBound {x in x <=> 28} //=> 3
let u29: Int = xs.upperBound(of: 29) //=> 3
let u30: Int = xs.upperBound(of: 30) //=> 6
let u31: Int = xs.upperBound(of: 31) //=> 6

/// Find the range of equal elements
let r28: Range<Int> = xs.equalRange {x in x <=> 28} //=> 3 ..< 3
let r29: Range<Int> = xs.equalRange(of: 29) //=> 3 ..< 3
let r30: Range<Int> = xs.equalRange(of: 30) //=> 3 ..< 6
let r31: Range<Int> = xs.equalRange(of: 31) //=> 6 ..< 6

let r20 = xs.equalRange(of: Ordering.within(20 ... 30)) //=> 1 ..< 6
```

Note that because `Range<Int>` is a collection itself, you can also call these methods on the `indices` of an `Array`:

```swift
let surnames   = ["Greenwood", "Greenwood", "O'Brien", "Selway", "Yorke"]
let givenNames = ["Colin",     "Jonny",     "Ed",      "Philip", "Thom"]
let index1 = surnames.binarySearch("York")                    //=> 4
let index2 = surnames.binarySearch("Yorkey")                  //=> 5
let index3 = surnames.binarySearch {n in n <=> "OK Computer"} //=> 3
let index4 = surnames.indices.binarySearch {i in
    surnames[i] <=> "Greenwood" || givenNames[i] <=> "Danny"
} //=> 1
```

Other
-----

### `Ended<T>`

For capping an infinite type like `String` with a maximum bound, wrap it in `Ended<T>`. It behaves like `T?` in `<=>` comparisons but is always a type conforming to `Orderable` (which `T?` can't be before Swift allows constrained extension of types).

```swift
enum Ended<T : Orderable> : Orderable {
    case value(T)
    case end
}

let a: Ended<String> = Ended("")    // .value("")
let b: Ended<String> = Ended("foo") // .value("foo")
let c: Ended<String> = Ended(nil)   // .end
let d: Ended<String> = Ended()      // .end

a <=> b // .less
b <=> c // .less
c <=> d // .equal
```

### `Bounded<T>`

`Bounded<T>` is like `Ended<T>` except with caps in both ends:

```swift
enum Bounded<T : Orderable> : Orderable, BoundedType {
    case Min
    case Med(T)
    case Max
}
```

In addition to `Orderable`, it conforms to another protocol `BoundedType` which simply adds the static member constants `Self.min` and `Self.max`, returning `.Min` and `.Max`, respectively.

### Binary heap

Ported to Swift from [libc++][] Allsorts implements the push and pop operations for array-backed binary trees. This feature isn't very performant, and should be considered experimental. (For the time being, you're probably better off just sorting an array instead.)

```swift
extension Array {
    mutating func pushHeap(value: Element, isOrderedBefore: (Element, Element) -> Bool)
    mutating func pushHeap(value: Element, _ ordering: (Element, Element) -> Ordering)

    mutating func popHeap(isOrderedBefore: (Element, Element) -> Bool) -> Element
    mutating func popHeap(ordering: (Element, Element) -> Ordering) -> Element
}

extension Array where Element : Comparable {
    mutating func pushHeap(value: T)
    mutating func popHeap() -> T
}
```


____
[Swift standard library]: http://swiftdoc.org/
[Comparable]: http://swiftdoc.org/protocol/Comparable/
[Equatable]: http://swiftdoc.org/protocol/Equatable/
[libc++]: http://libcxx.llvm.org/
