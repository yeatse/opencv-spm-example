//
//  stitching.cpp
//  TestOpenCV
//
//  Created by Yeatse on 2023/11/4.
//

#include "stitching.hpp"
#include <opencv2/stitching.hpp>

using namespace std;
using namespace cv;

Mat StitchImages(vector<Mat> images, bool* ok) {
    Mat pano;
    Ptr<Stitcher> stitcher = Stitcher::create(Stitcher::PANORAMA);
    Stitcher::Status status = stitcher->stitch(images, pano);
    if (ok) {
        *ok = status == Stitcher::OK;
    }
    return pano;
}
