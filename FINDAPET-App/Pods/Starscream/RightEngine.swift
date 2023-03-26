//
//  RightEngine.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.03.2023.
//

import Foundation
import Starscream

public protocol RightEngine: Engine {
    func write(data: Data, opcode: FrameOpCode, completion: (() -> ())?)
}

extension RightEngine {
    public func write(data: Data, opcode: Starscream.FrameOpCode, completion: (() -> ())?) {
        self.write(data: data, opcode: opcode, completion: completion)
    }
}
