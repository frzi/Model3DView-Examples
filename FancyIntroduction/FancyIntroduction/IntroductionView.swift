/*
 * IntroductionView.swift
 * Created by Freek (github.com/frzi)
 */

import SwiftUI
import Model3DView

struct IntroductionView: View {

	/// The content of the pages.
	private static let pages: [(title: LocalizedStringKey, body: LocalizedStringKey)] = [
		("Create beautiful 3D assets", "Create some awesome assets in your favourite 3D modelling software."),
		("Export as glTF", "Export your work as a **glTF** format. Both text (`.gltf`) and binary (`.glb`) are supported!"),
		("Import to Xcode", "Add the **glTF** file and all associated resources to your project in **Xcode**."),
		("Enrichen your app!", "Make your app even more visually spectacular by using *Model3DView*!"),
	]
	
	// MARK: -
	@Binding var isPresented: Bool
	@State private var modelLoaded = false
	
	/**
	 We position the (perspective) camera exactly where we want it.
	 Angled slightly to add a bit more perspective.
	 */
	private let camera = PerspectiveCamera(position: [0, 0.5, 2], fov: .degrees(30)).lookingAt(center: [0, -0.25, 0])
	
	/**
	 The rotation angle(s) of the model. This will change accordingly to `currentIndex`.
	 Keep in mind we're rotating the model, *not* the camera.
	 */
	@State private var rotation = Euler(y: .degrees(-45))
	
	/**
	 The current index of the `TabView` we use for the paged effect.
	 */
	@State private var currentIndex = 0

	// MARK: -
	private func onNextPressed() {
		if currentIndex < Self.pages.count - 1 {
			withAnimation(.linear) {
				currentIndex += 1
			}
		}
		else {
			isPresented = false
		}
	}

	var body: some View {
		GeometryReader { proxy in
			VStack(spacing: 0) {
				Model3DView(named: "icons.gltf")
					.onLoad { state in
						modelLoaded = state == .success
					}
					.transform(rotate: rotation)
					.camera(camera)
					.frame(height: proxy.size.height / 2)
				
				TabView(selection: $currentIndex) {
					ForEach(Array(Self.pages.enumerated()), id: \.offset) { (index, page) in
						PagedView(title: page.title, content: page.body)
							.tag(index)
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .always))

				Button(action: onNextPressed) {
					HStack {
						Text("Continue")
						Image(systemName: "arrow.turn.down.right")
					}
				}
				.buttonStyle(.borderedProminent)
				.frame(maxWidth: .infinity)
			}
			.padding(.bottom, 30)
		}
		/**
		 Only show the contents once the model is fully loaded.
		 */
		.opacity(modelLoaded ? 1 : 0)
		.animation(.linear(duration: 0.6), value: modelLoaded)
		.background(Color.white)
		/**
		 Keep track of changes to `currentIndex`. Once it changes, rotate the model accordingly.
		 Note we're using `withAnimation` here. The `transform()` modifier of Model3DView is animatable!
		 */
		.onChange(of: currentIndex) { newIndex in
			withAnimation(.easeInOut(duration: 0.5)) {
				// Basically calculating how many degrees we should rotate based on the total number of pages.
				let slice = 360.0 / Double(Self.pages.count)
				let degrees = Double(newIndex) * -slice - (slice * 0.5)
				rotation.y = .degrees(degrees)
			}
		}
	}
}

/**
 A single "page" view holding nothing but a title and body text.
 Using `LocalizedStringKey` we can use markdown formatting.
 */
private struct PagedView: View {
	let title: LocalizedStringKey
	let content: LocalizedStringKey
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 20) {
				Text(title)
					.font(.system(size: 30, weight: .bold))
				
				Text(content)
					.font(.system(size: 20))
					.lineSpacing(6)
					.frame(alignment: .leading)
				
				Spacer()
			}
			
			Spacer()
		}
		.padding(.horizontal, 30)
		.foregroundColor(.black)
	}
}

#if DEBUG

struct IntroductionView_Preview: PreviewProvider {
	static var previews: some View {
		IntroductionView(isPresented: .constant(true))
	}
}

#endif
