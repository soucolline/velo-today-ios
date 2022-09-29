//
//  FavoriteEmptyView.swift
//  velib-map
//
//  Created by Thomas Guilleminot on 26/08/2022.
//  Copyright © 2022 Thomas Guilleminot. All rights reserved.
//

import SwiftUI

struct FavoriteEmptyView: View {
  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "bicycle")
        .font(.system(size: 50))
      Text("Vous n'avez pas encore de favoris")
    }
  }
}

struct FavoriteEmptyView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteEmptyView()
  }
}
