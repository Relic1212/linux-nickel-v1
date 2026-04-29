
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#define DLSYM(sym, prefix) 	\
    if (strcmp(symbol, #sym) == 0) { \
        extern void* prefix##sym; \
		dbg_print("(dlsym) found symbol %s with handle=%p, address=%p\n", symbol, handle, &prefix##sym); \
        return &prefix##sym; \
    }

static char* dbg;
static char dbg_initualilised = 0;

static void dbg_initilialise(){
	dbg = getenv("DL_DEBUG");
	dbg_initualilised = 1;
}
static void dbg_print(const char *s, ...)
{
	if (dbg_initualilised==0){
		dbg_initilialise();
	}

    if (dbg != NULL)
    {
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
    }
}

extern void *stub_dlopen(const char *, int);
extern void *stub_dlsym(void *__restrict, const char *__restrict);
extern int stub_dladdr(const void *handle, Dl_info *info);

const char* main_program_handle = "main_program";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	fprintf(stderr, "(dlopen) WARNING: returning main_program_handle for path %s\n", path);	return &main_program_handle;
}

void* _dlsym(void *__restrict handle, const char *__restrict symbol) {
    if (handle == NULL || handle == &main_program_handle) { 
		DLSYM(PyInit_fast_data_types, )    
		// DLSYM(glfwInit, )    
		// DLSYM(glfwRunMainLoop, )    
        
        DLSYM(glfwInit,);
        DLSYM(glfwRunMainLoop,);
        DLSYM(glfwStopMainLoop,);
        DLSYM(glfwAddTimer,);
        DLSYM(glfwUpdateTimer,);
        DLSYM(glfwRemoveTimer,);
        DLSYM(glfwSetDrawTextFunction,);
        DLSYM(glfwSetCurrentSelectionCallback,);
        DLSYM(glfwSetHasCurrentSelectionCallback,);
        DLSYM(glfwSetIMECursorPositionCallback,);
        DLSYM(glfwIsLayerShellSupported,);
        DLSYM(glfwTerminate,);
        DLSYM(glfwInitHint,);
        DLSYM(glfwGetVersion,);
        DLSYM(glfwGetVersionString,);
        DLSYM(glfwGetError,);
        DLSYM(glfwSetErrorCallback,);
        DLSYM(glfwGetMonitors,);
        DLSYM(glfwGetPrimaryMonitor,);
        DLSYM(glfwGetMonitorPos,);
        DLSYM(glfwGetMonitorWorkarea,);
        DLSYM(glfwGetMonitorPhysicalSize,);
        DLSYM(glfwGetMonitorContentScale,);
        DLSYM(glfwGetMonitorName,);
        DLSYM(glfwGetMonitorDescription,);
        DLSYM(glfwSetMonitorUserPointer,);
        DLSYM(glfwGetMonitorUserPointer,);
        DLSYM(glfwSetMonitorCallback,);
        DLSYM(glfwGetVideoModes,);
        DLSYM(glfwGetVideoMode,);
        DLSYM(glfwSetGamma,);
        DLSYM(glfwGetGammaRamp,);
        DLSYM(glfwSetGammaRamp,);
        DLSYM(glfwDefaultWindowHints,);
        DLSYM(glfwWindowHint,);
        DLSYM(glfwWindowHintString,);
        DLSYM(glfwCreateWindow,);
        DLSYM(glfwToggleFullscreen,);
        DLSYM(glfwIsFullscreen,);
        DLSYM(glfwAreSwapsAllowed,);
        DLSYM(glfwGetLayerShellConfig,);
        DLSYM(glfwSetLayerShellConfig,);
        DLSYM(glfwDestroyWindow,);
        DLSYM(glfwWindowShouldClose,);
        DLSYM(glfwSetWindowShouldClose,);
        DLSYM(glfwSetWindowTitle,);
        DLSYM(glfwSetWindowIcon,);
        DLSYM(glfwGetWindowPos,);
        DLSYM(glfwSetWindowPos,);
        DLSYM(glfwGetWindowSize,);
        DLSYM(glfwSetWindowSizeLimits,);
        DLSYM(glfwSetWindowSizeIncrements,);
        DLSYM(glfwSetWindowAspectRatio,);
        DLSYM(glfwSetWindowSize,);
        DLSYM(glfwGetFramebufferSize,);
        DLSYM(glfwGetWindowFrameSize,);
        DLSYM(glfwGetWindowContentScale,);
        DLSYM(glfwGetDoubleClickInterval,);
        DLSYM(glfwGetWindowOpacity,);
        DLSYM(glfwSetWindowOpacity,);
        DLSYM(glfwIconifyWindow,);
        DLSYM(glfwRestoreWindow,);
        DLSYM(glfwMaximizeWindow,);
        DLSYM(glfwShowWindow,);
        DLSYM(glfwHideWindow,);
        DLSYM(glfwFocusWindow,);
        DLSYM(glfwRequestWindowAttention,);
        DLSYM(glfwWindowBell,);
        DLSYM(glfwGetWindowMonitor,);
        DLSYM(glfwSetWindowMonitor,);
        DLSYM(glfwGetWindowAttrib,);
        DLSYM(glfwSetWindowAttrib,);
        DLSYM(glfwSetWindowBlur,);
        DLSYM(glfwSetWindowUserPointer,);
        DLSYM(glfwGetWindowUserPointer,);
        DLSYM(glfwSetWindowPosCallback,);
        DLSYM(glfwSetWindowSizeCallback,);
        DLSYM(glfwSetWindowCloseCallback,);
        DLSYM(glfwSetApplicationCloseCallback,);
        DLSYM(glfwSetSystemColorThemeChangeCallback,);
        DLSYM(glfwSetClipboardLostCallback,);
        DLSYM(glfwGetCurrentSystemColorTheme,);
        DLSYM(glfwSetWindowRefreshCallback,);
        DLSYM(glfwSetWindowFocusCallback,);
        DLSYM(glfwSetWindowOcclusionCallback,);
        DLSYM(glfwSetWindowIconifyCallback,);
        DLSYM(glfwSetWindowMaximizeCallback,);
        DLSYM(glfwSetFramebufferSizeCallback,);
        DLSYM(glfwSetWindowContentScaleCallback,);
        DLSYM(glfwPostEmptyEvent,);
        DLSYM(glfwGetIgnoreOSKeyboardProcessing,);
        DLSYM(glfwSetIgnoreOSKeyboardProcessing,);
        DLSYM(glfwGrabKeyboard,);
        DLSYM(glfwGetInputMode,);
        DLSYM(glfwSetInputMode,);
        DLSYM(glfwRawMouseMotionSupported,);
        DLSYM(glfwGetKeyName,);
        DLSYM(glfwGetNativeKeyForKey,);
        DLSYM(glfwGetKey,);
        DLSYM(glfwGetMouseButton,);
        DLSYM(glfwGetCursorPos,);
        DLSYM(glfwSetCursorPos,);
        DLSYM(glfwCreateCursor,);
        DLSYM(glfwCreateStandardCursor,);
        DLSYM(glfwDestroyCursor,);
        DLSYM(glfwSetCursor,);
        DLSYM(glfwSetKeyboardCallback,);
        DLSYM(glfwUpdateIMEState,);
        DLSYM(glfwSetMouseButtonCallback,);
        DLSYM(glfwSetCursorPosCallback,);
        DLSYM(glfwSetCursorEnterCallback,);
        DLSYM(glfwSetScrollCallback,);
        DLSYM(glfwSetLiveResizeCallback,);
        DLSYM(glfwSetDropEventCallback,);
        DLSYM(glfwRequestDropData,);
        DLSYM(glfwEndDrop,);
        DLSYM(glfwSetDragSourceCallback,);
        DLSYM(glfwStartDrag,);
        DLSYM(glfwJoystickPresent,);
        DLSYM(glfwGetJoystickAxes,);
        DLSYM(glfwGetJoystickButtons,);
        DLSYM(glfwGetJoystickHats,);
        DLSYM(glfwGetJoystickName,);
        DLSYM(glfwGetJoystickGUID,);
        DLSYM(glfwSetJoystickUserPointer,);
        DLSYM(glfwGetJoystickUserPointer,);
        DLSYM(glfwJoystickIsGamepad,);
        DLSYM(glfwSetJoystickCallback,);
        DLSYM(glfwUpdateGamepadMappings,);
        DLSYM(glfwGetGamepadName,);
        DLSYM(glfwGetGamepadState,);
        DLSYM(glfwSetClipboardDataTypes,);
        DLSYM(glfwGetClipboard,);
        DLSYM(glfwGetTime,);
        DLSYM(glfwMakeContextCurrent,);
        DLSYM(glfwGetCurrentContext,);
        DLSYM(glfwSwapBuffers,);
        DLSYM(glfwSwapInterval,);
        DLSYM(glfwExtensionSupported,);
        DLSYM(glfwGetProcAddress,);
        DLSYM(glfwVulkanSupported,);
        DLSYM(glfwGetRequiredInstanceExtensions,);
        DLSYM(glfwGetCocoaWindow,);
        DLSYM(glfwGetNSGLContext,);
        DLSYM(glfwGetCocoaMonitor,);
        DLSYM(glfwSetCocoaTextInputFilter,);
        DLSYM(glfwSetCocoaURLOpenCallback,);
        DLSYM(glfwSetCocoaToggleFullscreenIntercept,);
        DLSYM(glfwSetApplicationShouldHandleReopen,);
        DLSYM(glfwSetApplicationWillFinishLaunching,);
        DLSYM(glfwGetCocoaKeyEquivalent,);
        DLSYM(glfwCocoaRequestRenderFrame,);
        DLSYM(glfwCocoaRecreateGLDrawable,);
        DLSYM(glfwCocoaSetWindowResizeCallback,);
        DLSYM(glfwGetX11Display,);
        DLSYM(glfwGetX11Window,);
        DLSYM(glfwSetPrimarySelectionString,);
        DLSYM(glfwCocoaCycleThroughOSWindows,);
        DLSYM(glfwCocoaSetWindowChrome,);
        DLSYM(glfwCocoaRegisterMIMETypes,);
        DLSYM(glfwGetPrimarySelectionString,);
        DLSYM(glfwGetNativeKeyForName,);
        DLSYM(glfwRequestWaylandFrameEvent,);
        DLSYM(glfwWaylandActivateWindow,);
        DLSYM(glfwWaylandMissingCapabilities,);
        DLSYM(glfwWaylandRunWithActivationToken,);
        DLSYM(glfwWaylandSetTitlebarColor,);
        DLSYM(glfwWaylandSetTitlebarHidden,);
        DLSYM(glfwWaylandRedrawCSDWindowTitle,);
        DLSYM(glfwWaylandIsWindowFullyCreated,);
        DLSYM(glfwWaylandBeep,);
        DLSYM(glfwWaylandCompositorPID,);
        DLSYM(glfwConfigureMomentumScroller,);
        DLSYM(glfwDBusUserNotify,);
        DLSYM(glfwDBusSetUserNotificationHandler,);
        DLSYM(glfwSetX11LaunchCommand,);

        DLSYM(wl_cursor_theme_load, );
        DLSYM(wl_cursor_theme_destroy, );
        DLSYM(wl_cursor_theme_get_cursor, );
        DLSYM(wl_cursor_image_get_buffer, );
        DLSYM(wl_egl_window_create, );
        DLSYM(wl_egl_window_destroy, );
        DLSYM(wl_egl_window_resize, );
        DLSYM(FcInit, );
        DLSYM(FcFini, );
        DLSYM(FcCharSetAddChar, );
        DLSYM(FcPatternDestroy, );
        DLSYM(FcObjectSetDestroy, );
        DLSYM(FcPatternAddDouble, );
        DLSYM(FcPatternAddString, );
        DLSYM(FcFontMatch, );
        DLSYM(FcCharSetCreate, );
        DLSYM(FcPatternGetString, );
        DLSYM(FcFontSetDestroy, );
        DLSYM(FcPatternGetInteger, );
        DLSYM(FcPatternAddBool, );
        DLSYM(FcFontList, );
        DLSYM(FcObjectSetBuild, );
        DLSYM(FcCharSetDestroy, );
        DLSYM(FcConfigSubstitute, );
        DLSYM(FcDefaultSubstitute, );
        DLSYM(FcPatternAddInteger, );
        DLSYM(FcPatternCreate, );
        DLSYM(FcPatternGetBool, );
        DLSYM(FcPatternAddCharSet, );
        DLSYM(FcConfigAppFontAddFile, );

        DLSYM(eglBindAPI, );
        DLSYM(eglChooseConfig, );
        DLSYM(eglCreateContext, );
        DLSYM(eglCreateWindowSurface, );
        DLSYM(eglDestroyContext, );
        DLSYM(eglDestroySurface, );
        DLSYM(eglGetConfigAttrib, );
        DLSYM(eglGetConfigs, );
        DLSYM(eglGetDisplay, );
        DLSYM(eglGetError, );
        DLSYM(eglGetProcAddress, );
        DLSYM(eglInitialize, );
        DLSYM(eglMakeCurrent, );
        DLSYM(eglQueryString, );
        DLSYM(eglQuerySurface, );
        DLSYM(eglSwapBuffers, );
        DLSYM(eglSwapInterval, );
        DLSYM(eglTerminate, );


    }
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
    void* imp = _dlsym(handle, symbol);
    if (imp == NULL){
    	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
    }
    dbg_print("(dlsym) symbol address imp=\"%p\"\n", imp);
    return imp;
}

int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

