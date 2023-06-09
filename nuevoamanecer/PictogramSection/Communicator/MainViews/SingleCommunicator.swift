//
//  SingleCommunicator.swift
//  nuevoamanecer
//
//  Created by emilio on 12/06/23.
//

import SwiftUI

struct SingleCommunicator: View {
    var pictoCollectionPath: String
    var catCollectionPath: String
        
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
    @State var isLocked: Bool = false
    @State var onLeftOfSwitch: Bool = true
    
    var body: some View {
        Communicator(pictoCollectionPath: pictoCollectionPath, catCollectionPath: catCollectionPath, voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, isLocked: $isLocked, showSwitchView: false, onLeftOfSwitch: $onLeftOfSwitch)
    }
}
