//
//  Indicator.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/21/24.
//

import SwiftUI

struct Indicator: View {
    let widthRatio = 4.5
    let sensorCategory = ["Temp", "Humid"]
    var body: some View {
        ZStack()
        {
            RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                .fill(Color.white)
                .frame(width:screenWidth, height: 110)
                .shadow(radius: 5)

         
        }
    }
    

}

#Preview {
    Indicator()
}
