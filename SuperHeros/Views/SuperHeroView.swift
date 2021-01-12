//
//  SuperHeroView.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/4/20.
//

import SwiftUI

struct SuperHeroView: View {
    
    var topBarHeight: CGFloat = 250
    var superHero: SuperHero
    @StateObject private var faveStorage = FaveSuperHeroStorage.shared
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HeaderView(faveStorage: faveStorage, superHero: superHero, height: 250)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack {
                        Text(superHero.name)
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                        Label(superHero.biography.fullname, systemImage: "person.fill")
                            .font(.system(.body, design: .serif))
                            
                        Label(superHero.work.base, systemImage: "mappin.and.ellipse")
                            .font(.system(.body, design: .serif))
                            .multilineTextAlignment(.center)
                    }
                    
                    //Powers section
                    DescriptionItem(title: "Powers", iconSystemImageName: "bolt.fill") {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            PowerBar(title: "intelligence", value: superHero.powerstats.intelligence.CGFloatValue() )
                            
                            PowerBar(title: "strength", value: superHero.powerstats.strength.CGFloatValue())
                            
                            PowerBar(title: "speed", value: superHero.powerstats.speed.CGFloatValue())

                            PowerBar(title: "combat", value: superHero.powerstats.combat.CGFloatValue())
                            
                            PowerBar(title: "power", value: superHero.powerstats.power.CGFloatValue())
                            
                        }
                    }
                    
                    //Appereance section
                    DescriptionItem(title: "Appereance", iconSystemImageName: "person.crop.square.fill") {
                        
                        VStack {
                            HStack {
                                Text("Weight:")
                                    .descriptionItemFont()
                                
                                Spacer()
                                
                                Text(superHero.appearance.weight[1])
                                    .descriptionItemFont()
                            }
                            
                            HStack {
                                Text("Height:")
                                    .descriptionItemFont()
                                
                                Spacer()
                                
                                Text(superHero.appearance.height[1])
                                    .descriptionItemFont()
                                    
                            }
                        }
                    }
                    
                    //First appereance section
                    DescriptionItem(title: "First Appereance", iconSystemImageName: "book.closed.fill") {
                        Text(superHero.biography.firstAppearance)
                            .descriptionItemFont()
                            .frame(alignment: .leading)
                        
                    }
                    
                    //Relatives appereance section
                    DescriptionItem(title: "Relatives", iconSystemImageName: "person.3.fill") {
                        Text(" - " + superHero.connections.relatives.replacingOccurrences(of: ",", with: "\n -"))
                            .descriptionItemFont()
                    }
                    
                }//END of ScrollView -> Vstack
                .padding([.bottom], 30)
            }
        }//END of Vstack
        .edgesIgnoringSafeArea(.all)
        
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
        .navigationBarItems(leading: Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
            Label("Back", systemImage: "chevron.left")
                .foregroundColor(.white)
        }))
    }
}


fileprivate struct PowerBar: View {
    
    var title: String
    var value: CGFloat?
    
    
    var body: some View {
        HStack {
            Text(title)
                .descriptionItemFont()
                .frame(minWidth: 100)
            
            GeometryReader { geo in
                
                if let _ = value {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .stroke(lineWidth: 3)
                        
                        Rectangle()
                            .background(Color.primary)
                            .frame(width: geo.size.width * value! / 100)
                    }
                }else {
                    Text("???")
                        .descriptionItemFont()
                        
                }
            }
            
        }
        .frame(height: 10)
    }
}

fileprivate struct DescriptionItem<Content>: View where Content: View {
    var title: String
    var iconSystemImageName: String = ""
    var content: () -> (Content)
    
    var body: some View {
        ZStack(alignment: .top) {
            
            HStack {
                content()
                    .padding(20)
                    .padding(.top, 30)
                
                Spacer()
            }
            .border(Color.primary, width: 5)
            .padding(.top, 20)
            
            HStack {
                Label(title, systemImage: iconSystemImageName)
                    .font(.system(size: 20, weight: .heavy, design: .serif))
                    .padding()
                    .border(Color.primary, width: 5)
                    .background(Color(.systemBackground))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
        }
    }
}

fileprivate struct HeaderView: View {
    @ObservedObject var faveStorage: FaveSuperHeroStorage
    @StateObject private var imageLoader = ImageLoader()
    var superHero: SuperHero
    var height: CGFloat
    
    var superHeroIsFave: Bool {
        faveStorage.superHeros.contains(where: {superHero.id == $0.id})
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                
                ZStack (alignment: .bottom) {
                    Image(uiImage: imageLoader.image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: height)
                        .clipped()
                    
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                        .clipped()
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                superHeroIsFave ?
                                    try? faveStorage.delete(superHeros: [superHero]):
                                    try? faveStorage.save(superHeros: [superHero])
                                    
                            }, label: {
                                Image(systemName: superHeroIsFave ? "star.fill" : "star")
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                    .foregroundColor(.primary)
                                    .padding(10)
                                    .background(Color(.systemBackground))
                                    .border(Color.primary, width: 5)
    
                                    
                            })
                        }
                        .padding(10)
                    }
                }
                
            }
            //bottom line
            Rectangle()
                .background(Color.primary)
                .frame(maxHeight: 5)
            
        }
        
        .frame(maxHeight: height)
        .onAppear(perform: {
            imageLoader.load(fromURLPath: superHero.image.url)
        })
    }
}

fileprivate extension Text {
    func descriptionItemFont() -> some View {
        self
            .font(.system(.body, design: .serif))
            .bold()
            .italic()
    }
}

struct SuperHeroView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SuperHeroView(superHero: [SuperHero].createMockData().first!)
        }
    }
}
