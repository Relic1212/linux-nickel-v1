#include <EGL/egl.h>
#define EGL_EGLEXT_PROTOTYPES
#include <EGL/eglext.h>
#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

void *dlsym_new(void *__restrict p, const char *__restrict s)
{
    fprintf(stderr, "dlsym_new called wit s=\"%s\"\n", s);

    // -------------- GEN -------------------------------

    if (strcmp(s, "eglBindAPI") == 0)
    {
        fprintf(stderr, "found sym eglBindAPI");
        return eglBindAPI;
    }
    else

        if (strcmp(s, "eglBindTexImage") == 0)
    {
        fprintf(stderr, "found sym eglBindTexImage");
        return eglBindTexImage;
    }
    else

        if (strcmp(s, "eglChooseConfig") == 0)
    {
        fprintf(stderr, "found sym eglChooseConfig");
        return eglChooseConfig;
    }
    else

        if (strcmp(s, "eglClientWaitSync") == 0)
    {
        fprintf(stderr, "found sym eglClientWaitSync");
        return eglClientWaitSync;
    }
    else

        if (strcmp(s, "eglCopyBuffers") == 0)
    {
        fprintf(stderr, "found sym eglCopyBuffers");
        return eglCopyBuffers;
    }
    else

        if (strcmp(s, "eglCreateContext") == 0)
    {
        fprintf(stderr, "found sym eglCreateContext");
        return eglCreateContext;
    }
    else

        if (strcmp(s, "eglCreateImage") == 0)
    {
        fprintf(stderr, "found sym eglCreateImage");
        return eglCreateImage;
    }
    else

        if (strcmp(s, "eglCreatePbufferFromClientBuffer") == 0)
    {
        fprintf(stderr, "found sym eglCreatePbufferFromClientBuffer");
        return eglCreatePbufferFromClientBuffer;
    }
    else

        if (strcmp(s, "eglCreatePbufferSurface") == 0)
    {
        fprintf(stderr, "found sym eglCreatePbufferSurface");
        return eglCreatePbufferSurface;
    }
    else

        if (strcmp(s, "eglCreatePixmapSurface") == 0)
    {
        fprintf(stderr, "found sym eglCreatePixmapSurface");
        return eglCreatePixmapSurface;
    }
    else

        if (strcmp(s, "eglCreatePlatformPixmapSurface") == 0)
    {
        fprintf(stderr, "found sym eglCreatePlatformPixmapSurface");
        return eglCreatePlatformPixmapSurface;
    }
    else

        if (strcmp(s, "eglCreatePlatformWindowSurface") == 0)
    {
        fprintf(stderr, "found sym eglCreatePlatformWindowSurface");
        return eglCreatePlatformWindowSurface;
    }
    else

        if (strcmp(s, "eglCreateSync") == 0)
    {
        fprintf(stderr, "found sym eglCreateSync");
        return eglCreateSync;
    }
    else

        if (strcmp(s, "eglCreateWindowSurface") == 0)
    {
        fprintf(stderr, "found sym eglCreateWindowSurface");
        return eglCreateWindowSurface;
    }
    else

        if (strcmp(s, "eglDestroyContext") == 0)
    {
        fprintf(stderr, "found sym eglDestroyContext");
        return eglDestroyContext;
    }
    else

        if (strcmp(s, "eglDestroyImage") == 0)
    {
        fprintf(stderr, "found sym eglDestroyImage");
        return eglDestroyImage;
    }
    else

        if (strcmp(s, "eglDestroySurface") == 0)
    {
        fprintf(stderr, "found sym eglDestroySurface");
        return eglDestroySurface;
    }
    else

        if (strcmp(s, "eglDestroySync") == 0)
    {
        fprintf(stderr, "found sym eglDestroySync");
        return eglDestroySync;
    }
    else

        if (strcmp(s, "eglGetConfigAttrib") == 0)
    {
        fprintf(stderr, "found sym eglGetConfigAttrib");
        return eglGetConfigAttrib;
    }
    else

        if (strcmp(s, "eglGetConfigs") == 0)
    {
        fprintf(stderr, "found sym eglGetConfigs");
        return eglGetConfigs;
    }
    else

        if (strcmp(s, "eglGetCurrentContext") == 0)
    {
        fprintf(stderr, "found sym eglGetCurrentContext");
        return eglGetCurrentContext;
    }
    else

        if (strcmp(s, "eglGetCurrentDisplay") == 0)
    {
        fprintf(stderr, "found sym eglGetCurrentDisplay");
        return eglGetCurrentDisplay;
    }
    else

        if (strcmp(s, "eglGetCurrentSurface") == 0)
    {
        fprintf(stderr, "found sym eglGetCurrentSurface");
        return eglGetCurrentSurface;
    }
    else

        if (strcmp(s, "eglGetDisplay") == 0)
    {
        fprintf(stderr, "found sym eglGetDisplay");
        return eglGetDisplay;
    }
    else

        if (strcmp(s, "eglGetError") == 0)
    {
        fprintf(stderr, "found sym eglGetError");
        return eglGetError;
    }
    else

        if (strcmp(s, "eglGetPlatformDisplay") == 0)
    {
        fprintf(stderr, "found sym eglGetPlatformDisplay");
        return eglGetPlatformDisplay;
    }
    else

        if (strcmp(s, "eglGetProcAddress") == 0)
    {
        fprintf(stderr, "found sym eglGetProcAddress");
        return eglGetProcAddress;
    }
    else

        if (strcmp(s, "eglGetSyncAttrib") == 0)
    {
        fprintf(stderr, "found sym eglGetSyncAttrib");
        return eglGetSyncAttrib;
    }
    else

        if (strcmp(s, "eglInitialize") == 0)
    {
        fprintf(stderr, "found sym eglInitialize");
        return eglInitialize;
    }
    else

        if (strcmp(s, "eglMakeCurrent") == 0)
    {
        fprintf(stderr, "found sym eglMakeCurrent");
        return eglMakeCurrent;
    }
    else

        if (strcmp(s, "eglQueryAPI") == 0)
    {
        fprintf(stderr, "found sym eglQueryAPI");
        return eglQueryAPI;
    }
    else

        if (strcmp(s, "eglQueryContext") == 0)
    {
        fprintf(stderr, "found sym eglQueryContext");
        return eglQueryContext;
    }
    else

        if (strcmp(s, "eglQueryString") == 0)
    {
        fprintf(stderr, "found sym eglQueryString");
        return eglQueryString;
    }
    else

        if (strcmp(s, "eglQuerySurface") == 0)
    {
        fprintf(stderr, "found sym eglQuerySurface");
        return eglQuerySurface;
    }
    else

        if (strcmp(s, "eglReleaseTexImage") == 0)
    {
        fprintf(stderr, "found sym eglReleaseTexImage");
        return eglReleaseTexImage;
    }
    else

        if (strcmp(s, "eglReleaseThread") == 0)
    {
        fprintf(stderr, "found sym eglReleaseThread");
        return eglReleaseThread;
    }
    else

        if (strcmp(s, "eglSurfaceAttrib") == 0)
    {
        fprintf(stderr, "found sym eglSurfaceAttrib");
        return eglSurfaceAttrib;
    }
    else

        if (strcmp(s, "eglSwapBuffers") == 0)
    {
        fprintf(stderr, "found sym eglSwapBuffers");
        return eglSwapBuffers;
    }
    else

        if (strcmp(s, "eglSwapInterval") == 0)
    {
        fprintf(stderr, "found sym eglSwapInterval");
        return eglSwapInterval;
    }
    else

        if (strcmp(s, "eglTerminate") == 0)
    {
        fprintf(stderr, "found sym eglTerminate");
        return eglTerminate;
    }
    else

        if (strcmp(s, "eglWaitClient") == 0)
    {
        fprintf(stderr, "found sym eglWaitClient");
        return eglWaitClient;
    }
    else

        if (strcmp(s, "eglWaitGL") == 0)
    {
        fprintf(stderr, "found sym eglWaitGL");
        return eglWaitGL;
    }
    else

        if (strcmp(s, "eglWaitNative") == 0)
    {
        fprintf(stderr, "found sym eglWaitNative");
        return eglWaitNative;
    }
    else

        if (strcmp(s, "eglWaitSync") == 0)
    {
        fprintf(stderr, "found sym eglWaitSync");
        return eglWaitSync;
    }

    // -------------- END GEN -------------------------------
    else if (strcmp(s, "eglCreatePlatformPixmapSurfaceEXT") == 0){
        return eglCreatePlatformPixmapSurfaceEXT;
    }
    else if (strcmp(s, "eglCreatePlatformWindowSurfaceEXT") == 0){
        return eglCreatePlatformWindowSurfaceEXT;
    }else if (strcmp(s, "eglGetPlatformDisplayEXT") == 0){
        return eglGetPlatformDisplayEXT;
    }else if (strcmp(s, "eglSwapBuffersWithDamageKHR") == 0){
        return eglSwapBuffersWithDamageKHR;
    }

    fprintf(stderr, "ERROR, symbol \"%s\" could not be found, returning dlsym\n", s);

    return dlsym(p, s);
}

void *dlopen_new(const char *file, int mode)
{
    fprintf(stderr, "calling dlopen (stub) with file=\"%s\"\n", file);

    return NULL;
}

char *dlerror_new()
{
    fprintf(stderr, "dlerror_new called\n");
    return NULL;
}
