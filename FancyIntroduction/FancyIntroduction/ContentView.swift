/*
 * ContentView.swift
 * Created by Freek (github.com/frzi)
 */

import SwiftUI

struct ContentView: View {
	@State private var sheetPresented = true

    var body: some View {
		VStack(spacing: 30) {
			Spacer()

			Image("logo")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 280)

			Text("Welcome")
				.font(.system(size: 30, weight: .bold, design: .monospaced))
				.foregroundColor(.white)

			Button(action: { sheetPresented = true }) {
				Text("Show introduction again")
					.foregroundColor(.black)
			}
			.tint(.white)
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.capsule)

			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color("colors/purple"))
		.ignoresSafeArea()
		.sheet(isPresented: $sheetPresented) {
			IntroductionView(isPresented: $sheetPresented)
				.interactiveDismissDisabled()
		}
    }
}
