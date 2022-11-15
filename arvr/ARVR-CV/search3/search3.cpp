#include <stdio.h>
#include <ctype.h>
#include "cv.h"
#include "highgui.h"

void search_template(const CvArr* tmp, const CvArr* curr,
    const CvPoint2D32f template_feature, CvPoint2D32f *curr_feature_p,
    CvSize size, int step, char *status_p);
void on_mouse(int event, int x, int y, int flags, void* parameters);

#define SELECTING_FIRST_CORNER 0
#define SELECTING_SECOND_CORNER 1
#define SELECTED_REGION 2
#define SEARCHING 3
#define GOOD 1
#define BAD 0
#define THRESHOLD_BASE 50
#define WINDOW_STEP 3

IplImage* output = 0;
int mode = SELECTING_FIRST_CORNER;
CvPoint mouse_position;
CvPoint origin;
CvRect selection;

int main(int argc, char** argv) {
  CvCapture* capture = 0;
  IplImage* input = 0;
  IplImage* gray = 0;
  IplImage* template_gray = 0;
  int win_step;
  int template_width, template_height;
  CvPoint2D32f template_point;
  CvPoint2D32f current_point;
  char state;
  int p1x, p1y, p2x, p2y;
  int tick = 0, previous_tick = 0;
  double now = 0.0;
  CvFont font;
  char buffer[256];
  CvRect window;

  if (argc == 1 || (argc == 2 && strlen(argv[1]) == 1 && isdigit(argv[1][0]))) {
    capture = cvCreateCameraCapture(argc == 2 ? argv[1][0] - '0' : 0);
  } else if (argc == 2) {
    capture = cvCreateFileCapture(argv[1]);
  }
  if (!capture) {
    fprintf(stderr, "ERROR: capture is NULL \n");
    return (-1);
  }

  input = cvQueryFrame(capture);
  if (!input) {
    fprintf(stderr, "Could not query frame...\n");
    return (-1);
  }

  gray = cvCreateImage(cvGetSize(input), IPL_DEPTH_8U, 1);
  cvCvtColor(input, gray, CV_BGR2GRAY);
  template_gray = cvCreateImage(cvGetSize(input), 8, 1);

  output = cvCreateImage(cvSize(input->width, input->height), IPL_DEPTH_8U, 3);
  output->origin = input->origin;

  cvNamedWindow("Template", CV_WINDOW_AUTOSIZE);
  cvMoveWindow("Template", 40, 20);
  cvResizeWindow("Template", 640, 480);

  cvNamedWindow("Search", CV_WINDOW_AUTOSIZE);
  cvSetMouseCallback("Search", on_mouse, 0);
  cvMoveWindow("Search", 200, 100);
  cvResizeWindow("Search", 640, 480);

  cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 1.0, 1.0, 0.0, 1, 0);

  template_width = 32;
  template_height = 32;

  win_step = WINDOW_STEP;

  for (;;) {
    input = cvQueryFrame(capture);
    if (!input) {
      fprintf(stderr, "Could not query frame...\n");
      break;
    }

    cvCopy(input, output, NULL);
    cvCvtColor(input, gray, CV_BGR2GRAY);

    if (mode == SEARCHING) {
      search_template(template_gray, gray, template_point, &current_point,
          cvSize(template_width, template_height), win_step, &state);
      p1x = (int) current_point.x - template_width / 2;
      p1y = (int) current_point.y - template_height / 2;
      p2x = (int) current_point.x + template_width / 2 - 1;
      p2y = (int) current_point.y + template_height / 2 - 1;
      if (state == GOOD) {
        cvRectangle(output, cvPoint(p1x, p1y), cvPoint(p2x, p2y),
            CV_RGB(0, 255, 0), 1, // thickness, -1=filled
            8, // line_type, 8=8-connected
            0);
      } else {
        cvRectangle(output, cvPoint(p1x, p1y), cvPoint(p2x, p2y),
            CV_RGB(255, 0, 0), -1, // thickness, -1 = filled
            8, // line_type, 8=8-connected
            0);
      }
      p1x = (int) template_point.x - template_width / 2;
      p1y = (int) template_point.y - template_height / 2;
      p2x = (int) template_point.x + template_width / 2 - 1;
      p2y = (int) template_point.y + template_height / 2 - 1;
      cvRectangle(template_gray, cvPoint(p1x - 1, p1y - 1),
          cvPoint(p2x + 1, p2y + 1), CV_RGB(0, 255, 0), 1, // thickness, 1
          8, // line_type, 8=8-connected
          0);
    } else if (mode == SELECTED_REGION) {
      window = selection;
      cvRectangle(output, cvPoint(window.x, window.y),
          cvPoint(window.x + window.width, window.y + window.height),
          CV_RGB(0, 255, 0), 1, 8, 0);
      cvCvtColor(input, template_gray, CV_BGR2GRAY);
      template_point = cvPointTo32f(
          cvPoint(window.x + window.width / 2, window.y + window.height / 2));
      template_width = window.width;
      template_height = window.height;
      mode = SEARCHING;
    } else if (mode == SELECTING_SECOND_CORNER) {
      sprintf(buffer, "Select another corner!");
      cvPutText(output, buffer, cvPoint(150, 250), &font, CV_RGB(0, 255, 0));
    } else {
      sprintf(buffer, "Select a corner!");
      cvPutText(output, buffer, cvPoint(150, 250), &font, CV_RGB(0, 255, 0));
    }

    if ((mode == SELECTING_SECOND_CORNER) & (selection.width > 0)
        && (selection.height > 0)) {
      cvRectangle(
          output,
          cvPoint(selection.x, selection.y),
          cvPoint(selection.x + selection.width,
              selection.y + selection.height), CV_RGB(0, 0, 255), 1, 8, 0);
      cvSetImageROI(output, selection);
      cvXorS(output, cvScalarAll(255), output, 0);
      cvResetImageROI(output);
    }

    // draw cross 
    cvLine(output, cvPoint(mouse_position.x, 0),
        cvPoint(mouse_position.x, output->height - 1), CV_RGB(0, 255, 255), 1,
        8, 0);
    cvLine(output, cvPoint(0, mouse_position.y),
        cvPoint(output->width - 1, mouse_position.y), CV_RGB(0, 255, 255), 1, 8,
        0);

    sprintf(buffer, "%3.1lfms", now / 1000);
    cvPutText(output, buffer, cvPoint(50, 150), &font, CV_RGB(255, 0, 0));

    cvShowImage("Search", output);
    if (template_gray) {
      cvShowImage("Template", template_gray);
    }

    //If a certain key pressed
    if (cvWaitKey(10) >= 0) {
      break;
    }

    tick = cvGetTickCount();
    now = (tick - previous_tick) / cvGetTickFrequency();
    previous_tick = tick;
  }

  cvReleaseImage(&template_gray);
  cvReleaseImage(&gray);
  cvReleaseImage(&output);

  cvReleaseCapture(&capture);
  cvDestroyWindow("Search");

  return 0;
}

void search_template(const CvArr* tmp, const CvArr* curr,
    const CvPoint2D32f template_feature, CvPoint2D32f* curr_feature_p,
    CvSize size, int step, char *status_p) {
  uchar *dataR, *dataS;
  int stepR, stepS;
  CvSize sizeR, sizeS;
  int u, v;
  int uu, vv;
  unsigned int sum;
  unsigned int absdiff;
  unsigned int min_sum;
  int min_u, min_v;
  uchar *pR, *pS;
  uchar r, s;

  cvGetRawData(tmp, &dataR, &stepR, &sizeR);
  cvGetRawData(curr, &dataS, &stepS, &sizeS);

  min_sum = 255 * size.height * size.width + 1;
  min_u = (int) template_feature.x;
  min_v = (int) template_feature.y;
  *status_p = BAD;

  for (v = size.height / 2; v < sizeS.height - size.height / 2; v += step * 5) {
    for (u = size.width / 2; u < sizeS.width - size.width / 2; u += step * 5) {
      sum = 0;
      for (vv = -size.height / 2; vv < size.height / 2; vv += step) {
        for (uu = -size.width / 2; uu < size.width / 2; uu += step) {
          // r...get pixel of(template_f.x+uu, template_f.y+vv)
          //   from tmp frame
          pR = dataR + (int) template_feature.x + uu
              + stepR * ((int) template_feature.y + vv);
          r = *pR;
          // S...get pixel of(u+uu, v+vv) from current frame
          pS = dataS + u + uu + stepS * (v + vv);
          s = *pS;
          if (s > r) {
            absdiff = (int) (s - r);
          } else {
            absdiff = (int) (r - s);
          }
          sum = sum + absdiff;
        }
      }
      if (sum < min_sum) {
        min_sum = sum;
        min_u = u;
        min_v = v;
      }
    }
  }

  if (min_sum < (THRESHOLD_BASE * size.width * size.height / (step * step))) {
    *status_p = GOOD;
  }
  (*curr_feature_p).x = min_u;
  (*curr_feature_p).y = min_v;
  fprintf(stderr, "x=%lf, y=%lf, min_sum=%d, threshold=%d \n",
      (*curr_feature_p).x, (*curr_feature_p).y, min_sum,
      THRESHOLD_BASE * size.width * size.height / (step * step));
}

void on_mouse(int event, int x, int y, int flags, void* parameters) {
  if (!output) {
    return;
  }

  if (output->origin) {
    y = (output->height) - y;
  }

  if (mode == SELECTING_SECOND_CORNER) {
    selection.x = MIN(x, origin.x);
    selection.y = MIN(y, origin.y);
    selection.width = selection.x + CV_IABS(x - origin.x);
    selection.height = selection.y + CV_IABS(y - origin.y);

    selection.x = MAX(selection.x, 0);
    selection.y = MAX(selection.y, 0);
    selection.width = MIN(selection.width, output->width);
    selection.height = MIN(selection.height, output->height);
    selection.width = selection.width - selection.x;
    selection.height = selection.height - selection.y;
  }

  switch (event) {
  case CV_EVENT_MOUSEMOVE:
    mouse_position = cvPoint(x, y);
    break;
  case CV_EVENT_LBUTTONDOWN:
    if (mode == SEARCHING) {
      mode = SELECTING_FIRST_CORNER;
    }
    origin = cvPoint(x, y);
    selection = cvRect(x, y, 0, 0);
    mode = SELECTING_SECOND_CORNER;
    break;
  case CV_EVENT_LBUTTONUP:
    if ((selection.width > 0) && (selection.height > 0)) {
      mode = SELECTED_REGION;
    } else {
      mode = SELECTING_FIRST_CORNER;
    }
    break;
  }
}

