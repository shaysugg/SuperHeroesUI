//
//  ContentView.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/3/20.
//

import SwiftUI
import Combine

struct SuperHeroesListView: View {
    
    @State private var searchText: String = ""
    @State private var isFavesPresetnting = false
    @StateObject private var searcher = SuperHeroSearcher()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    SearchTextField(text: $searchText, isLoading: searcher.isFetching)
                        .onChange(of: searchText, perform: { value in
                            searcher.search(bySuperHeroName: value)
                        })
                        .padding()
                    
                    
                    LazyVStack {
                        ForEach(searcher.results) { (superhero) in
                            ZStack {
                                HeroCardView(superHero: superhero)
                                    .padding()
                                
                                EmptyNavigationLink(SuperHeroView(superHero: superhero))
                                
                            }.frame(height: 160)
                        }
                    }
                }
                .navigationBarTitle("Super Heroes", displayMode: .large)
                .navigationBarItems(
                    trailing: Button(action: {isFavesPresetnting.toggle()},
                                    label: { Image(systemName: "star.fill")}
                    ))
            }
        }.accentColor(.primary)
        .sheet(isPresented: $isFavesPresetnting, content: {
            FaveSuperHerosListView()
        })
    }
    
}

fileprivate struct SearchTextField: View {
    @Binding var text: String
    var isLoading: Bool
    
    var body: some View {
        ZStack {
            
            TextField("Search a hero by name", text: $text)
                .padding()
                .padding(.leading, 30)
                .border(Color.primary, width: 3)
                .font(.system(size: 15, weight: .bold, design: .serif))
            
            
            
            HStack {
                searchLeftView(isLoading: isLoading)
                
                Spacer()
                
                Button{
                    text = ""
                    print("X tapped")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }.foregroundColor(.primary)
                
            }.padding()
        }
    }
    
}

fileprivate struct searchLeftView: View {
    var isLoading: Bool
    var body: some View {
        if isLoading {
            ProgressView()
                .foregroundColor(.primary)
            
        }else {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
        
    }
}


fileprivate struct HeroCardView: View {
    var superHero: SuperHero
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack {
            Color.primary
                .offset(x: -10.0, y: 10.0)
            
            HStack(spacing: 13) {
                Image(uiImage: imageLoader.image)
                    .resizable()
                    
                    .scaledToFill()
                    .frame(width: 120, height: 140)
                    .border(Color.primary, width: 5)
                    .clipped()
                
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(superHero.name)
                        .font(.system(size: 23, weight: .black, design: .serif))
                    
                    Text(Image(systemName: "person.crop.circle.fill")) +
                        Text(" ") +
                        Text(superHero.biography.fullname)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                    
                    Text(Image(systemName: "building.2.crop.circle.fill")) +
                        Text(" ") +
                        Text(superHero.work.base)
                        .font(.system(size: 13, weight: .regular, design: .serif))
                    
                }.padding([.top, .bottom], 10)
                
                Spacer()
                
                Image(systemName: "chevron.compact.right")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .padding()
                
            }
            .background(Color(.systemBackground))
            .border(Color.primary, width: 5)
        }
        .onAppear(perform: {
            imageLoader.load(fromURLPath: superHero.image.url)
        })
        
    }
}

struct EmptyNavigationLink<destination>: View where destination: View {
    var toView: destination
    
    init(_ toView: destination){
        self.toView = toView
    }
    
    var body: some View {
        NavigationLink(
            destination: toView,
            label: {
                Rectangle().opacity(.leastNormalMagnitude)
                
            })
            .buttonStyle(PlainButtonStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SuperHeroesListView()
            .previewDevice("iPhone 11")
    }
}
