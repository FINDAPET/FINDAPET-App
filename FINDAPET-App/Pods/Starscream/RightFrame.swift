//
//  RightFrame.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 25.03.2023.
//

import Foundation
import Starscream

public struct RightFrame {
    let isFin: Bool
    let needsDecompression: Bool
    let isMasked: Bool
    let opcode: FrameOpCode
    let payloadLength: UInt64
    let payload: Data
    let closeCode: UInt16 //only used by connectionClose opcode
}

