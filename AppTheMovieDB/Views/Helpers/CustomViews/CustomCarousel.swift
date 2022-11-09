//
//  CustomCarousel.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 08.11.2022.
//

import SwiftUI

struct CustomCarousel<Content:View,DestinationView:View,Item,ID>: View where Item:RandomAccessCollection,ID:Hashable,Item.Element:Equatable,Item.Element:Identifiable {
    var content:(Item.Element,CGSize) -> Content
    var destination:DestinationView
    var id:KeyPath<Item.Element,ID>
    var spacing:CGFloat
    var cardPadding:CGFloat
    var items:Item
    var swipeLastElement:() -> Void
    @Binding var index:Int
    @Binding var currentId:Int
    @Binding private var showDetail:Bool
    
    var extraSpace:CGFloat{
        return (cardPadding / 2) - spacing
    }
    
    init(index:Binding<Int>, currentId:Binding<Int>,showDetail:Binding<Bool>,items:Item,spacing:CGFloat = 20,cardPadding:CGFloat = 150,id: KeyPath<Item.Element, ID>,@ViewBuilder destination:() -> DestinationView, @ViewBuilder content: @escaping (Item.Element,CGSize) -> Content,swipeLastElement: @escaping () -> Void = {}) {
        self.content = content
        self.destination = destination()
        self.id = id
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
        self._currentId = currentId
        self._showDetail = showDetail
        self.swipeLastElement = swipeLastElement
    }
    
    @GestureState var translation:CGFloat = 0
    @State var offset:CGFloat = 0
    @State var lastStoredOffset:CGFloat = 0
    
    @State var currentIndex:Int = 0
    @State var rotation:Double = 0
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let cardWidth = size.width - (cardPadding - spacing)
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { movie in
                    let index = indexOf(item: movie)
                    content(movie,CGSize(width: size.width - cardPadding, height: size.height))
                        .frame(width: size.width - cardPadding,height: size.height)
                        .rotationEffect(.degrees(Double(index) * 5),anchor: .bottom)
                        .rotationEffect(.degrees(rotation),anchor: .bottom)
                        .offset(y:offsetY(index: index, cardWidth: cardWidth))
                        .onTapGesture {
                            print("index \(index)")
                            print("count \(items.count)")
                            currentId = movie.id as! Int
                            showDetail = true
                        }
                        .fullScreenCover(isPresented: $showDetail) {
                            destination
                        }
                }
            }
            .padding(.horizontal,spacing)
            .offset(x: limiteScroll())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged({ value in
                        onChanged(value: value, cardWidth: cardWidth)
                    })
                    .onEnded({ value in
                        onEnd(value: value, cardWidth: cardWidth)
                    })
            )
        }
        .padding(.top,60)
        .onAppear(
            perform: {
                //let extraSpace = (cardPadding / 2) - spacing
                offset = extraSpace
                lastStoredOffset = extraSpace
            }
            
        )
        .animation(.easeInOut)
    }
    private func offsetY(index:Int,cardWidth:CGFloat) ->CGFloat{
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)
        let previus = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let inBetween = (index - 1) == self.index ? previus : next
        
        return index == self.index ? -60 - yOffset : inBetween
    }
    
    private func indexOf(item:Item.Element) -> Int{
        let array = Array(items)
        if let index = array.firstIndex(where: { $0 == item
        }) {
            return index
        } else {
            return 0
        }
    }
    
    private func limiteScroll() -> CGFloat{
        if index == 0 && offset > extraSpace{
            return extraSpace + (offset / 4)
        } else if index == items.count - 1 && translation < 0{
            return offset - (translation / 2)
        } else {
            return offset
        }
    }
    
    private func onChanged(value:DragGesture.Value,cardWidth:CGFloat){
        
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset
        
        let progress = offset / cardWidth
        rotation = (progress * 5)
        if index == items.count - 1 && translationX < 0{
            swipeLastElement()
        }
        
    }
    
    private func onEnd(value:DragGesture.Value,cardWidth:CGFloat){
        var localIndex = (offset / cardWidth).rounded()
        localIndex = max(-CGFloat(items.count - 1), localIndex)
        localIndex = min(localIndex, 0)
        currentIndex = Int(localIndex)
        index = -currentIndex
        withAnimation(.easeIn(duration: 0.25)) {
            offset = (cardWidth * localIndex) + extraSpace
            let progress = offset / cardWidth
            rotation = (progress * 5).rounded() - 1
        }
        lastStoredOffset = offset
    }
}

struct CustomCarousel_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovies()
            .environmentObject(MovieFetcher())
    }
}
