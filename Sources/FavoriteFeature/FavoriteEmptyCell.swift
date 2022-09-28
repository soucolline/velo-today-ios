//
//  FavoriteEmptyCell.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 13/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI

struct FavoriteEmptyCell: View {
  var body: some View {
    HStack {
      VStack {
        Text("12 vélos")
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(.bar)
          .cornerRadius(5)
        
        Text("13 places")
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(.bar)
          .cornerRadius(5)
      }
      .padding(.horizontal, 0)
      .padding(.vertical, 8)
      .fixedSize(horizontal: true, vertical: false)
      
      HStack {
        Text("Nom de la station tres tres long")
          .padding(.leading, 16)
      }
    }
    .redacted(reason: .placeholder)
  }
}

struct FavoriteEmptyCell_Previews: PreviewProvider {
  static var previews: some View {
    List {
      FavoriteEmptyCell()
    }
  }
}
