//
//  Right.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 25.03.2023.
//

import Foundation
import Starscream

public protocol RightFramerEventClient: FramerEventClient {
    func frameProcessed(event: RightFrameEvent)
}

extension RightFramerEventClient {
    
    public func frameProcessed(event: FrameEvent) {
        self.frameProcessed(event: event)
    }
    
}
