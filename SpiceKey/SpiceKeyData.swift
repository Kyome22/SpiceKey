//
//  SpiceKeyData.swift
//  SpiceKey
//
//  Created by Takuto Nakamura on 2019/12/03.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation.NSObject

public class SpiceKeyData: NSObject, NSCoding {
    
    public private(set) var primaryKey: String
    public private(set) var keyCode: UInt16
    public private(set) var shift: Bool
    public private(set) var control: Bool
    public private(set) var option: Bool
    public private(set) var command: Bool
    public var spiceKey: SpiceKey?
    
    public init(_ primaryKey: String, _ keyCode: UInt16, _ shift: Bool, _ control: Bool, _ option: Bool, _ command: Bool, _ spiceKey: SpiceKey) {
        self.primaryKey = primaryKey
        self.keyCode = keyCode
        self.shift = shift
        self.control = control
        self.option = option
        self.command = command
        self.spiceKey = spiceKey
    }
    
    required public init?(coder aDecoder: NSCoder) {
        primaryKey = aDecoder.decodeObject(forKey: "primaryKey") as! String
        keyCode = aDecoder.decodeObject(forKey: "keyCode") as! UInt16
        shift = aDecoder.decodeBool(forKey: "shift")
        control = aDecoder.decodeBool(forKey: "control")
        option = aDecoder.decodeBool(forKey: "option")
        command = aDecoder.decodeBool(forKey: "command")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(primaryKey, forKey: "primaryKey")
        aCoder.encode(keyCode, forKey: "keyCode")
        aCoder.encode(shift, forKey: "shift")
        aCoder.encode(control, forKey: "control")
        aCoder.encode(option, forKey: "option")
        aCoder.encode(command, forKey: "command")
    }
    
}
