//
//  FaveSuperHerosListView.swift
//  SuperHeros
//
//  Created by Sha Yan on 1/11/21.
//

import SwiftUI

struct FaveSuperHeroesListView: View {
    
    @StateObject private var storage = FaveSuperHeroStorage.shared
    
    var body: some View {
        NavigationView {
            if !storage.superHeros.isEmpty {
                List(storage.superHeros) { superHero in
                    NavigationLink(
                        destination: SuperHeroView(superHero: superHero),
                        label: {
                            Text(superHero.name)
                                .font(.system(.body, design: .serif))
                                .bold()
                                .padding()
                        })
                }
                .navigationTitle("Favorites")
                
            } else {
                Text("You don't have any favorites yet!")
                    .font(.system(.body, design: .serif))
                    .bold()
            }
            
            
        }
        
    }
}

struct FaveSuperHerosListView_Previews: PreviewProvider {
    static var previews: some View {
        FaveSuperHeroesListView()
    }
}
