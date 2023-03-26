//
//  RightFrameCollector.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 25.03.2023.
//

import Foundation
import Starscream

public class RightFrameCollector {
    public enum Event {
        case text(String)
        case binary(Data)
        case pong(Data?)
        case ping(Data?)
        case error(Error)
        case closed(String, UInt16)
    }
    weak var delegate: FrameCollectorDelegate?
    var buffer = Data()
    var frameCount = 0
    var isText = false //was the first frame a text frame or a binary frame?
    var needsDecompression = false
    
    public func add(frame: RightFrame) {
        //check single frame action and out of order frames
        if frame.opcode == .connectionClose {
            var code = frame.closeCode
            var reason = "connection closed by server"
            if let customCloseReason = String(data: frame.payload, encoding: .utf8) {
                reason = customCloseReason
            } else {
                code = CloseCode.protocolError.rawValue
            }
            delegate?.didForm(event: .closed(reason, code))
            return
        } else if frame.opcode == .pong {
            delegate?.didForm(event: .pong(frame.payload))
            return
        } else if frame.opcode == .ping {
            delegate?.didForm(event: .ping(frame.payload))
            return
        } else if frame.opcode == .continueFrame && frameCount == 0 {
            let errCode = CloseCode.protocolError.rawValue
            delegate?.didForm(event: .error(WSError(type: .protocolError, message: "first frame can't be a continue frame", code: errCode)))
            reset()
            return
        } else if frameCount > 0 && frame.opcode != .continueFrame {
            let errCode = CloseCode.protocolError.rawValue
            delegate?.didForm(event: .error(WSError(type: .protocolError, message: "second and beyond of fragment message must be a continue frame", code: errCode)))
            reset()
            return
        }
        if frameCount == 0 {
            isText = frame.opcode == .textFrame
            needsDecompression = frame.needsDecompression
        }
        
        let payload: Data
        if needsDecompression {
            payload = delegate?.decompress(data: frame.payload, isFinal: frame.isFin) ?? frame.payload
        } else {
            payload = frame.payload
        }
        buffer.append(payload)
        frameCount += 1

        if frame.isFin {
            if isText {
                if let string = String(data: buffer, encoding: .utf8) {
                    delegate?.didForm(event: .text(string))
                } else {
                    let errCode = CloseCode.protocolError.rawValue
                    delegate?.didForm(event: .error(WSError(type: .protocolError, message: "not valid UTF-8 data", code: errCode)))
                }
            } else {
                delegate?.didForm(event: .binary(buffer))
            }
            reset()
        }
    }
    
    func reset() {
        buffer = Data()
        frameCount = 0
    }
}
