import sys
p = sys.argv[1]
with open(p) as f:
    t = f.read()

old = "int main(int argc, char** argv) {"
new = "\n".join([
    "extern \"C\" void gjs_init(void);",
    # "extern void GjsInit::GjsInit();",

    old,
    "gjs_init();",
    # "GjsInit::GjsInit();",
])

t = t.replace(old, new)

with open(p, "w") as f:
    f.write(t)
