//
//  PictogramView.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import SwiftUI
import Kingfisher

struct PictogramView: View {
    var pictoModel: PictogramModel
    var catModel: CategoryModel
    var displayName: Bool
    var displayCatColor: Bool
    
    var overlayImage: Image?
    var overlayImageWidth: CGFloat = 0.2
    var overlayImageColor: Color = .black
    var overlyImageOpacity: Double = 1
    @Binding var imagen: UIImage?
    
    
    
    var body: some View {
        GeometryReader { geo in
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            ZStack() {
                catModel.buildColor()
                
                VStack {
                    if displayName {
                        Text(pictoModel.name.isEmpty ? "..." : pictoModel.name)
                            .font(.system(size: w * 0.1, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    if let thisImage = imagen {
                        Image(uiImage: thisImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        //print("Error, no se selecciono ninguna imagen")
                        KFImage(URL(string: pictoModel.imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding(.horizontal, w * 0.05)
                .padding(.vertical, h * 0.05)
                .frame(width: w * (displayCatColor ? 0.9 : 1), height: h * (displayCatColor ? 0.9 : 1))
                .background(.white)
            }
            .border(.black)
            .overlay(alignment: .topTrailing) {
                if overlayImage != nil {
                    overlayImage!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(overlayImageColor)
                        .opacity(overlyImageOpacity)
                        .frame(width: geo.size.width * overlayImageWidth)
                        .padding(10)
                }
            }
        }
    }
}

struct PictogramView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World!")
        }
    }
}
