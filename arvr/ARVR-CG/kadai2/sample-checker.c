#include <GL/glut.h>
#include <stdio.h>

#define checkImageWidth 64
#define checkImageHeight 64
GLubyte checkImage[checkImageWidth][checkImageHeight][3];

void makeCheckImage(void) {
  int i, j, c;

  for (i = 0; i < checkImageWidth; i++) {
    for (j = 0; j < checkImageHeight; j++) {
      c = ((((i & 0x8) == 0) ^ ((j & 0x8) == 0))) * 255;
      checkImage[i][j][0] = (GLubyte)c;
      checkImage[i][j][1] = (GLubyte)c;
      checkImage[i][j][2] = (GLubyte)c;
    }
  }
}

/* 初期化 */
void myinit(void) {
  glClearColor(0.0, 0.0, 0.0, 0.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  makeCheckImage();

  // ラスタ位置（描画地点）の指定
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

  // checkImageをテクスチャバッファに格納
  glTexImage2D(GL_TEXTURE_2D, 0, 3, checkImageWidth, checkImageHeight, 0,
               GL_RGB, GL_UNSIGNED_BYTE, &checkImage[0][0][0]);

  // テクスチャバッファ使用の際のパラメータ設定
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

  // テクスチャ画像の表示方法を指定
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);

  // テクスチャマッピングを有効化
  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_FLAT);
}

/* 描画のコールバック関数 */
void display(void) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  /* 設定対象をtexname[0] のテクスチャに切り替える*/
  glBindTexture(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_2D);

  /* テクスチャ環境 */
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  /* キューブマッピングを有効にする */
  glEnable(GL_TEXTURE_CUBE_MAP);
  glEnable(GL_TEXTURE_GEN_S);
  glEnable(GL_TEXTURE_GEN_T);
  glEnable(GL_TEXTURE_GEN_R);

  static int rot = 0.0;
  glPushMatrix();
  glRotatef(rot*30, 0, 1, 0);
  glutSolidTeapot(1.0);
  glPopMatrix();
  rot += 1;
  printf("%d\n", rot);

  /*   // 四角形の描画 */
  /*   // テクスチャ座標の指定; ポリゴンの頂点位置の指定 */
  /*   glBegin(GL_QUADS); */
  /*   glTexCoord2f(0.0, 0.0); */
  /*   glVertex3f(-2.0, -1.0, 0.0); */
  /*   glTexCoord2f(0.0, 1.0); */
  /*   glVertex3f(-2.0, 1.0, 0.0); */
  /*   glTexCoord2f(1.0, 1.0); */
  /*   glVertex3f(0.0, 1.0, 0.0); */
  /*   glTexCoord2f(1.0, 0.0); */
  /*   glVertex3f(0.0, -1.0, 0.0); */

  /*   glTexCoord2f(0.0, 0.0); */
  /*   glVertex3f(1.0, -1.0, 0.0); */
  /*   glTexCoord2f(0.0, 1.0); */
  /*   glVertex3f(1.0, 1.0, 0.0); */
  /*   glTexCoord2f(1.0, 1.0); */
  /*   glVertex3f(2.41421, 1.0, -1.41421); */
  /*   glTexCoord2f(1.0, 0.0); */
  /*   glVertex3f(2.41421, -1.0, -1.41421); */
  /*   glEnd(); */

  // ダブル・バッファ処理
  glutSwapBuffers();
}

/* ウィンドウリサイズのコールバック関数 */
void myReshape(int w, int h) {
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(60.0, 1.0 * (GLfloat)w / (GLfloat)h, 1.0, 30.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0.0, 0.0, -3.6);
}

int main(int argc, char **argv) {
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);
  glutCreateWindow("checker");
  myinit();
  glutReshapeFunc(myReshape);
  glutDisplayFunc(display);
  glutMainLoop();
  return 0; /* ANSI C requires main to return int. */
}
