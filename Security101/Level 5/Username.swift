//
//  Username.swift
//  Security101
//
//  Created by Dave Poirier on 2024-09-14.
//

import Foundation

struct Username: Sendable, Codable {
    let value: String

    enum Errors: Error {
        case invalidCharacters
        case tooShort
        case tooLong
    }

    init(value: String) throws {
        self.value = try Self.validated(value)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let candidate = try container.decode(String.self)
        value = try Self.validated(candidate)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }

    static func validated(_ value: String) throws -> String {
        let allowedCharacterSet = CharacterSet.alphanumerics
        guard allowedCharacterSet.isSuperset(of: CharacterSet(charactersIn: value)) else {
            throw Errors.invalidCharacters
        }
        guard value.count >= 4 else {
            throw Errors.tooShort
        }
        guard value.count <= 20 else {
            throw Errors.tooLong
        }
        return value
    }
}
