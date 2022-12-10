//
//  MainView.swift
//  TestEnvironment
//
//  Created by iosdev on 10.12.2022.
//

import SwiftUI

struct MainView: View {
   
    @StateObject var fmi = FMI()
    
    var body: some View {
        if fmi.data.count == 0 {
            ProgressView()
        } else {
            TabView {
                

                ContentView()
                    .tabItem { Image(systemName: "house").imageScale(.large) }
                    .tag(1)
                
                FavouriteView()
                    .tabItem { Image(systemName: "list.dash").imageScale(.large) }
                    .tag(1)
                 
                
                CalendarView()
                    .tabItem { Image(systemName: "calendar").imageScale(.large) }
                    .tag(2)
                
                SettingsView()
                    .tabItem { Image(systemName: "gear").imageScale(.large) }
                    .tag(3)
 
            }
        }
    }
}

struct MainView_Previews: PreviewProvider{
    static var previews: some View {
        MainView()
    }
}
