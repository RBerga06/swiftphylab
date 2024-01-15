public prefix operator /

public protocol WithSum {
    static let O: Self  // Zero (x + O -> x)
    static func + (_ x: Self, _ y: Self) -> Self
    static func - (_ x: Self, _ y: Self) -> Self
    static prefix func - (_ x: Self) -> Self
}

public protocol ScalarField: WithSum {
    static let I: Self  // Identity (x * I -> x)
    static func * (_ x: Self, _ y: Self) -> Self
    static func / (_ x: Self, _ y: Self) -> Self
    static prefix func / (_ x: Self) -> Self
}
public extension ScalarField {
    static prefix func / (_ x: Self) -> Self { Self.I / x }
}

public extension Double: ScalarField {
    static let O = 0.0
    static let I = 1.0
}

public protocol VectorSpace: WithSum {
    associatedtype Scalar: ScalarField
    static func * (_ v: Self, _ x: Scalar) -> Self
    static func / (_ v: Self, _ x: Scalar) -> Self
}
public extension VectorSpace {
    static func / (_ v: Self, _ x: Scalar) -> Self { v * /x }
}

public struct Vector<K: ScalarField>: VectorSpace {
    private let data: Array<K>
    public init(_ data: K...) {
        self.data = data;
    }
    // VectorSpace implementation
    typealias Scalar = K
    static public let O = {
        Self(repeatElement(K.O, count: I))
    }()
    static func + (_ v: Self, _ w: Self) -> Self {
        Self(zip(v, w).compactMap({ $0 + $1 }))
    }
    static func * (_ v: Self, _ x: K) -> Self {
        Self(v.data.compactMap({ $0 * x }))
    }
}

let v = Vector<Double>(42);
