//
//  Dashboard.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/21/24.
//

import SwiftUI
let screenWidth = UIScreen.main.bounds.width
struct Dashboard: View {

    var body: some View {
        VStack{
            Indicator()
            Switch()
        }

    }
}

#Preview {
    Dashboard()
}
