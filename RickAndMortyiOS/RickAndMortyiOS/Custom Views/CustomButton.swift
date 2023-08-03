//
//  CustomButton.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 27.12.2020.
//

import SwiftUI

struct CustomButtonView: View {
    let backgroundColor: Color
    let title: String
    let action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                Spacer()
            }
        }
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
