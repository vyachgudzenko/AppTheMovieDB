//
//  CircleProgressBar.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 08.09.2022.
//

import SwiftUI

struct CircleProgressBar: View {
    var vote:Float
    var progress:Float{
        vote / 10
    }
    var label:Float{
        vote * 10
    }
    var progressColor:Color{
        get{
            switch vote{
            case 0...3.499:
                return .red
            case 3.5...7.499:
                return.orange
            case 7.5...11.0:
                return .green
            default:
                return .green
            }
        }
    }
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.black)
                .scaleEffect(1.2)
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth:10.0,lineCap: .round,lineJoin: .round))
                .foregroundColor(progressColor)
                .rotationEffect(.degrees(270))
            
            Text("\(Int(label))")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.title)
            
            
        }
    }
}

/*struct CircleProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressBar()
    }
}*/
