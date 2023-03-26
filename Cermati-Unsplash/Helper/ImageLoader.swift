import SwiftUI
import UIKit
//Load image from given URL
struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
    //MARK:-Get image from url
        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }
            //
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @StateObject private var loader: Loader
    
    //Loading state
    var loading: Image
    var failure: Image
    //MARK:- Body
    var body: some View {
        // selectImage()
   
        ZStack{
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 25, height: 20)
                
            if let image = UIImage(data: loader.data) {
                GeometryReader{proxy in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
            }
        }
        
        
    }
    //MARK:- Init
    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        //handle loading and error
        self.loading = loading
        self.failure = failure
        
    }
    
    
    
    
}
