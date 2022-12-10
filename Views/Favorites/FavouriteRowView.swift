//
//  FavouriteRowView.swift
//  Weather
//
//  Created by Teemu on 6.12.2022.
//

import SwiftUI

struct FavouriteRowView: View {
    let place: String
    let data: [WeatherStatus]
    
    var body: some View {
        HStack {
            Text(place)
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: data[0].symbol!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40)
                Text(String(format: "%.1f°C", data[0].temperature!))
            }
        }
        .padding(10)
        .background(.mint)
        .frame(maxWidth: .infinity)
        .shadow(radius: 10)
        .cornerRadius(10)
    }
}

