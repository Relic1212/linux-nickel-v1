

import os
fps = []
for p1, p2, p3 in os.walk("pkgs"):
    # print(p1,p2,p3)
    for p4 in p3:
        fp = os.path.join(p1, p4)
        if fp.endswith(".ncl"):
            fps.append(fp)


def xpkg(s):
    sr = ""
    for elem in s:
        c = (elem)
        if not (c.isalpha() or c.isnumeric() or c == "_"):
            break
        sr += c
    return sr


def reformat(content, sep=None):
    if sep is None:
        sep1 = "biDrvs = ["
        sep2 = "baseBuildinputPackages = ["

        if sep1 in content:
            return reformat(content, sep1)
        elif sep2 in content:
            return reformat(content, sep2)
        else:
            return content

    if not sep in content:
        return content
    ss1 = content.split(sep, maxsplit=1)
    s1 = ss1[1]
    ss2 = s1.split("]", maxsplit=1)
    start = ss1[0] + sep
    end = "]" + ss2[1]
    middle = ss2[0]
    new_middle = ""

    pkgs_inc = ""
    for i, x in enumerate(middle.split(" drvs.")):
        if i == 0:
            new_middle += x
            continue
        pn = xpkg(x)
        pkgs_inc += f"\t{pn},\n"
        # print(pn)
        l = len(pn)
        new_middle += " " + x
    # print(middle)
    # print(new_middle)

    # print(pkgs_inc)
    new_start = start.replace(" drvs,", pkgs_inc, count=1)
    new_end = reformat(end)
    new_content = new_start + new_middle + new_end
    return (new_content)


for fp in fps:
    with open(fp) as f:
        content = f.read()

    new_content = reformat(content)
    print(fp)

    # print(new_content)
    if not fp.startswith("pkgs/"):
        raise Exception(fp)
    with open(fp, "w") as f:
        f.write(new_content)
