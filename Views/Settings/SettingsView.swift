//
//  SettingsView.swift
//  Weather
//
//  Created by Juho on 4.12.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("selectedUnit") private var selectedUnit = 0
    @AppStorage("activeTheme") private var activeTheme = false
    
    
    
    @State var lightMode:Bool = false
    @State var selectedText:String = "Celsius"
    @State var color: Color = .white
    
    var body: some View {
        VStack{
            //Header
            HStack(alignment: .center){
                Spacer()
                Text("settings")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            Divider()
    
            //Settings begin here
            
            //Unit of measurement
            Text("unit")
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    ZStack{
                        Text("℃")
                    }
                    .frame(width: 60.0, height: 60.0)
                    .background(selectedUnit == 0 ? .blue : .white)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        UserDefaults.standard.set(0, forKey: "selectedUnit")
                        print(selectedUnit)
                    }
                    Spacer()
                    
                    ZStack{
                        Text("℉")
                    }
                    .frame(width: 60.0, height: 60.0)
                    .background(selectedUnit == 1 ? .blue : .white)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        UserDefaults.standard.set(1, forKey: "selectedUnit")
                    }
                    Spacer()
                    
                    ZStack{
                        Text("K")
                    }
                    .frame(width: 60.0, height: 60.0)
                    .background(selectedUnit == 2 ? .blue : .white)
                    .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        UserDefaults.standard.set(2, forKey: "selectedUnit")

                    }
                    
                    Spacer()
                    
                }
                .frame(width: 330.0, height: 80.0)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.gray/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                HStack{
                    switch selectedUnit{
                    case 0:
                        Text("selected");Text("Celsius")
                    case 1:
                        Text("selected");Text("Fahrenheit")
                    case 2:
                        Text("selected");Text("Kelvin")
                    default:
                        Text("selected");Text("nil")
                    }
                    
                }
                }
            Spacer()
                .frame(height: 35.0)
            //Color mode
            Text("color")
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Toggle(isOn: $lightMode) {
                        Text("toggleTextColor")
                    }
                    Spacer()
                }
                .frame(width: 330.0, height: 80.0)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.gray/*@END_MENU_TOKEN@*/)
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                HStack{
                    if(!lightMode){
                        Text("selected");Text("light")
                        
                    }else{
                        Text("selected");Text("dark")
                        
                    }
                }
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
