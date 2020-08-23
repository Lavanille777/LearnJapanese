//
//  LJSpeechManager.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/28.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import AVFoundation

class LJSpeechManager: AVSpeechSynthesizer, AVSpeechSynthesizerDelegate{
    
    private static var _sharedInstance: AVSpeechSynthesizer?
    
    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> AVSpeechSynthesizer {
        guard let instance = _sharedInstance else {
            _sharedInstance = AVSpeechSynthesizer()
            return _sharedInstance!
        }
        return instance
    }
    
    private override init() {
        super.init()
        self.delegate = self
    }
    
    class func speakWords(_ text: String) {
        if !LJSpeechManager.shared().isSpeaking{
            let utterance = AVSpeechUtterance(string: text)
            utterance.rate = 0.4  // 设置语速，范围0-1，注意0最慢，1最快；
            let speechVoice = AVSpeechSynthesisVoice(language:"ja-JP")
            utterance.voice = speechVoice //设置语速
            utterance.volume = 1;//设置音量
            utterance.pitchMultiplier = 1.0 // 声音的音调 0.5f～2.0f
            utterance.preUtteranceDelay = 0.0 //播放下下一句话的时候有多长时间的延迟 Default is 0.0
            utterance.postUtteranceDelay = 0.0 //开始播放之前需要等待多久 Default is 0.0
            LJSpeechManager.shared().speak(utterance)
        }
    }
    
}
