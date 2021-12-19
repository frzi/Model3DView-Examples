//
//  Panoramic
//  Created by Freek (github.com/frzi) 2021
//

import Model3DView
import SceneKit
import SwiftUI

struct ContentView: View {
    var body: some View {
		ZStack(alignment: .bottomTrailing) {
			PanoramaViewer(named: "Assets.scnassets/panoramas/dijon_notre_dame.jpg")
			
			Text("Image: wikipedia")
				.foregroundColor(.white)
				.padding(4)
				.background(Color.black.opacity(0.6))
		}
    }
}

// MARK: -
private struct PanoramaViewer: View {
	private static let scene = SCNScene()
	
	@State private var camera = PerspectiveCamera()
	private let imageURL: URL?
	
	init(named imageName: String) {
		self.imageURL = Bundle.main.url(forResource: imageName, withExtension: nil)
	}
	
	init(file: URL) {
		self.imageURL = file
	}
	
	var body: some View {
		Model3DView(scene: Self.scene)
			.cameraControls(OrbitControls(
				camera: $camera,
				sensitivity: 0.5
			))
			.skybox(file: imageURL)
	}
}
