//
//  Stitcher.h
//  TestOpenCV
//
//  Created by Yeatse on 2023/11/4.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv2.h>

NS_ASSUME_NONNULL_BEGIN

@interface Stitcher: NSObject

+ (Mat *)stitchImages:(NSArray<Mat *> *)images;

@end

NS_ASSUME_NONNULL_END
