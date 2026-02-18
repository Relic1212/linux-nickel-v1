with open("git-sources.txt") as f:
    lines = [ l.strip() for l in f.readlines()]
uris = ""
for line in lines:
    url = line.split("?")[0][4:]
    if ".git" in url:
        i = url.find(".git")
        url = url[:i]
    commit = line.split("#")[1]
    print(url,commit)
    uri = f"{url}/archive/{commit}.tar.gz"
    uris += uri + "\n"

with open("uris.txt", "w") as f:
    f.write(uris)