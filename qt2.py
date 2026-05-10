
import subprocess
import os
import sys


class Library:
    def __init__(self, path):
        self.path = path
        self.symbols = self._find_symbols()
        self._qt_qml()

        self.undefined_symbols = filter(
            lambda s: s["t"].lower() == "u", self.symbols)
        self.defined_symbols = filter(
            lambda s: s["t"].lower() == "t", self.symbols)
        self.exported_symbols = filter(lambda s: s["t"] == "T", self.symbols)
        self.other_symbols = filter(lambda s: not (
            s["t"].lower() in ["u", "t"]), self.symbols)

    def get_defined_symbols(self):
        return [s["name"] for s in self.defined_symbols]

    def get_exported_symbols(self):
        return [s["name"] for s in self.exported_symbols]

    def get_undefined_symbols(self):
        return [s["name"] for s in self.undefined_symbols]

    def get_other_symbols(self):
        return [s["name"] for s in self.other_symbols]
    
    def is_qt_plugin(self):
        return self.qt_plugin
    
    def is_qt_qml_plugin(self):
        return self.is_qt_qml_plugin
    
    def get_imports(self):
        r = []
        for s in self.plugin_syms:
            name = s["name"][21:-1]
            r.append(f"{self.qt_import_str}({name})")
        return r


    def _qt_qml(self):
        self.plugin_syms = []
        plugin = False
        qml = False
        for sym in self.symbols:
            name = sym["name"]
            # t = sym["t"]
            if "qt_static_plugin" in name:
                plugin = True
                self.plugin_syms.append(sym)
            if "QQml" in name:
                qml = True
            elif "qmlRegisterModule" in name:
                qml = True
        self.qt_plugin = plugin 
        self.qt_qml_plugin = qml
        if self.qt_plugin:
            if self.qt_qml_plugin:
                self.qt_import_str="Q_IMPORT_QML_PLUGIN"
            else:
                self.qt_import_str="Q_IMPORT_PLUGIN"
        else:
            self.qt_import_str = None

    def _find_symbols(self):
        try:
            out = subprocess.run(["llvm-nm", self.path],
                                 check=True, capture_output=True)
        except Exception as e:
            # print(out.stderr.decode())
            raise e

        s = out.stdout.decode()
        lines = [l.strip() for l in s.split("\n")]
        syms = []
        for line in lines:
            # print(line)
            linesplit = line.split()
            if line == "":
                continue
            if len(linesplit) == 1:
                continue
            try:
                # address, t, name = line.split()
                name = linesplit[-1]
                t = linesplit[-2]
            except Exception as e:
                print(f"failed with line=\"{line}\"")
                raise e

            syms.append({
                "name": name,
                "t": t,
                "line": line,
            })
        return syms


def find_files(d):
    l = []
    for root, dirs, files in os.walk(d):
        for f in files:
            fp = os.path.join(root, f)
            l.append(fp)
    return l


KNOWN_BAD = ["BuddyEditorPlugin",
             "TabOrderEditorPlugin", "Qt_test_controlsPlugin",

             "QDebugMessageServiceFactory",
             "QLocalClientConnectionFactory",
             "QQmlDebugServerFactory",
             "QQmlDebuggerServiceFactory",
             "QQmlInspectorServiceFactory",
             "QQmlNativeDebugConnectorFactory",
             "QQmlNativeDebugServiceFactory",
             "QQmlPreviewServiceFactory",
             "QQmlProfilerServiceFactory",
             "QQuickProfilerAdapterFactory",
             "QTcpServerConnectionFactory",

             "QWaylandTextureSharingPlugin",

             "QmlLintQdsPlugin",
             "QmlLintQuickPlugin",

             "SignalSlotEditorPlugin",

             "QtQuickShapesDesignHelpersPlugin",

             'QEglFSIntegrationPlugin',
             'QEglFSKmsEglDeviceIntegrationPlugin',
             'QEglFSKmsGbmIntegrationPlugin',
             'QLinuxFbIntegrationPlugin',
             'QMinimalEglIntegrationPlugin',
             'QMinimalIntegrationPlugin',
             'QOffscreenIntegrationPlugin',
             'QVncIntegrationPlugin',
             #  'QWaylandLayerShellIntegrationPlugin',
             #  'CoreBindingsPlugin',
             #  'EffectKitExtensionPlugin',
             #  'KCoreAddonsPlugin',
             #  'KGuiAddonsPlugin',
             #  'KHolidaysDeclarativePlugin',
             #  'KI18nLocaleDataQmlPlugin',
             #  'QmlPlugins'
             ]


def find_libs(d):
    files = find_files(d)
    libs = filter(lambda x: x.endswith(".a"), files)
    return libs


def t2(d):
    libs = find_libs(d)
    clines = []

    for l in libs:
        assert (l.startswith(d))
        lib_subpath = l[len(d):]
        
        library=Library(l)
        if library.is_qt_plugin():
            clines += library.get_imports()

    return clines


if __name__ == "__main__":
    libp = sys.argv[1]
    lines = sorted(t2(libp))
    for i in range(len(lines)-1):
        if lines[i].split()[0] == lines[i+1].split()[0]:
            lines[i] = "// " + lines[i]
    for l in (lines):
        print(l)

    # lib = Library("build/tmp/musl/out/destdir/usr/lib/libc.a")
    # print(lib.get_other_symbols())
