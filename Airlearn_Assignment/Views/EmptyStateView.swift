//
//  EmptyStateView.swift
//  Airlearn_Assignment
//
//  Created by Viswanath M on 14/07/25.
//

import SwiftUI

struct EmptyStateView: View {
    
    var emptyMessage: String
    
    var body: some View {
        VStack(spacing: 16){
            
            Image(systemName: "leaf.arrow.circlepath").font(.system(size: 60)).foregroundStyle(.green)
            
            Text(emptyMessage).font(.headline).foregroundStyle(.primary)
        }.padding(.horizontal)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(emptyMessage: "")
    }
}


struct CircularLoader: View {
    
    @State private var trimEnd = 0.6
    @State private var animate = false
    
    var body: some View {
        Circle()
            .trim(from: 0.0,to: trimEnd)
            .stroke(.blue, style: StrokeStyle(lineWidth: 7,lineCap: .round,lineJoin:.round))
            .animation(
                Animation.easeIn(duration: 1)
                    .repeatForever(autoreverses: true),
                value: trimEnd
            )
            .frame(width: 50,height: 50)
            .rotationEffect(Angle(degrees: animate ? 270 + 360 : 270))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: animate
            )
            .onAppear{
                animate = true
                trimEnd = 0
            }
    }
}




enum ViewCurrentState{
    case loading
    case searchEmpty
    case dataEmpty
    case hasData
}

enum UserDetailsViewCurrentState{
    case loading
    case dataEmpty
    case hasData
}
