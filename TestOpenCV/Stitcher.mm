//
//  Stitcher.mm
//  TestOpenCV
//
//  Created by Yeatse on 2023/11/4.
//

#import "Stitcher.h"
#import "stitching.hpp"

using namespace std;

@implementation Stitcher

+ (Mat *)stitchImages:(NSArray<Mat *> *)images {
    bool ok = false;
    auto input = vector<cv::Mat>(images.count);
    for (NSUInteger i = 0; i < images.count; i++) {
        input[i] = images[i].nativeRef;
    }
    auto image = StitchImages(input, &ok);
    if (!ok) {
        return nil;
    } else {
        return [Mat fromNative:image];
    }
}

@end

