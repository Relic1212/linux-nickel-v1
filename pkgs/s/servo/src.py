
import tomllib

s = """

[source."git+https://github.com/servo/fontsan"]
git = "https://github.com/servo/fontsan"
replace-with = "vendored-sources"

[source."git+https://github.com/servo/media"]
git = "https://github.com/servo/media"
replace-with = "vendored-sources"

[source."git+https://github.com/servo/mozjs"]
git = "https://github.com/servo/mozjs"
replace-with = "vendored-sources"

[source."git+https://github.com/servo/rust-content-security-policy?branch=servo-csp"]
git = "https://github.com/servo/rust-content-security-policy"
branch = "servo-csp"
replace-with = "vendored-sources"

[source."git+https://github.com/servo/stylo?branch=2025-11-01"]
git = "https://github.com/servo/stylo"
branch = "2025-11-01"
replace-with = "vendored-sources"

[source."git+https://github.com/servo/webrender?branch=0.68"]
git = "https://github.com/servo/webrender"
branch = "0.68"
replace-with = "vendored-sources"

"""

t = tomllib.loads(s)["source"]

print (type(t))
print(t.keys())

for k in t:
    # print(k, type(t[k]), t[k])
    git = t[k]["git"]
    try:
        branch = t[k]["branch"]
    except KeyError:
        branch = None
    print(git, branch)