//
//  SwiftUIView.swift
//  
//
//  Created by Thomas Guilleminot on 03/12/2022.
//

import SwiftUI

public struct LoaderView: View {
  public var body: some View {
    VStack(spacing: 10) {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .black))
      Text("Chargement des stations")
        .lineLimit(0)
        .foregroundColor(.black)
    }
    .padding()
    .background(.white)
    .cornerRadius(10)
  }
}

struct LoaderView_Previews: PreviewProvider {
  static var previews: some View {
    LoaderView()
  }
}
