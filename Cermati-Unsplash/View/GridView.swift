//
//  GridView.swift
//  Cermati-Unsplash
//
//  Created by Abigail Aryaputra Sudarman on 02/08/21.
//

import SwiftUI

struct GridView: View {
    var result: Result
    @State private var isBlinking: Bool = true
    
    var body: some View {
        VStack{
            
            //Get new height based on original image ratio
            let width = UIScreen.main.bounds.maxX - 20
            let height = calculateHeight(originalWidth: result.width, originalHeight: result.height, desiredWidth: width)
            //Image
            ZStack{
                Rectangle()
                    .foregroundColor(Color(UIColor(hexString: result.color)))
                    .aspectRatio(contentMode: .fill)
                    .opacity(isBlinking ? 1 : 0.3)
                    .onAppear {
                        colorChange()
                    }
                
                
                RemoteImage(url: result.urls.thumb)
                
                
            } .frame(width: width, height: ceil(height) )
            .cornerRadius(10)
            //Details
            HStack{
                RemoteImage(url: result.user.profile_image.small)
                    .frame(width: 25, height: 25)
                Text("@\(result.user.username)")
                Spacer()
                
                Image(systemName: "suit.heart.fill")
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                    .accentColor(.black)
                Text("\(result.likes)")
            }.padding(.horizontal, 20)
        }
    }
    //Blinking animation when load
    private func colorChange() {
        
        self.isBlinking.toggle()
        
        // wait for 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1)), execute: {
            // Back to normal with ease animation
            withAnimation(.easeInOut(duration: 1).repeatForever()){
                self.isBlinking.toggle()
            }
        })
    }
    
}
func getImageFromRemote(result: Result) -> UIImage
{
    var myView: some View {
        RemoteImage(url: result.urls.full)
        
    }
    let uiImage = myView.asUIImage()
    return uiImage
}
//Get new height based on original image ratio
func calculateHeight(originalWidth: CGFloat, originalHeight: CGFloat, desiredWidth: CGFloat) -> CGFloat{
    let ratio = originalHeight / originalWidth
    let height = ratio * desiredWidth
    print(height)
    return height
}











extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
