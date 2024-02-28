/*
 String+Extension.swift


 Created by Takuto Nakamura on 2024/02/29.
*/

import Foundation

extension OSType: ExpressibleByStringLiteral {
    public init(stringLiteral: StringLiteralType) {
        if let data = stringLiteral.data(using: .macOSRoman) {
            self.init(data.reduce(0, { ($0 << 8) + Self($1) }))
        } else {
            self.init(0)
        }
    }
}
