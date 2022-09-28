//
//  FavoriteCell.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI

struct FavoriteCell: View {
  let name: String
  let freeBikes: Int
  let freeDocks: Int
  
  var body: some View {
    HStack {
      VStack {
        Text("\(freeBikes) vélos")
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(.orange)
          .cornerRadius(5)
          .foregroundColor(.white)
        
        Text("\(freeDocks) places")
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(.orange)
          .cornerRadius(5)
          .foregroundColor(.white)
      }
      .padding(.horizontal, 0)
      .padding(.vertical, 8)
      .fixedSize(horizontal: true, vertical: false)
      
      HStack {
        Text(name)
          .padding(.leading, 8)
      }
    }
  }
}

struct FavoriteCell_Previews: PreviewProvider {
  static var previews: some View {
    List {
      FavoriteCell(
        name: "Station name", freeBikes: 12, freeDocks: 13
      )
    }
  }
}
