//
//  ContentView.swift
//  Cermati-Unsplash
//
//  Created by Abigail Aryaputra Sudarman on 02/08/21.
//

import SwiftUI

struct ContentView: View {
    @State private var searchtext = "coffee"
    @ObservedObject var svm = SearchController()
    @ObservedObject var gvm = GridViewModel()
    //    @State var showContent = true
    
    
    var body: some View {
        //        var gridItems = [GridItem]()
        //
        //        for i in 0 ..< 30 {
        //        let randomHeight = CGFloat.random(in: 100 ... 400)
        //            gridItems.append(GridItem(height: Int(randomHeight), title: String(i)))
        //
        //        }
        //MARK:-Navigation area
        VStack{
            Text("Unsplash")
                .font(.system(size: 18, weight: .semibold, design: .default))
            HStack{
                //Search bar input
                TextField("search", text: $searchtext)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.gray)
                
                //Search button
                Button(action: {
                    gvm.results.removeAll()
                    self.gvm.defaultQuery = searchtext
                    self.gvm.loadMoreResults(query: searchtext)
                }, label: {
                    Text("Search")
                })
                
            }.padding(.all, 20).onAppear(perform: {
                print("first on appear run")
                gvm.results.removeAll()
                self.gvm.defaultQuery = searchtext
                self.gvm.loadMoreResults(query: searchtext)
                
            })
            
            //MARK:-Content area
            //Scroll view
            if gvm.errorCode == 0 {
                ScrollView{
                    //var odd = gvm.
                    var gridItemLayout = [GridItem(.flexible())]
                    LazyVGrid(columns: gridItemLayout){
                        ForEach(gvm, id: \.id) { result in
                            
                            GridView(result: result)
                                .onAppear {
                                    //Load article when appear, and load more article when scrolled to the bottom
                                    self.gvm.loadMoreResults(query: searchtext)
                                }
                        }
                        
                    }
                    LazyVGrid(columns: gridItemLayout){
                        ForEach(gvm, id: \.id) { result in
                            
                            
                            
                            GridView(result: result)
                                .onAppear {
                                    //Load article when appear, and load more article when scrolled to the bottom
                                    self.gvm.loadMoreResults(query: searchtext)
                                }
                        }
                        
                    }
                    
                }
            }  else if gvm.errorCode == 1001 {
                
                
                Text("1001 Request timed out. Please check your internet connection and reload the app").multilineTextAlignment(.center).position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
                
                
                
            } else
            {
                Text("Unidentified error")
            }
            
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






