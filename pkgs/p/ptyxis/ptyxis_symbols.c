#include "dl_factory.h"
extern void* gtk_check_button_get_type;

extern void* gtk_custom_filter_get_type;

extern void* gtk_entry_get_type;

extern void* gtk_filter_list_model_get_type;

extern void* gtk_list_view_get_type;

extern void* gtk_menu_button_get_type;

extern void* gtk_no_selection_get_type;

extern void* gtk_overlay_get_type;

extern void* gtk_picture_get_type;

extern void* gtk_scrolled_window_get_type;

extern void* gtk_search_bar_get_type;

extern void* gtk_search_entry_get_type;

extern void* gtk_separator_get_type;

extern void* gtk_signal_list_item_factory_get_type;

extern void* gtk_sort_list_model_get_type;

extern void* gtk_stack_get_type;

extern void* gtk_stack_page_get_type;

extern void* gtk_string_sorter_get_type;

extern void* gtk_toggle_button_get_type;

// https://github.com/stal-ix/ix/blob/c13a771e9f68146b7e66722c0d8d16f0c076462f/pkgs/die/c/registar.sh
extern void adw_stylesheet_get_resource(void);
extern void adw_get_resource(void);
__attribute__((constructor)) void register_ptyxis_internal()
{
	adw_stylesheet_get_resource();
	adw_get_resource();

	register_lib("ptyxis_internal", 19);

	register_symbol("gtk_check_button_get_type", &gtk_check_button_get_type);
	register_symbol("gtk_custom_filter_get_type", &gtk_custom_filter_get_type);
	register_symbol("gtk_entry_get_type", &gtk_entry_get_type);
	register_symbol("gtk_filter_list_model_get_type", &gtk_filter_list_model_get_type);
	register_symbol("gtk_list_view_get_type", &gtk_list_view_get_type);
	register_symbol("gtk_menu_button_get_type", &gtk_menu_button_get_type);
	register_symbol("gtk_no_selection_get_type", &gtk_no_selection_get_type);
	register_symbol("gtk_overlay_get_type", &gtk_overlay_get_type);
	register_symbol("gtk_picture_get_type", &gtk_picture_get_type);
	register_symbol("gtk_scrolled_window_get_type", &gtk_scrolled_window_get_type);
	register_symbol("gtk_search_bar_get_type", &gtk_search_bar_get_type);
	register_symbol("gtk_search_entry_get_type", &gtk_search_entry_get_type);
	register_symbol("gtk_separator_get_type", &gtk_separator_get_type);
	register_symbol("gtk_signal_list_item_factory_get_type", &gtk_signal_list_item_factory_get_type);
	register_symbol("gtk_sort_list_model_get_type", &gtk_sort_list_model_get_type);
	register_symbol("gtk_stack_get_type", &gtk_stack_get_type);
	register_symbol("gtk_stack_page_get_type", &gtk_stack_page_get_type);
	register_symbol("gtk_string_sorter_get_type", &gtk_string_sorter_get_type);
	register_symbol("gtk_toggle_button_get_type", &gtk_toggle_button_get_type);

};



extern void* eglBindAPI;

extern void* eglBindTexImage;

extern void* eglChooseConfig;

extern void* eglClientWaitSync;

extern void* eglCopyBuffers;

extern void* eglCreateContext;

extern void* eglCreateImage;

extern void* eglCreatePbufferFromClientBuffer;

extern void* eglCreatePbufferSurface;

extern void* eglCreatePixmapSurface;

extern void* eglCreatePlatformPixmapSurface;

extern void* eglCreatePlatformWindowSurface;

extern void* eglCreateSync;

extern void* eglCreateWindowSurface;

extern void* eglDestroyContext;

extern void* eglDestroyImage;

extern void* eglDestroySurface;

extern void* eglDestroySync;

extern void* eglGetConfigAttrib;

extern void* eglGetConfigs;

extern void* eglGetCurrentContext;

extern void* eglGetCurrentDisplay;

extern void* eglGetCurrentSurface;

extern void* eglGetDisplay;

extern void* eglGetError;

extern void* eglGetPlatformDisplay;

extern void* eglGetProcAddress;

extern void* eglGetSyncAttrib;

extern void* eglInitialize;

extern void* eglMakeCurrent;

extern void* eglQueryAPI;

extern void* eglQueryContext;

extern void* eglQueryString;

extern void* eglQuerySurface;

extern void* eglReleaseTexImage;

extern void* eglReleaseThread;

extern void* eglSurfaceAttrib;

extern void* eglSwapBuffers;

extern void* eglSwapInterval;

extern void* eglTerminate;

extern void* eglWaitClient;

extern void* eglWaitGL;

extern void* eglWaitNative;

extern void* eglWaitSync;

extern void* eglPrintConfigDebug;




__attribute__((constructor)) void register_libEGL_so_1(){
	register_lib("libEGL.so.1", 45);

	register_symbol("eglBindAPI", &eglBindAPI);
	register_symbol("eglBindTexImage", &eglBindTexImage);
	register_symbol("eglChooseConfig", &eglChooseConfig);
	register_symbol("eglClientWaitSync", &eglClientWaitSync);
	register_symbol("eglCopyBuffers", &eglCopyBuffers);
	register_symbol("eglCreateContext", &eglCreateContext);
	register_symbol("eglCreateImage", &eglCreateImage);
	register_symbol("eglCreatePbufferFromClientBuffer", &eglCreatePbufferFromClientBuffer);
	register_symbol("eglCreatePbufferSurface", &eglCreatePbufferSurface);
	register_symbol("eglCreatePixmapSurface", &eglCreatePixmapSurface);
	register_symbol("eglCreatePlatformPixmapSurface", &eglCreatePlatformPixmapSurface);
	register_symbol("eglCreatePlatformWindowSurface", &eglCreatePlatformWindowSurface);
	register_symbol("eglCreateSync", &eglCreateSync);
	register_symbol("eglCreateWindowSurface", &eglCreateWindowSurface);
	register_symbol("eglDestroyContext", &eglDestroyContext);
	register_symbol("eglDestroyImage", &eglDestroyImage);
	register_symbol("eglDestroySurface", &eglDestroySurface);
	register_symbol("eglDestroySync", &eglDestroySync);
	register_symbol("eglGetConfigAttrib", &eglGetConfigAttrib);
	register_symbol("eglGetConfigs", &eglGetConfigs);
	register_symbol("eglGetCurrentContext", &eglGetCurrentContext);
	register_symbol("eglGetCurrentDisplay", &eglGetCurrentDisplay);
	register_symbol("eglGetCurrentSurface", &eglGetCurrentSurface);
	register_symbol("eglGetDisplay", &eglGetDisplay);
	register_symbol("eglGetError", &eglGetError);
	register_symbol("eglGetPlatformDisplay", &eglGetPlatformDisplay);
	register_symbol("eglGetProcAddress", &eglGetProcAddress);
	register_symbol("eglGetSyncAttrib", &eglGetSyncAttrib);
	register_symbol("eglInitialize", &eglInitialize);
	register_symbol("eglMakeCurrent", &eglMakeCurrent);
	register_symbol("eglQueryAPI", &eglQueryAPI);
	register_symbol("eglQueryContext", &eglQueryContext);
	register_symbol("eglQueryString", &eglQueryString);
	register_symbol("eglQuerySurface", &eglQuerySurface);
	register_symbol("eglReleaseTexImage", &eglReleaseTexImage);
	register_symbol("eglReleaseThread", &eglReleaseThread);
	register_symbol("eglSurfaceAttrib", &eglSurfaceAttrib);
	register_symbol("eglSwapBuffers", &eglSwapBuffers);
	register_symbol("eglSwapInterval", &eglSwapInterval);
	register_symbol("eglTerminate", &eglTerminate);
	register_symbol("eglWaitClient", &eglWaitClient);
	register_symbol("eglWaitGL", &eglWaitGL);
	register_symbol("eglWaitNative", &eglWaitNative);
	register_symbol("eglWaitSync", &eglWaitSync);
	register_symbol("eglPrintConfigDebug", &eglPrintConfigDebug);

};


extern void* glActiveShaderProgram;

extern void* glActiveTexture;

extern void* glAttachShader;

extern void* glBeginQuery;

extern void* glBeginTransformFeedback;

extern void* glBindAttribLocation;

extern void* glBindBuffer;

extern void* glBindBufferBase;

extern void* glBindBufferRange;

extern void* glBindFramebuffer;

extern void* glBindImageTexture;

extern void* glBindProgramPipeline;

extern void* glBindRenderbuffer;

extern void* glBindSampler;

extern void* glBindTexture;

extern void* glBindTransformFeedback;

extern void* glBindVertexArray;

extern void* glBindVertexBuffer;

extern void* glBlendBarrier;

extern void* glBlendColor;

extern void* glBlendEquation;

extern void* glBlendEquationi;

extern void* glBlendEquationSeparate;

extern void* glBlendEquationSeparatei;

extern void* glBlendFunc;

extern void* glBlendFunci;

extern void* glBlendFuncSeparate;

extern void* glBlendFuncSeparatei;

extern void* glBlitFramebuffer;

extern void* glBufferData;

extern void* glBufferSubData;

extern void* glCheckFramebufferStatus;

extern void* glClear;

extern void* glClearBufferfi;

extern void* glClearBufferfv;

extern void* glClearBufferiv;

extern void* glClearBufferuiv;

extern void* glClearColor;

extern void* glClearDepthf;

extern void* glClearStencil;

extern void* glClientWaitSync;

extern void* glColorMask;

extern void* glColorMaski;

extern void* glCompileShader;

extern void* glCompressedTexImage2D;

extern void* glCompressedTexImage3D;

extern void* glCompressedTexSubImage2D;

extern void* glCompressedTexSubImage3D;

extern void* glCopyBufferSubData;

extern void* glCopyImageSubData;

extern void* glCopyTexImage2D;

extern void* glCopyTexSubImage2D;

extern void* glCopyTexSubImage3D;

extern void* glCreateProgram;

extern void* glCreateShader;

extern void* glCreateShaderProgramv;

extern void* glCullFace;

extern void* glDebugMessageCallback;

extern void* glDebugMessageControl;

extern void* glDebugMessageInsert;

extern void* glDeleteBuffers;

extern void* glDeleteFramebuffers;

extern void* glDeleteProgram;

extern void* glDeleteProgramPipelines;

extern void* glDeleteQueries;

extern void* glDeleteRenderbuffers;

extern void* glDeleteSamplers;

extern void* glDeleteShader;

extern void* glDeleteSync;

extern void* glDeleteTextures;

extern void* glDeleteTransformFeedbacks;

extern void* glDeleteVertexArrays;

extern void* glDepthFunc;

extern void* glDepthMask;

extern void* glDepthRangef;

extern void* glDetachShader;

extern void* glDisable;

extern void* glDisablei;

extern void* glDisableVertexAttribArray;

extern void* glDispatchCompute;

extern void* glDispatchComputeIndirect;

extern void* glDrawArrays;

extern void* glDrawArraysIndirect;

extern void* glDrawArraysInstanced;

extern void* glDrawBuffers;

extern void* glDrawElements;

extern void* glDrawElementsBaseVertex;

extern void* glDrawElementsIndirect;

extern void* glDrawElementsInstanced;

extern void* glDrawElementsInstancedBaseVertex;

extern void* glDrawRangeElements;

extern void* glDrawRangeElementsBaseVertex;

extern void* glEnable;

extern void* glEnablei;

extern void* glEnableVertexAttribArray;

extern void* glEndQuery;

extern void* glEndTransformFeedback;

extern void* glFenceSync;

extern void* glFinish;

extern void* glFlush;

extern void* glFlushMappedBufferRange;

extern void* glFramebufferParameteri;

extern void* glFramebufferRenderbuffer;

extern void* glFramebufferTexture;

extern void* glFramebufferTexture2D;

extern void* glFramebufferTextureLayer;

extern void* glFrontFace;

extern void* glGenBuffers;

extern void* glGenerateMipmap;

extern void* glGenFramebuffers;

extern void* glGenProgramPipelines;

extern void* glGenQueries;

extern void* glGenRenderbuffers;

extern void* glGenSamplers;

extern void* glGenTextures;

extern void* glGenTransformFeedbacks;

extern void* glGenVertexArrays;

extern void* glGetActiveAttrib;

extern void* glGetActiveUniform;

extern void* glGetActiveUniformBlockiv;

extern void* glGetActiveUniformBlockName;

extern void* glGetActiveUniformsiv;

extern void* glGetAttachedShaders;

extern void* glGetAttribLocation;

extern void* glGetBooleani_v;

extern void* glGetBooleanv;

extern void* glGetBufferParameteri64v;

extern void* glGetBufferParameteriv;

extern void* glGetBufferPointerv;

extern void* glGetDebugMessageLog;

extern void* glGetError;

extern void* glGetFloatv;

extern void* glGetFragDataLocation;

extern void* glGetFramebufferAttachmentParameteriv;

extern void* glGetFramebufferParameteriv;

extern void* glGetGraphicsResetStatus;

extern void* glGetInteger64i_v;

extern void* glGetInteger64v;

extern void* glGetIntegeri_v;

extern void* glGetIntegerv;

extern void* glGetInternalformativ;

extern void* glGetMultisamplefv;

extern void* glGetnUniformfv;

extern void* glGetnUniformiv;

extern void* glGetnUniformuiv;

extern void* glGetObjectLabel;

extern void* glGetObjectPtrLabel;

extern void* glGetPointerv;

extern void* glGetProgramBinary;

extern void* glGetProgramInfoLog;

extern void* glGetProgramInterfaceiv;

extern void* glGetProgramiv;

extern void* glGetProgramPipelineInfoLog;

extern void* glGetProgramPipelineiv;

extern void* glGetProgramResourceIndex;

extern void* glGetProgramResourceiv;

extern void* glGetProgramResourceLocation;

extern void* glGetProgramResourceName;

extern void* glGetQueryiv;

extern void* glGetQueryObjectuiv;

extern void* glGetRenderbufferParameteriv;

extern void* glGetSamplerParameterfv;

extern void* glGetSamplerParameterIiv;

extern void* glGetSamplerParameterIuiv;

extern void* glGetSamplerParameteriv;

extern void* glGetShaderInfoLog;

extern void* glGetShaderiv;

extern void* glGetShaderPrecisionFormat;

extern void* glGetShaderSource;

extern void* glGetString;

extern void* glGetStringi;

extern void* glGetSynciv;

extern void* glGetTexLevelParameterfv;

extern void* glGetTexLevelParameteriv;

extern void* glGetTexParameterfv;

extern void* glGetTexParameterIiv;

extern void* glGetTexParameterIuiv;

extern void* glGetTexParameteriv;

extern void* glGetTransformFeedbackVarying;

extern void* glGetUniformBlockIndex;

extern void* glGetUniformfv;

extern void* glGetUniformIndices;

extern void* glGetUniformiv;

extern void* glGetUniformLocation;

extern void* glGetUniformuiv;

extern void* glGetVertexAttribfv;

extern void* glGetVertexAttribIiv;

extern void* glGetVertexAttribIuiv;

extern void* glGetVertexAttribiv;

extern void* glGetVertexAttribPointerv;

extern void* glHint;

extern void* glInvalidateFramebuffer;

extern void* glInvalidateSubFramebuffer;

extern void* glIsBuffer;

extern void* glIsEnabled;

extern void* glIsEnabledi;

extern void* glIsFramebuffer;

extern void* glIsProgram;

extern void* glIsProgramPipeline;

extern void* glIsQuery;

extern void* glIsRenderbuffer;

extern void* glIsSampler;

extern void* glIsShader;

extern void* glIsSync;

extern void* glIsTexture;

extern void* glIsTransformFeedback;

extern void* glIsVertexArray;

extern void* glLineWidth;

extern void* glLinkProgram;

extern void* glMapBufferRange;

extern void* glMemoryBarrier;

extern void* glMemoryBarrierByRegion;

extern void* glMinSampleShading;

extern void* glObjectLabel;

extern void* glObjectPtrLabel;

extern void* glPatchParameteri;

extern void* glPauseTransformFeedback;

extern void* glPixelStorei;

extern void* glPolygonOffset;

extern void* glPopDebugGroup;

extern void* glPrimitiveBoundingBox;

extern void* glProgramBinary;

extern void* glProgramParameteri;

extern void* glProgramUniform1f;

extern void* glProgramUniform1fv;

extern void* glProgramUniform1i;

extern void* glProgramUniform1iv;

extern void* glProgramUniform1ui;

extern void* glProgramUniform1uiv;

extern void* glProgramUniform2f;

extern void* glProgramUniform2fv;

extern void* glProgramUniform2i;

extern void* glProgramUniform2iv;

extern void* glProgramUniform2ui;

extern void* glProgramUniform2uiv;

extern void* glProgramUniform3f;

extern void* glProgramUniform3fv;

extern void* glProgramUniform3i;

extern void* glProgramUniform3iv;

extern void* glProgramUniform3ui;

extern void* glProgramUniform3uiv;

extern void* glProgramUniform4f;

extern void* glProgramUniform4fv;

extern void* glProgramUniform4i;

extern void* glProgramUniform4iv;

extern void* glProgramUniform4ui;

extern void* glProgramUniform4uiv;

extern void* glProgramUniformMatrix2fv;

extern void* glProgramUniformMatrix2x3fv;

extern void* glProgramUniformMatrix2x4fv;

extern void* glProgramUniformMatrix3fv;

extern void* glProgramUniformMatrix3x2fv;

extern void* glProgramUniformMatrix3x4fv;

extern void* glProgramUniformMatrix4fv;

extern void* glProgramUniformMatrix4x2fv;

extern void* glProgramUniformMatrix4x3fv;

extern void* glPushDebugGroup;

extern void* glReadBuffer;

extern void* glReadnPixels;

extern void* glReadPixels;

extern void* glReleaseShaderCompiler;

extern void* glRenderbufferStorage;

extern void* glRenderbufferStorageMultisample;

extern void* glResumeTransformFeedback;

extern void* glSampleCoverage;

extern void* glSampleMaski;

extern void* glSamplerParameterf;

extern void* glSamplerParameterfv;

extern void* glSamplerParameteri;

extern void* glSamplerParameterIiv;

extern void* glSamplerParameterIuiv;

extern void* glSamplerParameteriv;

extern void* glScissor;

extern void* glShaderBinary;

extern void* glShaderSource;

extern void* glStencilFunc;

extern void* glStencilFuncSeparate;

extern void* glStencilMask;

extern void* glStencilMaskSeparate;

extern void* glStencilOp;

extern void* glStencilOpSeparate;

extern void* glTexBuffer;

extern void* glTexBufferRange;

extern void* glTexImage2D;

extern void* glTexImage3D;

extern void* glTexParameterf;

extern void* glTexParameterfv;

extern void* glTexParameteri;

extern void* glTexParameterIiv;

extern void* glTexParameterIuiv;

extern void* glTexParameteriv;

extern void* glTexStorage2D;

extern void* glTexStorage2DMultisample;

extern void* glTexStorage3D;

extern void* glTexStorage3DMultisample;

extern void* glTexSubImage2D;

extern void* glTexSubImage3D;

extern void* glTransformFeedbackVaryings;

extern void* glUniform1f;

extern void* glUniform1fv;

extern void* glUniform1i;

extern void* glUniform1iv;

extern void* glUniform1ui;

extern void* glUniform1uiv;

extern void* glUniform2f;

extern void* glUniform2fv;

extern void* glUniform2i;

extern void* glUniform2iv;

extern void* glUniform2ui;

extern void* glUniform2uiv;

extern void* glUniform3f;

extern void* glUniform3fv;

extern void* glUniform3i;

extern void* glUniform3iv;

extern void* glUniform3ui;

extern void* glUniform3uiv;

extern void* glUniform4f;

extern void* glUniform4fv;

extern void* glUniform4i;

extern void* glUniform4iv;

extern void* glUniform4ui;

extern void* glUniform4uiv;

extern void* glUniformBlockBinding;

extern void* glUniformMatrix2fv;

extern void* glUniformMatrix2x3fv;

extern void* glUniformMatrix2x4fv;

extern void* glUniformMatrix3fv;

extern void* glUniformMatrix3x2fv;

extern void* glUniformMatrix3x4fv;

extern void* glUniformMatrix4fv;

extern void* glUniformMatrix4x2fv;

extern void* glUniformMatrix4x3fv;

extern void* glUnmapBuffer;

extern void* glUseProgram;

extern void* glUseProgramStages;

extern void* glValidateProgram;

extern void* glValidateProgramPipeline;

extern void* glVertexAttrib1f;

extern void* glVertexAttrib1fv;

extern void* glVertexAttrib2f;

extern void* glVertexAttrib2fv;

extern void* glVertexAttrib3f;

extern void* glVertexAttrib3fv;

extern void* glVertexAttrib4f;

extern void* glVertexAttrib4fv;

extern void* glVertexAttribBinding;

extern void* glVertexAttribDivisor;

extern void* glVertexAttribFormat;

extern void* glVertexAttribI4i;

extern void* glVertexAttribI4iv;

extern void* glVertexAttribI4ui;

extern void* glVertexAttribI4uiv;

extern void* glVertexAttribIFormat;

extern void* glVertexAttribIPointer;

extern void* glVertexAttribPointer;

extern void* glVertexBindingDivisor;

extern void* glViewport;

extern void* glWaitSync;




__attribute__((constructor)) void register_libGLESv2_so_2(){
	register_lib("libGLESv2.so.2", 358);

	register_symbol("glActiveShaderProgram", &glActiveShaderProgram);
	register_symbol("glActiveTexture", &glActiveTexture);
	register_symbol("glAttachShader", &glAttachShader);
	register_symbol("glBeginQuery", &glBeginQuery);
	register_symbol("glBeginTransformFeedback", &glBeginTransformFeedback);
	register_symbol("glBindAttribLocation", &glBindAttribLocation);
	register_symbol("glBindBuffer", &glBindBuffer);
	register_symbol("glBindBufferBase", &glBindBufferBase);
	register_symbol("glBindBufferRange", &glBindBufferRange);
	register_symbol("glBindFramebuffer", &glBindFramebuffer);
	register_symbol("glBindImageTexture", &glBindImageTexture);
	register_symbol("glBindProgramPipeline", &glBindProgramPipeline);
	register_symbol("glBindRenderbuffer", &glBindRenderbuffer);
	register_symbol("glBindSampler", &glBindSampler);
	register_symbol("glBindTexture", &glBindTexture);
	register_symbol("glBindTransformFeedback", &glBindTransformFeedback);
	register_symbol("glBindVertexArray", &glBindVertexArray);
	register_symbol("glBindVertexBuffer", &glBindVertexBuffer);
	register_symbol("glBlendBarrier", &glBlendBarrier);
	register_symbol("glBlendColor", &glBlendColor);
	register_symbol("glBlendEquation", &glBlendEquation);
	register_symbol("glBlendEquationi", &glBlendEquationi);
	register_symbol("glBlendEquationSeparate", &glBlendEquationSeparate);
	register_symbol("glBlendEquationSeparatei", &glBlendEquationSeparatei);
	register_symbol("glBlendFunc", &glBlendFunc);
	register_symbol("glBlendFunci", &glBlendFunci);
	register_symbol("glBlendFuncSeparate", &glBlendFuncSeparate);
	register_symbol("glBlendFuncSeparatei", &glBlendFuncSeparatei);
	register_symbol("glBlitFramebuffer", &glBlitFramebuffer);
	register_symbol("glBufferData", &glBufferData);
	register_symbol("glBufferSubData", &glBufferSubData);
	register_symbol("glCheckFramebufferStatus", &glCheckFramebufferStatus);
	register_symbol("glClear", &glClear);
	register_symbol("glClearBufferfi", &glClearBufferfi);
	register_symbol("glClearBufferfv", &glClearBufferfv);
	register_symbol("glClearBufferiv", &glClearBufferiv);
	register_symbol("glClearBufferuiv", &glClearBufferuiv);
	register_symbol("glClearColor", &glClearColor);
	register_symbol("glClearDepthf", &glClearDepthf);
	register_symbol("glClearStencil", &glClearStencil);
	register_symbol("glClientWaitSync", &glClientWaitSync);
	register_symbol("glColorMask", &glColorMask);
	register_symbol("glColorMaski", &glColorMaski);
	register_symbol("glCompileShader", &glCompileShader);
	register_symbol("glCompressedTexImage2D", &glCompressedTexImage2D);
	register_symbol("glCompressedTexImage3D", &glCompressedTexImage3D);
	register_symbol("glCompressedTexSubImage2D", &glCompressedTexSubImage2D);
	register_symbol("glCompressedTexSubImage3D", &glCompressedTexSubImage3D);
	register_symbol("glCopyBufferSubData", &glCopyBufferSubData);
	register_symbol("glCopyImageSubData", &glCopyImageSubData);
	register_symbol("glCopyTexImage2D", &glCopyTexImage2D);
	register_symbol("glCopyTexSubImage2D", &glCopyTexSubImage2D);
	register_symbol("glCopyTexSubImage3D", &glCopyTexSubImage3D);
	register_symbol("glCreateProgram", &glCreateProgram);
	register_symbol("glCreateShader", &glCreateShader);
	register_symbol("glCreateShaderProgramv", &glCreateShaderProgramv);
	register_symbol("glCullFace", &glCullFace);
	register_symbol("glDebugMessageCallback", &glDebugMessageCallback);
	register_symbol("glDebugMessageControl", &glDebugMessageControl);
	register_symbol("glDebugMessageInsert", &glDebugMessageInsert);
	register_symbol("glDeleteBuffers", &glDeleteBuffers);
	register_symbol("glDeleteFramebuffers", &glDeleteFramebuffers);
	register_symbol("glDeleteProgram", &glDeleteProgram);
	register_symbol("glDeleteProgramPipelines", &glDeleteProgramPipelines);
	register_symbol("glDeleteQueries", &glDeleteQueries);
	register_symbol("glDeleteRenderbuffers", &glDeleteRenderbuffers);
	register_symbol("glDeleteSamplers", &glDeleteSamplers);
	register_symbol("glDeleteShader", &glDeleteShader);
	register_symbol("glDeleteSync", &glDeleteSync);
	register_symbol("glDeleteTextures", &glDeleteTextures);
	register_symbol("glDeleteTransformFeedbacks", &glDeleteTransformFeedbacks);
	register_symbol("glDeleteVertexArrays", &glDeleteVertexArrays);
	register_symbol("glDepthFunc", &glDepthFunc);
	register_symbol("glDepthMask", &glDepthMask);
	register_symbol("glDepthRangef", &glDepthRangef);
	register_symbol("glDetachShader", &glDetachShader);
	register_symbol("glDisable", &glDisable);
	register_symbol("glDisablei", &glDisablei);
	register_symbol("glDisableVertexAttribArray", &glDisableVertexAttribArray);
	register_symbol("glDispatchCompute", &glDispatchCompute);
	register_symbol("glDispatchComputeIndirect", &glDispatchComputeIndirect);
	register_symbol("glDrawArrays", &glDrawArrays);
	register_symbol("glDrawArraysIndirect", &glDrawArraysIndirect);
	register_symbol("glDrawArraysInstanced", &glDrawArraysInstanced);
	register_symbol("glDrawBuffers", &glDrawBuffers);
	register_symbol("glDrawElements", &glDrawElements);
	register_symbol("glDrawElementsBaseVertex", &glDrawElementsBaseVertex);
	register_symbol("glDrawElementsIndirect", &glDrawElementsIndirect);
	register_symbol("glDrawElementsInstanced", &glDrawElementsInstanced);
	register_symbol("glDrawElementsInstancedBaseVertex", &glDrawElementsInstancedBaseVertex);
	register_symbol("glDrawRangeElements", &glDrawRangeElements);
	register_symbol("glDrawRangeElementsBaseVertex", &glDrawRangeElementsBaseVertex);
	register_symbol("glEnable", &glEnable);
	register_symbol("glEnablei", &glEnablei);
	register_symbol("glEnableVertexAttribArray", &glEnableVertexAttribArray);
	register_symbol("glEndQuery", &glEndQuery);
	register_symbol("glEndTransformFeedback", &glEndTransformFeedback);
	register_symbol("glFenceSync", &glFenceSync);
	register_symbol("glFinish", &glFinish);
	register_symbol("glFlush", &glFlush);
	register_symbol("glFlushMappedBufferRange", &glFlushMappedBufferRange);
	register_symbol("glFramebufferParameteri", &glFramebufferParameteri);
	register_symbol("glFramebufferRenderbuffer", &glFramebufferRenderbuffer);
	register_symbol("glFramebufferTexture", &glFramebufferTexture);
	register_symbol("glFramebufferTexture2D", &glFramebufferTexture2D);
	register_symbol("glFramebufferTextureLayer", &glFramebufferTextureLayer);
	register_symbol("glFrontFace", &glFrontFace);
	register_symbol("glGenBuffers", &glGenBuffers);
	register_symbol("glGenerateMipmap", &glGenerateMipmap);
	register_symbol("glGenFramebuffers", &glGenFramebuffers);
	register_symbol("glGenProgramPipelines", &glGenProgramPipelines);
	register_symbol("glGenQueries", &glGenQueries);
	register_symbol("glGenRenderbuffers", &glGenRenderbuffers);
	register_symbol("glGenSamplers", &glGenSamplers);
	register_symbol("glGenTextures", &glGenTextures);
	register_symbol("glGenTransformFeedbacks", &glGenTransformFeedbacks);
	register_symbol("glGenVertexArrays", &glGenVertexArrays);
	register_symbol("glGetActiveAttrib", &glGetActiveAttrib);
	register_symbol("glGetActiveUniform", &glGetActiveUniform);
	register_symbol("glGetActiveUniformBlockiv", &glGetActiveUniformBlockiv);
	register_symbol("glGetActiveUniformBlockName", &glGetActiveUniformBlockName);
	register_symbol("glGetActiveUniformsiv", &glGetActiveUniformsiv);
	register_symbol("glGetAttachedShaders", &glGetAttachedShaders);
	register_symbol("glGetAttribLocation", &glGetAttribLocation);
	register_symbol("glGetBooleani_v", &glGetBooleani_v);
	register_symbol("glGetBooleanv", &glGetBooleanv);
	register_symbol("glGetBufferParameteri64v", &glGetBufferParameteri64v);
	register_symbol("glGetBufferParameteriv", &glGetBufferParameteriv);
	register_symbol("glGetBufferPointerv", &glGetBufferPointerv);
	register_symbol("glGetDebugMessageLog", &glGetDebugMessageLog);
	register_symbol("glGetError", &glGetError);
	register_symbol("glGetFloatv", &glGetFloatv);
	register_symbol("glGetFragDataLocation", &glGetFragDataLocation);
	register_symbol("glGetFramebufferAttachmentParameteriv", &glGetFramebufferAttachmentParameteriv);
	register_symbol("glGetFramebufferParameteriv", &glGetFramebufferParameteriv);
	register_symbol("glGetGraphicsResetStatus", &glGetGraphicsResetStatus);
	register_symbol("glGetInteger64i_v", &glGetInteger64i_v);
	register_symbol("glGetInteger64v", &glGetInteger64v);
	register_symbol("glGetIntegeri_v", &glGetIntegeri_v);
	register_symbol("glGetIntegerv", &glGetIntegerv);
	register_symbol("glGetInternalformativ", &glGetInternalformativ);
	register_symbol("glGetMultisamplefv", &glGetMultisamplefv);
	register_symbol("glGetnUniformfv", &glGetnUniformfv);
	register_symbol("glGetnUniformiv", &glGetnUniformiv);
	register_symbol("glGetnUniformuiv", &glGetnUniformuiv);
	register_symbol("glGetObjectLabel", &glGetObjectLabel);
	register_symbol("glGetObjectPtrLabel", &glGetObjectPtrLabel);
	register_symbol("glGetPointerv", &glGetPointerv);
	register_symbol("glGetProgramBinary", &glGetProgramBinary);
	register_symbol("glGetProgramInfoLog", &glGetProgramInfoLog);
	register_symbol("glGetProgramInterfaceiv", &glGetProgramInterfaceiv);
	register_symbol("glGetProgramiv", &glGetProgramiv);
	register_symbol("glGetProgramPipelineInfoLog", &glGetProgramPipelineInfoLog);
	register_symbol("glGetProgramPipelineiv", &glGetProgramPipelineiv);
	register_symbol("glGetProgramResourceIndex", &glGetProgramResourceIndex);
	register_symbol("glGetProgramResourceiv", &glGetProgramResourceiv);
	register_symbol("glGetProgramResourceLocation", &glGetProgramResourceLocation);
	register_symbol("glGetProgramResourceName", &glGetProgramResourceName);
	register_symbol("glGetQueryiv", &glGetQueryiv);
	register_symbol("glGetQueryObjectuiv", &glGetQueryObjectuiv);
	register_symbol("glGetRenderbufferParameteriv", &glGetRenderbufferParameteriv);
	register_symbol("glGetSamplerParameterfv", &glGetSamplerParameterfv);
	register_symbol("glGetSamplerParameterIiv", &glGetSamplerParameterIiv);
	register_symbol("glGetSamplerParameterIuiv", &glGetSamplerParameterIuiv);
	register_symbol("glGetSamplerParameteriv", &glGetSamplerParameteriv);
	register_symbol("glGetShaderInfoLog", &glGetShaderInfoLog);
	register_symbol("glGetShaderiv", &glGetShaderiv);
	register_symbol("glGetShaderPrecisionFormat", &glGetShaderPrecisionFormat);
	register_symbol("glGetShaderSource", &glGetShaderSource);
	register_symbol("glGetString", &glGetString);
	register_symbol("glGetStringi", &glGetStringi);
	register_symbol("glGetSynciv", &glGetSynciv);
	register_symbol("glGetTexLevelParameterfv", &glGetTexLevelParameterfv);
	register_symbol("glGetTexLevelParameteriv", &glGetTexLevelParameteriv);
	register_symbol("glGetTexParameterfv", &glGetTexParameterfv);
	register_symbol("glGetTexParameterIiv", &glGetTexParameterIiv);
	register_symbol("glGetTexParameterIuiv", &glGetTexParameterIuiv);
	register_symbol("glGetTexParameteriv", &glGetTexParameteriv);
	register_symbol("glGetTransformFeedbackVarying", &glGetTransformFeedbackVarying);
	register_symbol("glGetUniformBlockIndex", &glGetUniformBlockIndex);
	register_symbol("glGetUniformfv", &glGetUniformfv);
	register_symbol("glGetUniformIndices", &glGetUniformIndices);
	register_symbol("glGetUniformiv", &glGetUniformiv);
	register_symbol("glGetUniformLocation", &glGetUniformLocation);
	register_symbol("glGetUniformuiv", &glGetUniformuiv);
	register_symbol("glGetVertexAttribfv", &glGetVertexAttribfv);
	register_symbol("glGetVertexAttribIiv", &glGetVertexAttribIiv);
	register_symbol("glGetVertexAttribIuiv", &glGetVertexAttribIuiv);
	register_symbol("glGetVertexAttribiv", &glGetVertexAttribiv);
	register_symbol("glGetVertexAttribPointerv", &glGetVertexAttribPointerv);
	register_symbol("glHint", &glHint);
	register_symbol("glInvalidateFramebuffer", &glInvalidateFramebuffer);
	register_symbol("glInvalidateSubFramebuffer", &glInvalidateSubFramebuffer);
	register_symbol("glIsBuffer", &glIsBuffer);
	register_symbol("glIsEnabled", &glIsEnabled);
	register_symbol("glIsEnabledi", &glIsEnabledi);
	register_symbol("glIsFramebuffer", &glIsFramebuffer);
	register_symbol("glIsProgram", &glIsProgram);
	register_symbol("glIsProgramPipeline", &glIsProgramPipeline);
	register_symbol("glIsQuery", &glIsQuery);
	register_symbol("glIsRenderbuffer", &glIsRenderbuffer);
	register_symbol("glIsSampler", &glIsSampler);
	register_symbol("glIsShader", &glIsShader);
	register_symbol("glIsSync", &glIsSync);
	register_symbol("glIsTexture", &glIsTexture);
	register_symbol("glIsTransformFeedback", &glIsTransformFeedback);
	register_symbol("glIsVertexArray", &glIsVertexArray);
	register_symbol("glLineWidth", &glLineWidth);
	register_symbol("glLinkProgram", &glLinkProgram);
	register_symbol("glMapBufferRange", &glMapBufferRange);
	register_symbol("glMemoryBarrier", &glMemoryBarrier);
	register_symbol("glMemoryBarrierByRegion", &glMemoryBarrierByRegion);
	register_symbol("glMinSampleShading", &glMinSampleShading);
	register_symbol("glObjectLabel", &glObjectLabel);
	register_symbol("glObjectPtrLabel", &glObjectPtrLabel);
	register_symbol("glPatchParameteri", &glPatchParameteri);
	register_symbol("glPauseTransformFeedback", &glPauseTransformFeedback);
	register_symbol("glPixelStorei", &glPixelStorei);
	register_symbol("glPolygonOffset", &glPolygonOffset);
	register_symbol("glPopDebugGroup", &glPopDebugGroup);
	register_symbol("glPrimitiveBoundingBox", &glPrimitiveBoundingBox);
	register_symbol("glProgramBinary", &glProgramBinary);
	register_symbol("glProgramParameteri", &glProgramParameteri);
	register_symbol("glProgramUniform1f", &glProgramUniform1f);
	register_symbol("glProgramUniform1fv", &glProgramUniform1fv);
	register_symbol("glProgramUniform1i", &glProgramUniform1i);
	register_symbol("glProgramUniform1iv", &glProgramUniform1iv);
	register_symbol("glProgramUniform1ui", &glProgramUniform1ui);
	register_symbol("glProgramUniform1uiv", &glProgramUniform1uiv);
	register_symbol("glProgramUniform2f", &glProgramUniform2f);
	register_symbol("glProgramUniform2fv", &glProgramUniform2fv);
	register_symbol("glProgramUniform2i", &glProgramUniform2i);
	register_symbol("glProgramUniform2iv", &glProgramUniform2iv);
	register_symbol("glProgramUniform2ui", &glProgramUniform2ui);
	register_symbol("glProgramUniform2uiv", &glProgramUniform2uiv);
	register_symbol("glProgramUniform3f", &glProgramUniform3f);
	register_symbol("glProgramUniform3fv", &glProgramUniform3fv);
	register_symbol("glProgramUniform3i", &glProgramUniform3i);
	register_symbol("glProgramUniform3iv", &glProgramUniform3iv);
	register_symbol("glProgramUniform3ui", &glProgramUniform3ui);
	register_symbol("glProgramUniform3uiv", &glProgramUniform3uiv);
	register_symbol("glProgramUniform4f", &glProgramUniform4f);
	register_symbol("glProgramUniform4fv", &glProgramUniform4fv);
	register_symbol("glProgramUniform4i", &glProgramUniform4i);
	register_symbol("glProgramUniform4iv", &glProgramUniform4iv);
	register_symbol("glProgramUniform4ui", &glProgramUniform4ui);
	register_symbol("glProgramUniform4uiv", &glProgramUniform4uiv);
	register_symbol("glProgramUniformMatrix2fv", &glProgramUniformMatrix2fv);
	register_symbol("glProgramUniformMatrix2x3fv", &glProgramUniformMatrix2x3fv);
	register_symbol("glProgramUniformMatrix2x4fv", &glProgramUniformMatrix2x4fv);
	register_symbol("glProgramUniformMatrix3fv", &glProgramUniformMatrix3fv);
	register_symbol("glProgramUniformMatrix3x2fv", &glProgramUniformMatrix3x2fv);
	register_symbol("glProgramUniformMatrix3x4fv", &glProgramUniformMatrix3x4fv);
	register_symbol("glProgramUniformMatrix4fv", &glProgramUniformMatrix4fv);
	register_symbol("glProgramUniformMatrix4x2fv", &glProgramUniformMatrix4x2fv);
	register_symbol("glProgramUniformMatrix4x3fv", &glProgramUniformMatrix4x3fv);
	register_symbol("glPushDebugGroup", &glPushDebugGroup);
	register_symbol("glReadBuffer", &glReadBuffer);
	register_symbol("glReadnPixels", &glReadnPixels);
	register_symbol("glReadPixels", &glReadPixels);
	register_symbol("glReleaseShaderCompiler", &glReleaseShaderCompiler);
	register_symbol("glRenderbufferStorage", &glRenderbufferStorage);
	register_symbol("glRenderbufferStorageMultisample", &glRenderbufferStorageMultisample);
	register_symbol("glResumeTransformFeedback", &glResumeTransformFeedback);
	register_symbol("glSampleCoverage", &glSampleCoverage);
	register_symbol("glSampleMaski", &glSampleMaski);
	register_symbol("glSamplerParameterf", &glSamplerParameterf);
	register_symbol("glSamplerParameterfv", &glSamplerParameterfv);
	register_symbol("glSamplerParameteri", &glSamplerParameteri);
	register_symbol("glSamplerParameterIiv", &glSamplerParameterIiv);
	register_symbol("glSamplerParameterIuiv", &glSamplerParameterIuiv);
	register_symbol("glSamplerParameteriv", &glSamplerParameteriv);
	register_symbol("glScissor", &glScissor);
	register_symbol("glShaderBinary", &glShaderBinary);
	register_symbol("glShaderSource", &glShaderSource);
	register_symbol("glStencilFunc", &glStencilFunc);
	register_symbol("glStencilFuncSeparate", &glStencilFuncSeparate);
	register_symbol("glStencilMask", &glStencilMask);
	register_symbol("glStencilMaskSeparate", &glStencilMaskSeparate);
	register_symbol("glStencilOp", &glStencilOp);
	register_symbol("glStencilOpSeparate", &glStencilOpSeparate);
	register_symbol("glTexBuffer", &glTexBuffer);
	register_symbol("glTexBufferRange", &glTexBufferRange);
	register_symbol("glTexImage2D", &glTexImage2D);
	register_symbol("glTexImage3D", &glTexImage3D);
	register_symbol("glTexParameterf", &glTexParameterf);
	register_symbol("glTexParameterfv", &glTexParameterfv);
	register_symbol("glTexParameteri", &glTexParameteri);
	register_symbol("glTexParameterIiv", &glTexParameterIiv);
	register_symbol("glTexParameterIuiv", &glTexParameterIuiv);
	register_symbol("glTexParameteriv", &glTexParameteriv);
	register_symbol("glTexStorage2D", &glTexStorage2D);
	register_symbol("glTexStorage2DMultisample", &glTexStorage2DMultisample);
	register_symbol("glTexStorage3D", &glTexStorage3D);
	register_symbol("glTexStorage3DMultisample", &glTexStorage3DMultisample);
	register_symbol("glTexSubImage2D", &glTexSubImage2D);
	register_symbol("glTexSubImage3D", &glTexSubImage3D);
	register_symbol("glTransformFeedbackVaryings", &glTransformFeedbackVaryings);
	register_symbol("glUniform1f", &glUniform1f);
	register_symbol("glUniform1fv", &glUniform1fv);
	register_symbol("glUniform1i", &glUniform1i);
	register_symbol("glUniform1iv", &glUniform1iv);
	register_symbol("glUniform1ui", &glUniform1ui);
	register_symbol("glUniform1uiv", &glUniform1uiv);
	register_symbol("glUniform2f", &glUniform2f);
	register_symbol("glUniform2fv", &glUniform2fv);
	register_symbol("glUniform2i", &glUniform2i);
	register_symbol("glUniform2iv", &glUniform2iv);
	register_symbol("glUniform2ui", &glUniform2ui);
	register_symbol("glUniform2uiv", &glUniform2uiv);
	register_symbol("glUniform3f", &glUniform3f);
	register_symbol("glUniform3fv", &glUniform3fv);
	register_symbol("glUniform3i", &glUniform3i);
	register_symbol("glUniform3iv", &glUniform3iv);
	register_symbol("glUniform3ui", &glUniform3ui);
	register_symbol("glUniform3uiv", &glUniform3uiv);
	register_symbol("glUniform4f", &glUniform4f);
	register_symbol("glUniform4fv", &glUniform4fv);
	register_symbol("glUniform4i", &glUniform4i);
	register_symbol("glUniform4iv", &glUniform4iv);
	register_symbol("glUniform4ui", &glUniform4ui);
	register_symbol("glUniform4uiv", &glUniform4uiv);
	register_symbol("glUniformBlockBinding", &glUniformBlockBinding);
	register_symbol("glUniformMatrix2fv", &glUniformMatrix2fv);
	register_symbol("glUniformMatrix2x3fv", &glUniformMatrix2x3fv);
	register_symbol("glUniformMatrix2x4fv", &glUniformMatrix2x4fv);
	register_symbol("glUniformMatrix3fv", &glUniformMatrix3fv);
	register_symbol("glUniformMatrix3x2fv", &glUniformMatrix3x2fv);
	register_symbol("glUniformMatrix3x4fv", &glUniformMatrix3x4fv);
	register_symbol("glUniformMatrix4fv", &glUniformMatrix4fv);
	register_symbol("glUniformMatrix4x2fv", &glUniformMatrix4x2fv);
	register_symbol("glUniformMatrix4x3fv", &glUniformMatrix4x3fv);
	register_symbol("glUnmapBuffer", &glUnmapBuffer);
	register_symbol("glUseProgram", &glUseProgram);
	register_symbol("glUseProgramStages", &glUseProgramStages);
	register_symbol("glValidateProgram", &glValidateProgram);
	register_symbol("glValidateProgramPipeline", &glValidateProgramPipeline);
	register_symbol("glVertexAttrib1f", &glVertexAttrib1f);
	register_symbol("glVertexAttrib1fv", &glVertexAttrib1fv);
	register_symbol("glVertexAttrib2f", &glVertexAttrib2f);
	register_symbol("glVertexAttrib2fv", &glVertexAttrib2fv);
	register_symbol("glVertexAttrib3f", &glVertexAttrib3f);
	register_symbol("glVertexAttrib3fv", &glVertexAttrib3fv);
	register_symbol("glVertexAttrib4f", &glVertexAttrib4f);
	register_symbol("glVertexAttrib4fv", &glVertexAttrib4fv);
	register_symbol("glVertexAttribBinding", &glVertexAttribBinding);
	register_symbol("glVertexAttribDivisor", &glVertexAttribDivisor);
	register_symbol("glVertexAttribFormat", &glVertexAttribFormat);
	register_symbol("glVertexAttribI4i", &glVertexAttribI4i);
	register_symbol("glVertexAttribI4iv", &glVertexAttribI4iv);
	register_symbol("glVertexAttribI4ui", &glVertexAttribI4ui);
	register_symbol("glVertexAttribI4uiv", &glVertexAttribI4uiv);
	register_symbol("glVertexAttribIFormat", &glVertexAttribIFormat);
	register_symbol("glVertexAttribIPointer", &glVertexAttribIPointer);
	register_symbol("glVertexAttribPointer", &glVertexAttribPointer);
	register_symbol("glVertexBindingDivisor", &glVertexBindingDivisor);
	register_symbol("glViewport", &glViewport);
	register_symbol("glWaitSync", &glWaitSync);

};


