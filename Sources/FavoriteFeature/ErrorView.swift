//
//  ErrorView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 26/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
  @Binding var errorText: String
  @Binding var isVisible: Bool
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Label(errorText, systemImage: "xmark.octagon.fill")
          .foregroundColor(.white)
          .padding(.vertical, 30)
          .padding(.horizontal, 30)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity)
      .background(.brown)
      .cornerRadius(12)
      .padding()
      .offset(y: isVisible ? 0 : 200)
      .animation(.default, value: isVisible)
    }
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView(errorText: .constant("This is an error"), isVisible: .constant(true))
  }
}
