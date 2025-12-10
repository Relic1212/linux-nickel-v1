
import subprocess
import os
import sys


class Library:
    def __init__(self, path):
        self.path = path


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


def find_symbols(lib):
    try:
        out = subprocess.run(["llvm-nm", lib], check=True, capture_output=True)
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
        qml = False
        plugin = False
        syms = find_symbols(l)
        plugin_syms = []
        for sym in syms:
            name = sym["name"]
            t = sym["t"]
            if "qt_static_plugin" in name:
                plugin = True
                plugin_syms.append(sym)
            if "QQml" in name:
                qml = True
            elif "qmlRegisterModule" in name:
                qml = True
        if qml:
            imp = "Q_IMPORT_QML_PLUGIN"
        else:
            imp = "Q_IMPORT_PLUGIN"
        for p in plugin_syms:
            name = p["name"]
            t = p["t"]
            plugin_name = name[21:-1]
            if (not plugin_name in KNOWN_BAD) and (t != "U"):

                line = f"{imp}({plugin_name});\t\t// ({t}) {lib_subpath}"
                clines.append(line)

    return clines


if __name__ == "__main__":
    libp = sys.argv[1]
    lines = sorted(t2(libp))
    for i in range(len(lines)-1):
        if lines[i].split()[0] == lines[i+1].split()[0]:
            lines[i] = "// " + lines[i]
    for l in (lines):
        print(l)
