//
//  LunaClient.swift
//  DiathekeEmbeddedDemo
//
//  Created by Eduard Miniakhmetov on 22.02.2022.
//  Copyright © 2022 Cobalt Speech and Language Inc. All rights reserved.
//

import Foundation
import Luna
import GRPC

public typealias LunaClient = Cobaltspeech_Luna_LunaClient

extension Cobaltspeech_Luna_LunaClient {
    
    convenience init(port: Int) {
        let target = ConnectionTarget.hostAndPort("127.0.0.1", port)
        let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1,
                                                                networkPreference: .best)
                    
        let configuration = ClientConnection.Configuration.default(target: target, eventLoopGroup: eventLoopGroup)
                
        let connection = ClientConnection(configuration: configuration)
        self.init(channel: connection)
    }
    
    
    func synthesize(text: String, voiceID: String, completion: @escaping (Data?, Error?) -> ()) {
        var request = Cobaltspeech_Luna_SynthesizeRequest()
        var config = Cobaltspeech_Luna_SynthesizerConfig()
        config.encoding = .rawLinear16
        config.voiceID = voiceID
        request.config = config
        request.text = text
        self.synthesize(request, callOptions: nil).response.whenComplete { result in
            switch result {
            case .success(let response):
                //print(response)
                completion(response.audio, nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
}
