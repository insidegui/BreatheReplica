//
//  ContentView.swift
//  BreatheReplica WatchKit Extension
//
//  Created by Guilherme Rambo on 02/03/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import SwiftUI

extension Color {
    static let petalColor1 = Color(red: 125/255, green: 218/255, blue: 160/255)
    static let petalColor2 = Color(red: 84/255, green: 161/255, blue: 176/255)
}

extension Animation {
    static let breathe = Animation.easeInOut(duration: 5.4).repeatForever(autoreverses: true)
}

struct PetalView: View {
    let width: CGFloat = 93
    let geo: GeometryProxy
    let index: Double

    @State private var isContracted = true

    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [.petalColor1, .petalColor2]), startPoint: .top, endPoint: .bottom))
            .frame(width: width, height: width)
            .position(x: isContracted ? geo.size.width/2 : width/2, y: isContracted ? geo.size.width/2 : width/2)
            .opacity(0.7)
            .blendMode(.plusLighter)
            .onAppear {
                withAnimation(.breathe, {
                    self.isContracted.toggle()
                })
            }
    }
}

struct FlowerDimensionView: View {
    let petalCount: Int

    @State var isContracted = true

    var body: some View {
        Group {
            GeometryReader { geo in
                ForEach(0..<self.petalCount) { i in
                    Group {
                        PetalView(geo: geo, index: Double(i))
                    }
                    .rotationEffect(.degrees(Double(i * 60)))
                }
            }
        }
    }
}

struct FlowerView: View {
    let petalCount: Int

    @State private var isBackgroundContracted = true
    @State private var isContracted = true

    var body: some View {
        Group {
            FlowerDimensionView(petalCount: self.petalCount, isContracted: self.isContracted)
                .scaleEffect(isContracted ? 0.24 : 1)
                .rotationEffect(.degrees(isContracted ? -70 : 0))
                .padding()
                .onAppear {
                    withAnimation(.breathe, {
                        self.isContracted.toggle()
                    })
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        FlowerView(petalCount: 6)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
