//
//  FavoritesView.swift
//  Weather
//
//  Created by Teemu on 5.12.2022.
//

import SwiftUI

struct FavouriteView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.place)]) var favourites: FetchedResults<Favourite>
    
    @EnvironmentObject var fmi: FMI
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(favourites) { fav in
                        if fmi.data[fav.place!] != nil {
                            NavigationLink {
                                ContentView()
                            } label : {
                                FavouriteRowView(place: fav.place!, data: fmi.data[fav.place!]!)
                            }
                        }
                    }
                    .onDelete(perform: deleteFavourite)
                }
                .listStyle(.plain)
                .onAppear {
                    for fav in favourites {
                        fmi.getForecast(place: fav.place!)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Favourite", systemImage: "plus.circle")
                    }
                }
            }.sheet(isPresented: $showingAddView) {
                AddFavouriteView()
            }
            .navigationTitle("favor")
        }
    }
    
    private func deleteFavourite(offsets: IndexSet) {
        withAnimation {
            offsets.map { favourites[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

