
#include <Python.h>


extern PyObject *PyInit__dbus_bindings(void);
extern PyObject *PyInit__dbus_glib_bindings(void);
extern PyObject *PyInit__gi(void);
extern PyObject *PyInit__cairo(void);

__attribute__((constructor)) void python_dbus_module_init(){
    // fprintf(stderr, "initializing dbus modules\n");

    if (PyImport_AppendInittab("_dbus_bindings", PyInit__dbus_bindings) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__dbus_bindings\n");   
    }
    if (PyImport_AppendInittab("_dbus_glib_bindings", PyInit__dbus_glib_bindings) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__dbus_glib_bindings\n");   
    }
    if (PyImport_AppendInittab("gi._gi", PyInit__gi) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__gi\n");   
    }
    if (PyImport_AppendInittab("cairo._cairo", PyInit__cairo) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__cairo\n");   
    }

}
