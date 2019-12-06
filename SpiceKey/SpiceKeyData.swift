//
//  SpiceKeyData.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/12/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation.NSObject

open class SpiceKeyData: NSObject, NSCoding {
    
    public var primaryKey: String
    public var keyCode: UInt16
    public var control: Bool
    public var option: Bool
    public var shift: Bool
    public var command: Bool
    public var spiceKey: SpiceKey?
    
    public init(_ primaryKey: String, _ keyCode: UInt16, _ control: Bool, _ option: Bool, _ shift: Bool, _ command: Bool, _ spiceKey: SpiceKey) {
        self.primaryKey = primaryKey
        self.keyCode = keyCode
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
        self.spiceKey = spiceKey
    }
    
    required public init?(coder aDecoder: NSCoder) {
        primaryKey = (aDecoder.decodeObject(forKey: "primaryKey") as? String) ?? ""
        keyCode = aDecoder.decodeObject(forKey: "keyCode") as! UInt16
        control = aDecoder.decodeBool(forKey: "control")
        option = aDecoder.decodeBool(forKey: "option")
        shift = aDecoder.decodeBool(forKey: "shift")
        command = aDecoder.decodeBool(forKey: "command")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(primaryKey, forKey: "primaryKey")
        aCoder.encode(keyCode, forKey: "keyCode")
        aCoder.encode(control, forKey: "control")
        aCoder.encode(option, forKey: "option")
        aCoder.encode(shift, forKey: "shift")
        aCoder.encode(command, forKey: "command")
    }
    
}
