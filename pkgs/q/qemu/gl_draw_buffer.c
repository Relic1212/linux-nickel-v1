#include <GL/gl.h>

extern void glDrawBuffers(GLsizei n, GLenum *bufs );

void glDrawBuffer(GLenum buf){
    glDrawBuffers(1, &buf);
}
// GLAPI void GLAPIENTRY glDrawBuffers(GLsizei n, GLenum *bufs );
