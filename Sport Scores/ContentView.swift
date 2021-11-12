//
//  ContentView.swift
//  Sport Scores
//
//  Created by Chris on 11/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showResults = false
    @ObservedObject var viewModel: ContentViewModel
    
    init() {
        let scoreFetcher = ScoreFetcher()
        self.viewModel = ContentViewModel(scoreFetcher: scoreFetcher)
    }
    
    var body: some View {
        if (!showResults) {
        Button("Get Results") {
            showResults.toggle()
        }
        } else {
            ProgressView()
            Text("Showing Results").font(.largeTitle).onAppear(perform: viewModel.refresh)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
