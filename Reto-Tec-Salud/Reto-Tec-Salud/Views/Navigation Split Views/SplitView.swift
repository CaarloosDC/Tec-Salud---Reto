//
//  SplitView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct SplitView<MainContent: View, DetailContent: View, PlaceHolder: View ,SelectedItemType>: View {
    // View holders
    var mainContent: MainContent // Sets row items for bodyParts, steps, etc...
    var detailContent: DetailContent // Detail view for single display
    var placeHolder: PlaceHolder
    var selectedItem: Binding<SelectedItemType?> // Binding for selected item
    
    var body: some View {
        NavigationSplitView {
            mainContent
                .navigationTitle("Opciones: ")
                .navigationBarTitleDisplayMode(.automatic)
        } detail: {
            if selectedItem.wrappedValue != nil {
                VStack {
                    detailContent
                    Spacer()
                }
            } else {
                VStack {
                    placeHolder
                    Spacer()
                }
            }
        }
    }
}
