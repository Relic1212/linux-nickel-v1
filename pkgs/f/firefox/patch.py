def replace(p, old, new):
    with open(p) as f:
        s = f.read()
    s = s.replace(old,
    new
    )
    with open(p, "w") as f:
        f.write(s)
replace("build/moz.configure/bindgen.configure",
'libclang_choices.append("libclang.so.*")',
'libclang_choices.append("libclang.a")')
replace("build/moz.configure/bindgen.configure",
'''def min_libclang_version(libclang):
    try:''',
'''def min_libclang_version(libclang):
    return True
    try:''')
# replace("python/mozbuild/mozbuild/frontend/gyp_reader.py",
#         'context["LOCAL_INCLUDES"] += [include]',
#         'if include: context["LOCAL_INCLUDES"] += [include]')
replace("python/mozbuild/mozbuild/frontend/gyp_reader.py",
        '                context["LOCAL_INCLUDES"] += [include]',
        '                # print(f"include={include}")\n                if not include in ("", "%"): context["LOCAL_INCLUDES"] += [include]')
replace("toolkit/library/moz.build",
        '''inputs=["!build/%s.list" % libxul_list]''','inputs=["toolkit_lib.list"]')
# replace("toolkit/library/build/moz.build",
#         '''inputs=["!/dist/bin/%s" % full_libname]''','inputs=["lib.so"]')
replace("toolkit/library/build/moz.build",
'''    GeneratedFile(
        "dependentlibs.list",
        "dependentlibs.list.gtest",
        script="dependentlibs.py",
        entry_point="gen_list",
        inputs=["!/dist/bin/%s" % full_libname],
    )
    FINAL_TARGET_FILES += ["!dependentlibs.list", "!dependentlibs.list.gtest"]
''','')
# replace("browser/moz.build",'''CONFIGURE_SUBST_FILES += ["installer/Makefile"]
#     DIRS += ["installer/windows"]
# ''','')
# replace("browser/moz.build",'''with Files("installer/**"):
#     BUG_COMPONENT = ("Firefox", "Installer")
# ''','')
# replace("browser/moz.build",'CONFIGURE_SUBST_FILES += ["installer/Makefile"]','')