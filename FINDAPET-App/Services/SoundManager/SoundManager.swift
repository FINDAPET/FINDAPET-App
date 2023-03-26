//
//  SoundManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.03.2023.
//

import Foundation
import AVFoundation

final class SoundManager {
    
    static func playSound(with name: SoundFileName, of type: SoundFileType) throws {
        guard let path = Bundle.main.path(forResource: name.rawValue, ofType: type.rawValue) else {
            throw SoundManagerError.notFoundSound(path: name.rawValue + type.rawValue)
        }
        
        if #available(iOS 16.0, *) {
            try AVAudioPlayer(contentsOf: .init(filePath: path)).play()
        } else {
            try AVAudioPlayer(contentsOf: .init(fileURLWithPath: path)).play()
        }
    }
    
}
