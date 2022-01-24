import Foundation

/// Enum : use this for Result<T, T> when calling API
enum ApiError: Error {
    case url
    case query
    case server
    case decoding
    case other(error: String)
}
