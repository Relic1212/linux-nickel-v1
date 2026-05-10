class Plugin:
    def __init__(self, name, lib =""):
        self.name = name 
        self.lib = lib 
        self.source = f"Q_IMPORT_PLUGIN({self.name})\t\t// {self.lib}"
    def __str__(self):
        return self.source
          

with open ("nm.txt") as f:
    lines = f.readlines()

qt_suffix ="Pluginv"
qt_qml_suffix="Modulev"

prefix="qt_static_plugin_"

pcount = len("_Z51")
for l in lines:
    l=l.strip()
    symbol = l.split(" ") [-1]
    symbol = symbol[pcount:]
    lib = l.split(" ")[0]
    
    # print(symbol)
    assert(symbol.startswith(prefix))
    # if symbol.endswith(qt_suffix):

    #     plugin = symbol[len(prefix):-len(qt_suffix) ]
    #     # print(plugin)
    #     cxx_source = f"Q_IMPORT_PLUGIN({plugin})\t\t// {lib}"
    # elif symbol.endswith(qt_qml_suffix):
    #     plugin = symbol[len(prefix):-len(qt_qml_suffix) ]
    #     cxx_source = f"Q_IMPORT_QML_PLUGIN({plugin})\t\t// {lib}"

    plugin_name = symbol[len(prefix):-1]
    plugin = Plugin(plugin_name,lib)

    print(plugin)
