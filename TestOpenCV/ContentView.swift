//
//  ContentView.swift
//  TestOpenCV
//
//  Created by Yeatse on 2023/7/16.
//

import SwiftUI
import opencv2

extension CGImage {
    static func fromAsset(_ name: String) -> CGImage {
        #if os(macOS)
        return NSImage(named: name)!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        #else
        return UIImage(named: name)!.cgImage!
        #endif
    }
}

struct ContentView: View {
    
    @State var stitchedImage: CGImage?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<6) { index in
                        Image("boat\(index + 1)")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .frame(height: 200)
            
            if let stitchedImage {
                Image(stitchedImage, scale: 1.0, label: Text("Stitched Image"))
                    .resizable()
                    .scaledToFit()
            } else {
                Button {
                    let images = (0..<6).map { index in
                        let mat = Mat(cgImage: .fromAsset("boat\(index + 1)"))
                        let dst = Mat()
                        Imgproc.cvtColor(src: mat, dst: dst, code: .COLOR_BGRA2BGR)
                        return dst
                    }
                    stitchedImage = Stitcher.stitchImages(images).toCGImage()
                } label: {
                    Text("Stitch")
                }
            }
        }
        .frame(minHeight: 400)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
