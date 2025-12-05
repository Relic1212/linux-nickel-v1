import hashlib
import urllib.request


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

    request = urllib.request.Request(url=url, headers=headers)
    response = urllib.request.urlopen(request, timeout=10)

    return response


fn = "plasma_urls.txt"
fn = "urls"

if fn == "plasma_urls.txt":
    fn_out = "_plasma_sources.ncl"
else:
    fn_out = "_sources.ncl"
with open(fn, "r") as f:
    urls = [l.strip() for l in f.readlines()]

for url in urls:
    try:
        print(f"# fetching url: {url}")
        r = fetch(url)
        c = r.read()
        h = hashlib.sha256(c).hexdigest()
        assert(r.status==200)
        print("#", r.status)
        s = (
            f"\"{url}\" = \"" + h + "\","
        )
        print(s)
        with open(fn_out, "a") as f:
            f.write(s)
    except Exception as e:
        print("fail:",url)
        raise e
        pass
