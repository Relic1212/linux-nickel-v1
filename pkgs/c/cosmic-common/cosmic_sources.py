import hashlib
# import requests
import urllib.request

PKG_NAMES = [
    "cosmic-applets",
    "cosmic-applibrary",
    "cosmic-bg",
    "cosmic-comp",
    "cosmic-edit",
    "cosmic-files",
    "cosmic-greeter",
    "cosmic-icons",
    "cosmic-idle",
    "cosmic-initial-setup",
    "cosmic-launcher",
    "cosmic-notifications",
    "cosmic-osd",
    "cosmic-panel",
    "cosmic-randr",
    "cosmic-screenshot",
    "cosmic-session",
    "cosmic-settings-daemon",
    "cosmic-settings",
    "cosmic-store",
    "cosmic-term",
    "cosmic-wallpapers",
    "cosmic-workspaces-epoch",
    "xdg-desktop-portal-cosmic",
    "cosmic-player",
    "cosmic-player",
]

RELEASE_TAG = "epoch-1.1.0"

def fetch(url):

    headers = {
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'accept-language': 'en,sv;q=0.9,en-US;q=0.8',
        'priority': 'u=0, i',
        'referer': 'https://download.kde.org/',
        'sec-ch-ua': '"Not=A?Brand";v="24", "Chromium";v="140"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
        'sec-fetch-dest': 'document',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-site': 'cross-site',
        'sec-fetch-user': '?1',
        'upgrade-insecure-requests': '1',
        'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',
    }

    # response = requests.get(url, headers=headers,timeout=120)
    request = urllib.request.Request(url=url, headers=headers)
    response = urllib.request.urlopen(request)

    return response


with open("src.txt") as f:
    urls = [l.strip() for l in f.readlines()]


with open("_cosmic_sources.ncl", "a") as f:
    f.write("\n{" + "\n")
for pkg_name in PKG_NAMES:
    url = f"https://github.com/pop-os/{pkg_name}/archive/refs/tags/{RELEASE_TAG}.tar.gz"
    try:
        print(f"# fetching url: {url}")
        r = fetch(url)
        print("# status:", r.status)
        c = r.read()
        h = hashlib.sha256(c).hexdigest()
        # print("#", r.status_code)
        # s = "\"{pkg_name}\" = {" + f"\"{url}\" = \"" + h + "\"," + "},"
        s = '"%s" = { uri = "%s",\nsha256sum = "%s", \n},\n' % ( pkg_name, url, h )

        print(s)
        with open("_cosmic_sources.ncl", "a") as f:
            f.write(s + "\n")
    except FileExistsError:
        pass


with open("_cosmic_sources.ncl", "a") as f:
    f.write("\n}" + "\n")