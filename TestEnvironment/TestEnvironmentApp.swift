//
//  TestEnvironmentApp.swift
//  TestEnvironment
//
//  Created by iosdev on 10.12.2022.
//

import SwiftUI

@main
struct TestEnvironmentApp: App {
    @StateObject var fmi = FMI()
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
            /*
                .onAppear(){
                        fmi.getForecast(place: fmi.loc)
                }
            */
        }
    }
}
