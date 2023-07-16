//
//  ContentView.swift
//  TestOpenCV
//
//  Created by Yeatse on 2023/7/16.
//

import SwiftUI
import opencv2

var originalImage: CGImage = {
#if os(macOS)
    let image = NSImage(named: "test")!
#else
    let image = UIImage(named: "test")!
#endif
    return image.cgImage!
}()

struct ContentView: View {
    
    @State var image: CGImage?
    
    func test(_ image: CGImage) -> CGImage {
        // Show source image
        let src = Mat(cgImage: image)
        
        // Transform source image to gray if it is not already
        let gray: Mat
        if src.channels() == 3 {
            gray = Mat()
            Imgproc.cvtColor(src: src, dst: gray, code: .COLOR_BGR2GRAY)
        } else if src.channels() == 4 {
            gray = Mat()
            Imgproc.cvtColor(src: src, dst: gray, code: .COLOR_BGRA2GRAY)
        } else {
            gray = src
        }
        
        // Apply adaptiveThreshold at the bitwise_not of gray, notice the ~ symbol
        let notGray = Mat()
        Core.bitwise_not(src: gray, dst: notGray)
        
        let bw = Mat()
        Imgproc.adaptiveThreshold(src: notGray, dst: bw, maxValue: 255, adaptiveMethod: .ADAPTIVE_THRESH_MEAN_C, thresholdType: .THRESH_BINARY, blockSize: 15, C: -2)
        
        // Create the images that will use to extract the horizontal lines
        let horizontal = bw.clone()
        let vertical = bw.clone()
        
        // Specify size on horizontal axis
        let horizontalSize = horizontal.cols() / 30
        // Create structure element for extracting horizontal lines through morphology operations
        let horizontalStructure = Imgproc.getStructuringElement(shape: .MORPH_RECT, ksize: .init(width: horizontalSize, height: 1))
        // Apply morphology operations
        Imgproc.erode(src: horizontal, dst: horizontal, kernel: horizontalStructure, anchor: .init(x: -1, y: -1))
        Imgproc.dilate(src: horizontal, dst: horizontal, kernel: horizontalStructure, anchor: .init(x: -1, y: -1))
        
        // Specify size on vertical axis
        let verticalSize = vertical.rows() / 30
        
        // Create structure element for extracting vertical lines through morphology operations
        let verticalStructure = Imgproc.getStructuringElement(shape: .MORPH_RECT, ksize: .init(width: 1, height: verticalSize))
        
        // Apply morphology operations
        Imgproc.erode(src: vertical, dst: vertical, kernel: verticalStructure, anchor: .init(x: -1, y: -1))
        Imgproc.dilate(src: vertical, dst: vertical, kernel: verticalStructure, anchor: .init(x: -1, y: -1))
        
        // Inverse vertical image
        Core.bitwise_not(src: vertical, dst: vertical)
        
        // Extract edges and smooth image according to the logic
        // 1. extract edges
        // 2. dilate(edges)
        // 3. src.copyTo(smooth)
        // 4. blur smooth img
        // 5. smooth.copyTo(src, edges)
        // Step 1
        let edges = Mat();
        Imgproc.adaptiveThreshold(src: vertical, dst: edges, maxValue: 255, adaptiveMethod: .ADAPTIVE_THRESH_MEAN_C, thresholdType: .THRESH_BINARY, blockSize: 3, C: -2)
        
        // Step 2
        let kernel = Mat.ones(rows: 2, cols: 2, type: CvType.CV_8UC1)
        Imgproc.dilate(src: edges, dst: edges, kernel: kernel)
        
        // Step 3
        let smooth = Mat();
        vertical.copy(to: smooth)
        
        // Step 4
        Imgproc.blur(src: smooth, dst: smooth, ksize: .init(width: 2, height: 2))
        
        // Step 5
        smooth.copy(to: vertical, mask: edges)
        
        // Show final result
        return horizontal.toCGImage()
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Test") {
#if os(macOS)
                let image = NSImage(named: "test")!
#else
                let image = UIImage(named: "test")!
#endif
                self.image = test(image.cgImage!)
            }
            if let image {
                Image(image, scale: 1, label: Text("Test"))
            } else {
                Image(originalImage, scale: 1, label: Text("Test"))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
