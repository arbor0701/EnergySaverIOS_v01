//
//  SliderV01.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/30/24.
//

import SwiftUI

struct SliderV01: View {
    
    var symbol: String?
    var progressRange: Int = 30
    @Bindable var peripheralSelected:BLEconnecting
    @Binding var settingValue: CGFloat
    @State var sliderProgress: CGFloat = 0.0
    @State var sliderHeight: CGFloat = 0.0
    @State var lastDragValue: CGFloat = 0.0
    let maxHeight: CGFloat = 100
    var body: some View {
        ZStack(alignment: .bottom) {
           Rectangle()
                .fill(Color.gray).opacity(0.5)
            
            Rectangle()
                .fill(Color.orange)
                .frame(height: sliderHeight)
        }
        .frame(width:screenWidth/5, height: 100)
        .cornerRadius(8)
        .gesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        
                        let translation = value.translation
                        sliderHeight = -translation.height+lastDragValue
                        sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                        sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
//                        set range from 0 to 30
                        let progress = sliderHeight/maxHeight
                        sliderProgress = progress * CGFloat(progressRange)
                    
                    })
                    .onEnded({ value in
                        sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                        sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                        lastDragValue = sliderHeight
                        print(lastDragValue)
                        settingValue = sliderProgress
                        
//                        peripheralSelected.writeValue(data: symbol == "%" ?  "{ \"Humid\":\(Int(sliderProgress))}" : "{ \"Temp\":\(Int(sliderProgress))}")
//                        print("hello \(Int(sliderProgress))")
                        
                    })
        )
        .overlay(
            Text("\(Int(sliderProgress)) \(symbol ?? "°")")
                .foregroundColor(.white)
                .padding(6)
                .background(Color.orange)
                .cornerRadius(8)
                .padding(8)
                .offset(y: sliderHeight < maxHeight - 80 ? -sliderHeight : -maxHeight + 80)
        )
    }
}

#Preview {
    SliderV01(symbol: "°", progressRange: 30,  peripheralSelected: BLEconnecting(),settingValue: .constant(CGFloat(0.0)) )
}
