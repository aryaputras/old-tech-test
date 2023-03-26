//
//  WaterfallGridView.swift
//  Cermati-Unsplash
//
//  Created by Abigail Aryaputra Sudarman on 03/08/21.
//

import SwiftUI
struct GridItemz: Identifiable {
    var id = UUID()
    var height: Int
    var title: String
    
}


struct WaterfallGridView: View {
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [GridItemz]()
    }

    var gvm = GridViewModel()
    var columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(gridItem:[GridItemz], numOfColumns: Int, spacing: CGFloat = 20, horizontalPadding: CGFloat = 20) {
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        
        
        var columns = [Column]()
        
        for _ in 0 ..< numOfColumns {
            columns.append(Column())
            
        }
        
        var columnsHeight = Array<CGFloat>(repeating: 0, count: numOfColumns)
        
        for item in gridItem {
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count {
                let curHeight = columnsHeight[i]
                if curHeight < smallestHeight {
                    smallestHeight = curHeight
                    smallestColumnIndex = 1
                }
            }
            columns[smallestColumnIndex].gridItems.append(item)
            columnsHeight[smallestColumnIndex] += CGFloat(item.height)
        }
        self.columns = columns
    }
    
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing){
            ForEach(columns) { column in
                LazyVStack(spacing: spacing){
                    ForEach(column.gridItems, id: \.id) { result in
                        
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(height: CGFloat(result.height))
                        
                    }
                }
            }
        }
    }
    func getItemView(gridItem: GridItemz) -> some View {
        ZStack{
            GeometryReader { proxy in
//                RemoteImage(url: result.urls.thumb)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: proxy.size.width, heightL proxy.size.height, alignment: .center)
            }
        }.frame(height: CGFloat(gridItem.height))
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    
    }
}
