
import urllib.request
import hashlib
import json
names = [
    "qtlocation", "qtmultimedia", "qtpositioning", "qtsensors", "qtspeech", "qtsvg", "qttools", 
] + [
"qt5compat", "qtbase", "qtdeclarative", "qtquick3d", "qtshadertools", "qtwayland", 
]


version = "6.10.1"
d = {}
for name in names:
    url =  f"https://download.qt.io/archive/qt/6.10/{version}/submodules/{name}-everywhere-src-{version}.tar.xz"
    r = urllib.request.urlopen(url)
    print(r.status==200)
    data = r.read()

    h = hashlib.sha256(data).hexdigest()
    d[name]= {
            "uri":url,
            "sha256sum":h,

        }
    

    # break

with open("_qtsources.json","w") as f:
    json.dump(d,f)