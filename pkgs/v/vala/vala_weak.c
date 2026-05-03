
#define _GNU_SOURCE
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

__attribute__((weak)) void* register_plugin = NULL;
__attribute__((weak)) void* valadoc_html_doclet_construct = NULL;
__attribute__((weak)) void* valadoc_html_doclet_get_type = NULL;
__attribute__((weak)) void* valadoc_html_doclet_new = NULL;

