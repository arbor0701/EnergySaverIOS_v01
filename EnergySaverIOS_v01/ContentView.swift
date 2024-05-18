//
//  ContentView.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        
        TabView{
            Setting()
                .tabItem{
                    Image(systemName:"gearshape.fill")
                    Text("Setting")
                }
            Dashboard()
                .tabItem{
                    Image(systemName:"thermometer.snowflake")
                    Text("Dashboard")
                }
   
   
        }
        
    }

}

#Preview {
    ContentView()
    
}
