//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct Communicator: View {
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isConfiguring = false
    @Binding var voiceGender: String
    @Binding var talkingSpeed: String
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @State var userHasChosenCat: Bool = false
    
    @Binding var isLocked: Bool
    
    var showSwitchView: Bool
    @Binding var onLeftOfSwitch: Bool
    
    init(pictoCollectionPath: String, catCollectionPath: String, voiceGender: Binding<String>, talkingSpeed: Binding<String>, isLocked: Binding<Bool>, showSwitchView: Bool = false, onLeftOfSwitch: Binding<Bool>){
        _pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        _catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
        _voiceGender = voiceGender
        _talkingSpeed = talkingSpeed
        _isLocked = isLocked
        self.showSwitchView = showSwitchView
        _onLeftOfSwitch = onLeftOfSwitch
    }
    
    var body: some View {
        let currCatColor: Color? = catVM.getCat(catId: pickedCategoryId)?.buildColor()
        let pictosInScreen: [PictogramModel] = searchText.isEmpty ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {

                    SearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                    
                    Spacer()
                    
                    ButtonView(text: "Configuración Voz", color: .blue, isDisabled: isLocked) {
                        //modal con opciones de velocidad de pronunciacion y genero de voz
                        isConfiguring = true
                    }
                    .font(.headline)
                    .sheet(isPresented: $isConfiguring) {
                        VoiceConfigurationView(talkingSpeed: $talkingSpeed, voiceGender: $voiceGender)
                    }
                    
                    LockView(isLocked: $isLocked)
                }
                .frame(height: 40)
                .background(Color.white)
                .padding(.vertical)
                .padding(.horizontal, 70)
                
                HStack(spacing: 15) {
                    Text("Categorias")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.gray)
                    
                    if showSwitchView {
                        SwitchView(onLeft: $onLeftOfSwitch, leftText: "Base", rightText: "Personal", width: 200)
                    }
                    
                    Divider()

                    HStack{
                        CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                    }
                    .background(Color.white)
                    .padding([.leading, .top, .bottom])
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Rectangle()
                    .frame(height: 20.0, alignment: .bottom)
                    .foregroundColor(currCatColor ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                
                PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 165, pictoHeight: 165, isBeingFiltered: !searchText.isEmpty)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: catVM.categories) { _ in
             if pickedCategoryId.isEmpty || !userHasChosenCat {
                 pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
             }
         }
        .navigationBarBackButtonHidden(isLocked)
    }
    
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    //text to speech
                    let utterance = AVSpeechUtterance(string: pictoModel.name)
                    
                    if (voiceGender == "Masculina") {
                        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed")
                    } else {
                        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                    }
                    
                    utterance.rate = talkingSpeed == "Normal" ? 0.5 : talkingSpeed == "Lenta" ? 0.3 : 0.7
                    
                    synthesizer.speak(utterance)

                }, label: {
                    PictogramView(pictoModel: pictoModel,
                                  catModel: catVM.getCat(catId: pictoModel.categoryId)!,
                                  displayName: true,
                                  displayCatColor: false,
                                  overlayImage: Image(systemName: "speaker.wave.3.fill"),
                                  overlayImageColor: .gray,
                                  overlyImageOpacity: 0.2)
                })
            )
        }
        return pictoButtons
    }
}
