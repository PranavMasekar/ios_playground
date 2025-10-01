//
//  StreakView.swift
//  home_widgetExtension
//
//  Created by Pranav Masekar on 01/10/25.
//

import SwiftUI

struct StreakView: View {
    
    let entry: StreakEntry
    
    var body: some View {
        HStack (alignment: .center) {
            VStack (alignment: .leading) {
                
                Text(String(entry.count))
                    .font(.system(size: 50, design: .rounded))
                    .fontWeight(.black)
                
                Text("day streak!")
                    .fontWeight(.bold)
                    .font(.system(size: 20, design: .rounded))
            } //: VStack
            .foregroundStyle(.orange)
            .padding(.leading, 10)
            
            Spacer()
            
            Image("streak")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
        }
    }
}

#Preview {
    StreakView(entry: StreakEntry(count: 9))
}
