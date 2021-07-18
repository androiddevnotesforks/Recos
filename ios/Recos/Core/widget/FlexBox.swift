//
//  FlexBox.swift
//  Example
//
//  Created by tigerAndBull on 2021/6/12.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

import Foundation
import SwiftUI

enum Display {
    case flex
    case inlineFlex
}

enum FlexDirection {
    case Row
    case RowReverse
    case Column
    case ColumnReverse
}

enum JustifyContent {
    case FlexStart
    case FlexEnd
    case Center
    case SpaceBetween
    case SpaceAround
    case SpaceEvenly
}

enum AlignItems {
    case FlexStart
    case FlexEnd
    case Center
    case Baseline
    case Stretch
}

enum AlignContent {
    case FlexStart
    case FlexEnd
    case Center
    case SpaceBetween
    case SpaceAround
    case SpaceEvenly
    case Stretch
}

enum AlignSelf {
    case Auto
    case FlexStart
    case FlexEnd
    case Center
    case Baseline
    case Stretch
}

enum FlexWrap {
    case Wrap
    case WrapReverse
    case NoWrap
}

class FlexItem {
    var intrinsicsMainSize: Int = 0
    var intrinsicsCrossSize: Int = 0
    var mainStart: Int = 0
    var crossStart: Int = 0
}

// TODO
internal class FlexItemOrderModifier {
    var order: Int = 0
    
}

struct FlexBox: View {
    
    var display: Display = .flex
    var flexDirection: FlexDirection = .Row
    var justifyContent: JustifyContent = .Center
    var aligenItems: AlignItems = .Center
    var flexWrap: FlexWrap = .NoWrap
    
    @State var jsObject: JsObject?
    
    init(jsObject: JsObject) {
        self.jsObject = jsObject
    }
    
    var body: some View {
        Text("111")
    }
    
    func flexBoxEngine(superStyle: JsObject, subStyles: [JsObject]) -> Void {
        // 获取父类frame
        let width = superStyle.getValue(variable: "width") as? Float ?? 0
        let height = superStyle.getValue(variable: "height") as? Float ?? 0
        let x = 0
        let y = 0
        let superFrame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
        for index in 0...subStyles.count {
            flexBoxEngineForEach(superStyle: superStyle, subStyle: subStyles[index], index: index, superFrame: superFrame)
        }
    }
    
    func flexBoxEngineForEach(superStyle: JsObject, subStyle: JsObject, index: Int, superFrame: CGRect) -> Void {
        
        var flexDirection: FlexDirection = superStyle.getValue(variable: "flexDirection") as? FlexDirection ?? .Row
        var justifyContent: JustifyContent = superStyle.getValue(variable: "justifyContent") as? JustifyContent ?? .Center
        
        // 获取frame
        
        // 计算frame
        
        // 返回frame
        
    }

}

class FlexItemData {
    
}

struct RecosFlexBoxView<Item, Content> : View where Item: Hashable, Content: View {
    let alignment: Alignment
    let spacing: CGFloat
    let items: [Item]
    let content: (Int) -> Content
    
    @State private var sizeBody: CGSize? = nil
    @State private var widthItems: [Item: CGFloat] = [:]
    
    init(alignment: Alignment = .center, spacing: CGFloat = 0, items: [Item], @ViewBuilder content: @escaping (Int) -> Content) {
        self.spacing = spacing
        self.alignment = alignment
        self.items = items
        self.content = content
    }
    
    var body: some View {
        self.contentView
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: self.alignment)
            .background(
                GeometryReader { (geo) in
                    Color.clear.onAppear {
                        self.sizeBody = geo.frame(in: .global).size
                    }
                }
            )
    }
    
    private var contentView: some View {
        VStack(alignment: self.alignment.horizontal, spacing: self.spacing) {
            ForEach(self.rowsIndices, id: \.self) { (row) in
                self.createRow(indices: row)
            }
        }
    }
    
    private func createRow(indices: [Int]) -> some View {
        HStack(alignment: self.alignment.vertical, spacing: self.spacing) {
            ForEach(indices, id: \.self) { (index) in
                Group {
                    self.content(index)
                }
                .background(
                    GeometryReader { (geo) in
                        Color.clear.onAppear {
                            self.widthItems[self.items[index]] = geo.frame(in: .global).size.width
                        }
                    }
                )
            }
        }
    }
    
    private var rowsIndices: [[Int]] {
        guard let widthBody = self.sizeBody?.width else {
            return self.items.indices.map { [ $0 ] }
        }
        var rowWidth: CGFloat = 0
        var rowItems: [Int] = []
        var rows: [[Int]] = []
        for index in 0 ..< items.count {
            if  let widthItem = self.widthItems[self.items[index]] {
                let rowWidthNext = rowWidth + widthItem + (rowItems.isEmpty ? 0 : self.spacing)
                if rowWidthNext <= widthBody {
                    rowItems.append(index)
                    rowWidth = rowWidthNext
                }
                else {
                    if rowItems.isEmpty == false {
                        rows.append(rowItems)
                        rowWidth = 0
                        rowItems = []
                    }
                    rowWidth = widthItem
                    rowItems = [ index ]
                }
            }
            else {
                if rowItems.isEmpty == false {
                    rows.append(rowItems)
                    rowWidth = 0
                    rowItems = []
                }
                rows.append([ index ])
            }
        }
        if rowItems.isEmpty == false {
            rows.append(rowItems)
            rowWidth = 0
            rowItems = []
        }
        return rows
    }
}

struct TestText : View {
    let text: String
    @State private var color: Bool = false
    var body: some View {
        Text(self.text)
            .lineLimit(1)
            .fixedSize()
            .background(self.color ? Color.orange : Color.gray)
            .foregroundColor(self.color ? Color.green : Color.black)
            .onTapGesture {
                self.color.toggle()
            }
    }
}

//struct TABContentView: View {
//    @State var data: [Int] = [
//        113, 2, 2342343, 234, 234234234234324, 3,
//        45345435345345, 545, 34, 4, 345345345, 45345, 5, 5
//    ]
//    var body: some View {
//
//    }
//}
