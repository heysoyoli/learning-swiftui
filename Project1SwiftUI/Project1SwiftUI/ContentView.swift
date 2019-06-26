//
//  ContentView.swift
//  Project1SwiftUI
//
//  Created by Oliver Hernández on 6/24/19.
//  Copyright © 2019 heysoyoli. All rights reserved.
//


import Combine
import SwiftUI


class DataSource : BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var pictures = [String]()
    
    init(){
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path){
            for item in items{
                if item.hasPrefix("nssl"){
                    pictures.append(item)
                }
            }
        }
        
        didChange.send(())
    }
}

struct DetailView: View {
    //States within one single view
    @State private var hidesNB = false
    var selectedimg: String
    
    var body:some View{
        let img = UIImage(named: selectedimg)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text(selectedimg), displayMode: .inline)
            .navigationBarHidden(hidesNB)
            .tapAction {
                self.hidesNB.toggle()
        }
    }
}

struct ContentView : View {
    
    @ObjectBinding var datasource = DataSource()
    
    var body: some View {
        NavigationView{
            List(datasource.pictures.identified(by: \.self)) {
                picture in
                NavigationButton(destination: DetailView(selectedimg: picture), isDetail: true){ Text(picture)}
                }.navigationBarTitle(Text("Enso"))
        }
    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
