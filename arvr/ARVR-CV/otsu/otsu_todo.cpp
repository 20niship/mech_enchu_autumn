#if 0
#include "cv.h"
#include "highgui.h"
#else
#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#endif
#include <cassert>
#include <ctype.h>
#include <limits>
#include <stdio.h>
#include <utility>

int bytes_per_pixel(const IplImage *image);
void process(IplImage *source, IplImage *destination);
int calc_otsu_threshold(int histogram[256]);

int main(int argc, char *argv[]) {
  CvCapture *capture = 0;
  IplImage *image = 0;
  IplImage *result = 0;
  const char *windowName = "binarize with Otsu method";

  if (argc == 1 || (argc == 2 && strlen(argv[1]) == 1 && isdigit(argv[1][0]))) {
    capture = cvCreateCameraCapture(argc == 2 ? argv[1][0] - '0' : 0);
  } else if (argc == 2) {
    capture = cvCreateFileCapture(argv[1]);
  }

  if (!capture) {
    fprintf(stderr, "ERROR: capture is NULL \n");
    return -1;
  }

  cvNamedWindow(windowName, 0);

  image = cvQueryFrame(capture);
  if (!image) {
    fprintf(stderr, "Could not query frame...\n");
    return -1;
  }
  result = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, 1);

  while (1) {
    image = cvQueryFrame(capture);
    if (!image) {
      fprintf(stderr, "Could not query frame...\n");
      break;
    }

    process(image, result);

    cvShowImage(windowName, result);

    if (cvWaitKey(10) >= 0) {
      break;
    }
  }

  cvReleaseImage(&result);

  cvReleaseCapture(&capture);
  cvDestroyWindow(windowName);

  return 0;
}

int bytes_per_pixel(const IplImage *image) {
  return (((image->depth & 255) / 8) * image->nChannels);
}

int _mt(const int histogram[256], int t) {
  int s = 0.f;
  for (int i = 0; i < t; i++)
    s += histogram[i];
  return s;
}

int _qt(const int histogram[256], int t) {
  int s = 0.f;
  for (int i = 0; i < t; i++)
    s += i * histogram[i];
  return s;
}

float calc_threshold(const int histogram[256], const int t) {
  const int N = _mt(histogram, 256);
  const float mt = (float)_mt(histogram, t);
  if (mt == 0 || N <= mt) {
    return std::numeric_limits<float>::min();
  }
  const float qt = (float)_qt(histogram, t);
  const float myu = (float)_qt(histogram, 256) / N;
  const float tmp = qt - mt * myu;
  const float th_square = tmp * tmp / mt / (N - mt);
  return th_square;
}

int calc_otsu_threshold(int histogram[256]) {
  float max = std::numeric_limits<float>::min();
  int threshold = 0;
  for (int i = 1; i < 256; i++) {
    const auto th2 = calc_threshold(histogram, i);
    assert(th2 >= 0);
    if (th2 > max) {
      threshold = i;
      max = th2;
    }
  }
  return threshold;
}

void process(IplImage *source, IplImage *destination) {
  int bppS, bppD;
  uchar *pS, *pD;
  uchar *dataS, *dataD;
  int stepS, stepD;
  CvSize sizeS;
  int x, y;
  double intensity;
  int intensity_d;

  int histogram[256];

  int threshold = 0;
  int i;

  bppS = bytes_per_pixel(source);
  bppD = bytes_per_pixel(destination);

  cvGetRawData(source, &dataS, &stepS, &sizeS);
  cvGetRawData(destination, &dataD, &stepD, NULL);

  for (i = 0; i < 256; i++) {
    histogram[i] = 0;
  }

  pS = dataS;

  for (y = 0; y < sizeS.height; y++) {
    for (x = 0; x < sizeS.width; x++) {
      intensity = (0.114 * pS[0] + 0.587 * pS[1] + 0.299 * pS[2]) / 255.0;
      intensity_d = (int)(219.0 * intensity) + 16;
      histogram[intensity_d]++;
      pS += bppS;
    }
  }

  threshold = calc_otsu_threshold(histogram);

  fprintf(stderr, "threshold = %d\n", threshold);

  pS = dataS;
  pD = dataD;

  for (y = 0; y < sizeS.height; y++) {
    for (x = 0; x < sizeS.width; x++) {
      intensity = (0.114 * pS[0] + 0.587 * pS[1] + 0.299 * pS[2]) / 255.0;
      intensity_d = (int)(219.0 * intensity) + 16;
      if (intensity_d > threshold) {
        *pD = 255;
      } else {
        *pD = 0;
      }
      pS += bppS;
      pD += bppD;
    }
  }
}
