import urllib.request
import http.client
import hashlib
with open("src.txt") as f:
    lines = f.readlines()
print("[")
for line in [ l.strip() for l in lines]:
    url = line.split("?")[0].split("#")[0][4:]
    if url.endswith(".git"):
        url=url[:-4]
    c=line.split("#")[1]
    # print(url, c)

    uri = f"{url}/archive/{c}.tar.gz"
    dest = "vendor/" + url.split("/")[-1]
    # sha = "SHA_PLACEHOLDER"
    r = urllib.request.urlopen(uri)
    # print(type(r))
    # print(r.reason, type(r.reason), r.reason == "OK")
    # # http.client.HTTPResponse().
    # break

    if (r.reason != "OK"):
        raise Exception(uri)
    data = r.read()
    sha = hashlib.sha256(data).hexdigest()
    lp = "{"
    rp = "}"
    s = f'''{lp}
    src = {lp}
    uri = "{uri}",
    sha256sum = "{sha}",
    {rp},
    dest = "{dest}",

{rp},

    '''
    
    print(s)
    # break

print("]")