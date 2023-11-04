//
//  stitching.hpp
//  TestOpenCV
//
//  Created by Yeatse on 2023/11/4.
//

#ifndef stitching_hpp
#define stitching_hpp

#include <opencv2/core.hpp>

cv::Mat StitchImages(std::vector<cv::Mat> images, bool* ok);

#endif /* stitching_hpp */
