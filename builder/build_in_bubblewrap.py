import datetime
import timeit
import subprocess
import json
# import namespace
# import buildscript
import sys
import os
# sys.path.append(os.path.dirname(__file__))


try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher, sysroot_utils

except ModuleNotFoundError:
    import bubblewrap
    import hashes
    import util_functions
    import dirpaths
    import fetcher
    import sysroot_utils

try:
    from builder import buildscript
except:
    import buildscript


try:
    from builder import namespace
except:
    import namespace


def get_src_dir(src_uri, src_uri_sha256sum) -> str:
    return dirpaths.get_basedir() + "/" + src_uri_sha256sum + "-src"


def find_extrafile(name, sha256sum, files_dir="") -> str:
    for root, directory, file in os.walk("pkgs"):
        for f in directory + file:
            p = os.path.join(root, f)
            if not (os.path.exists(p)):
                raise Exception()
            if (f == name) and (p.endswith(files_dir)):
                s = hashes.compute_file_or_dir_sha256sum(p)
                if s == sha256sum:
                    return p
    print("ERROR, could not find", name)
    raise Exception()


def drv_to_workdir(drv: dict) -> str:
    """
    drv must be on the from
    {
        'manifest':<manifest>,
        'hash':<hash>
    }
    """
    workdir0 = "build/" + drv["hash"] + "-workdir"
    workdir = (
        "build/" +
        hashes.str_to_sha256sum(json.dumps(drv["manifest"])) + "-workdir"
    )

    if workdir0 != workdir:
        print("workdir ", workdir)
        print("workdir0", workdir0)
        raise Exception()
    return workdir


def get_full_src_path(h):
    src_dir = dirpaths.get_basedir() + "/" + h + "-src/packed/"
    cont = os.listdir(src_dir)
    if len(cont) != 1:
        raise Exception(f"{src_dir} does not contain exactly one item")
    src_p = src_dir + "/" + cont[0]
    return src_p


def copy_src(h, dest):
    src_dir = dirpaths.get_basedir() + "/" + h + "-src/packed/"
    cont = os.listdir(src_dir)
    if len(cont) != 1:
        raise Exception(f"{src_dir} does not contain exactly one item")
    src_p = src_dir + "/" + cont[0]
    subprocess.run(["cp", "-r", src_p, dest], check=True)


def run_and_get_lines(**kwargs):
    p = subprocess.Popen(**kwargs)
    for l in p.stdout.readline():
        yield l
        # yield {
        #     "type":"stdout",
        #   "line":l }
    # for l in p.stderr.readline():
    #     yield {
    #         "type":"stderr",
    #       "line":l }
    status = p.wait()
    if not status:
        raise subprocess.CalledProcessError(status, cmd=p.args)


def link_workdir(h, name):
    workdir = dirpaths.get_basedir() + "/" + h + "-workdir"

    os.makedirs(dirpaths.get_basedir() + "/tmp", exist_ok=True)
    subprocess.run(
        ["rm", "-f", dirpaths.get_basedir() + "/tmp/" + name], check=True
    )
    subprocess.run(
        [
            "ln",
            "-s",
            os.path.realpath(workdir),
            os.path.realpath(dirpaths.get_basedir()) + "/tmp/" + name,
        ],
        check=True,
    )


class DependencyException(Exception):
    pass


class builder:
    def __init__(self):
        self.failed_builds = []

    def print_failed(self):
        if len(self.failed_builds) > 0:
            print("The following failed to build", self.failed_builds)

    def build(self, h: str, pkg_drvs: dict, pkg_names: dict, pkghash2sysroothash: dict, keep_going: bool = False, prev_failed=None, delete_tmpfs_build_on_success=True, delete_tmpfs_build_on_fail=False) -> None:

        # h=hash
        # drv_s=pkgs[hash]

        drv_s = pkg_drvs[h]
        drv = json.loads(drv_s)
        name = pkg_names[h]

        workdir = os.path.join(dirpaths.get_basedir(), h + "-workdir")
        status_file = os.path.join(workdir, "0.txt")
        if os.path.isfile(status_file):
            link_workdir(h, name)

            return

        sandboxed = drv["buildInChroot"]
        uses_ccache = drv["enableCcache"]
        uses_sccache = True

        # TODO: this should always be set
        if "deterministicFetcher" in drv.keys():
            deterministic_fetcher = True
            output_file = drv["outputFile"]
            output_sha256sum = drv["outputSha256sum"]
        else:
            deterministic_fetcher = False
        # sysroot_drv_hash = drv["sysrootDrvHash"] # the goal
        # sysroot_drv_hash = pkghash2sysroothash[h]

        subprocess.run(["rm", "-rf", workdir], check=True)
        failed = False
        failed_names = []
        # if prev_failed is None:
        #     prev_failed = []
        build_inputs = drv["buildInputDrvs"]
        for bi_drv in build_inputs:
            # if type(bi_drv) is str:
            #    bi_drv_drv_hash = bi_drv
            # else:
            bi_drv_drv_hash = bi_drv["drvHash"]
            try:
                if keep_going:
                    if bi_drv_drv_hash in self.failed_builds:
                        raise DependencyException("Previous failure")

                self.build(h=bi_drv_drv_hash, pkg_drvs=pkg_drvs, pkg_names=pkg_names,
                           pkghash2sysroothash=pkghash2sysroothash, keep_going=keep_going, delete_tmpfs_build_on_success=delete_tmpfs_build_on_success)
            except subprocess.CalledProcessError as e:
                failed = True
                bi_drv_name = pkg_names[bi_drv_drv_hash]
                failed_names.append(bi_drv_name)
                self.failed_builds.append(bi_drv_drv_hash)
                print(f"failed to build {bi_drv_name} (for {name})")
                # try:
                #     with open(dirpaths.get_basedir() + "/failed.txt", "a", encoding="utf-8") as f:
                #         f.write(bi_drv_name + "\n")
                # except:
                #     print("failed to write fail status")
                if not keep_going:
                    raise e
            except DependencyException as e:
                failed = True
                bi_drv_name = pkg_names[bi_drv_drv_hash]
                failed_names.append(bi_drv_name)
            except Exception as e:
                failed = True
                bi_drv_name = pkg_names[bi_drv_drv_hash]
                failed_names.append(bi_drv_name)
                self.failed_builds.append(bi_drv_drv_hash)
                print(f"failed to build {bi_drv_name} (for {name})")
                try:
                    with open(dirpaths.get_basedir() + "/failed.txt", "a", encoding="utf-8") as f:
                        f.write(bi_drv_name + "\n")
                except:
                    print("failed to write fail status")
                if not keep_going:
                    raise e

        if failed:
            raise DependencyException(
                f"failed to build {name} due to deps:", failed_names)
        for si_drv in drv["sourceInputDrvs"]:
            si_h = si_drv["src"]

            si = pkg_drvs[si_h]
            fetcher.fetch_by_drv_string(si)

        print(f"building {name}")

        os.makedirs(workdir)
        # os.makedirs(workdir + "/build")
        with open(workdir + "/drv.json", "w", encoding="utf-8") as f:
            json.dump(drv, f)

        sysroot_dir = os.path.join(workdir,  "sysroot")
        print(f"workdir={workdir}, sysroot_dir={sysroot_dir}")

        os.makedirs(sysroot_dir, exist_ok=True)
        destdir = os.path.join(workdir, "out/destdir")
        os.makedirs(destdir, exist_ok=True)
        # os.makedirs(workdir + "/src")
        with open(workdir + f"/pn-{name}", "w", encoding="utf-8") as f:
            pass

        subprocess.run(
            ["rm", "-f", dirpaths.get_basedir() + "/latest"], check=True)
        subprocess.run(
            [
                "ln",
                "-s",
                os.path.realpath(workdir),
                os.path.realpath(dirpaths.get_basedir()) + "/latest",
            ],
            check=True,
        )
        link_workdir(h, name)

        os.makedirs(f"{workdir}/packed")

        os.makedirs(f"{workdir}/patches")
        os.makedirs(f"{workdir}/files")
        # pep sysroot symlink
        sysroot_link_dir = os.path.join(workdir, "sysroot.link")
        print(f"creating {sysroot_link_dir}")
        os.makedirs(sysroot_link_dir)
        mounts = {}
        for index, build_input in enumerate(build_inputs):
            mount_dir = str(index)
            build_input_hash = build_input["drvHash"]
            build_input_out = os.path.join(
                dirpaths.get_basedir(), build_input_hash + "-workdir", "out/destdir")
            build_input_dest = build_input["dest"]

            # hopefulle this makes ./build moveable
            out_rel = os.path.relpath(build_input_out, sysroot_link_dir)
            link_tgt = os.path.join(sysroot_link_dir, mount_dir)
            print(f"linking {out_rel}, {link_tgt}")
            os.symlink(out_rel, link_tgt)
            if build_input_dest in mounts:
                mounts[build_input_dest].append(mount_dir)
            else:
                mounts[build_input_dest] = [mount_dir]

        if sandboxed:
            if not "" in mounts:
                mounts[""] = ["s"]
            else:
                mounts[""].append("s")
        mount_commands = []
        for dest in mounts:
            # print(f"(mount comands) dest=\"{dest}\"")
            relative_dest = os.path.join("../sysroot", dest)
            mount_commands.append(["mkdir", "-p", relative_dest])
            if len(mounts[dest]) == 1:
                mount_commands.append(
                    ["mount", "-v", "--bind", mounts[dest][0], relative_dest])
            else:
                mount_opts = "lowerdir="+":".join(mounts[dest])
                mount_command = ["mount", "-v", "-t", "overlay",
                                 "overlay", "-o", mount_opts, relative_dest]
                mount_commands.append(mount_command)
        # print(f"MOUNTS=\"{mounts}\"")
        # print(f"MOUNT COMMANDS=\"{mount_commands}\"")
        # input()

        if not sandboxed:
            assert (not uses_ccache)
            bwrap_bi_drv_args = []

            # sysroot_utils.build_sysroot(
            #     sysroot_drv_hash, drv["buildInputDrvs"], uses_ccache)

        else:
            # symlink_overlay = True
            # bwrap_bi_drv_args = sysroot_utils.prepare_symlink_directory(workdir + "/sysroot", drv["buildInputDrvs"], uses_ccache)
            bwrap_bi_drv_args = []
            # sysroot_utils.build_sysroot(
            #      sysroot_drv_hash, drv["buildInputDrvs"], uses_ccache)

        bwrap_src_args = []
        for si_drv in drv["sourceInputDrvs"]:
            dest = si_drv["dest"]
            si_h = si_drv["src"]
            full_dest = workdir + f"/packed/{si_h}"
            full_dest_append = ""
            if dest != "":
                full_dest_append = f"/{dest}"
            full_dest += full_dest_append
            # should not exist as workdir was deleted and si_h is unique
            os.makedirs(full_dest)

            si = pkg_drvs[si_h]
            if not sandboxed:
                copy_src(h=si_h, dest=full_dest)
            else:
                # full_src_path = get_full_src_path(si_h)
                # src_basename = os.path.basename(full_src_path)
                src_dir = dirpaths.get_basedir() + "/" + si_h + "-src/packed/"
                # if os.path.isdir(full_src_path):
                #     os.makedirs(os.path.join (full_dest, src_basename))
                # else:
                #     with open(os.path.join (full_dest, src_basename),"w") as f:
                #         pass
                bwrap_src_args += [
                    "--ro-bind",
                    src_dir,
                    os.path.join("/tmp/workdir/packed/", si_h) +
                    full_dest_append,

                ]

        patch_drvs = drv["patchDrvs"]
        for pd in patch_drvs:
            patch_file = pd["file"]
            patch_sha256sum = pd["sha256sum"]
            pathc_uri = find_extrafile(patch_file, patch_sha256sum)
            patch_dest = f"{workdir}/patches/{patch_file}"
            if os.path.exists(patch_dest):
                raise FileExistsError(patch_dest)
            subprocess.run(["cp", pathc_uri, patch_dest], check=True)

        extra_file_drvs = drv["extraFileDrvs"]
        for ef in extra_file_drvs:
            ef_file = ef["file"]
            ef_sha256sum = ef["sha256sum"]
            ef_uri = find_extrafile(ef_file, ef_sha256sum)
            ef_dest = f"{workdir}/files/{ef_file}"
            if os.path.exists(ef_dest):
                raise FileExistsError(ef_dest)
            if os.path.isdir(ef_uri):
                ef_cp_cmd = ["cp", "-r"]
            else:
                ef_cp_cmd = ["cp"]

            subprocess.run(ef_cp_cmd + [ef_uri, ef_dest], check=True)

        build_command = drv["scriptContent"]
        build_script_path = os.path.join(workdir, "build.sh")
        with open(build_script_path, "w", encoding="utf-8") as f:
            f.write(build_command)
        subprocess.run(["chmod", "+x", build_script_path], check=True)

        ropaths = ["packed", "files", "patches", "build.sh"]
        args = []
        for ropath in ropaths:
            args += ["--ro-bind", f"{workdir}/{ropath}",
                     f"/tmp/workdir/{ropath}"]

        args += bwrap_src_args

        rwpaths_tmp = ["src", "build"]

        tmpdir = os.environ.get("TMPDIR")
        if tmpdir is None:
            tmpdir = "/tmp"
        tmp_workdir = os.path.join(tmpdir, f"build-{h}")
        # subprocess.run(["rm","-rf",tmp_workdir],check=True)

        tmpfs_build = True
        # delete_tmpfs_build_on_success = True
        tmpfs_dirs_to_delete = []
        if tmpfs_build:
            if os.path.exists(tmp_workdir):
                subprocess.run(
                    ["mv", tmp_workdir, f"{tmp_workdir}.delete"], check=True)
                subprocess.run(["rm", "-rf", f"{tmp_workdir}.delete"])
        for rwpath in rwpaths_tmp:
            if tmpfs_build:
                rwpath_dir = f"{tmp_workdir}/{rwpath}"

                subprocess.run(["rm", "-rf", rwpath_dir])
                os.makedirs(rwpath_dir)
                tmpfs_dirs_to_delete.append(rwpath_dir)
                subprocess.run(["ln", "-s", rwpath_dir, rwpath],
                               cwd=workdir, check=True)
                args += ["--bind", rwpath_dir, f"/tmp/workdir/{rwpath}"]
            else:
                os.makedirs(f"{workdir}/{rwpath}")
                args += ["--bind", f"{workdir}/{rwpath}",
                         f"/tmp/workdir/{rwpath}"]

        rwpaths_persist = ["out"]

        for rwpath in rwpaths_persist:
            args += ["--bind", f"{workdir}/{rwpath}", f"/tmp/workdir/{rwpath}"]

        rwpaths = rwpaths_tmp + rwpaths_tmp

        sandboxed = drv["buildInChroot"]
        uses_ccache = drv["enableCcache"]
        if sandboxed:
            sysroot = sysroot_dir

            for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev"]:
                os.makedirs(sysroot_link_dir + "/s/" + d, exist_ok=True)

            # os.environ.clear()

            path = "/usr/bin:/bin"
            if uses_ccache:
                path = "/usr/lib/ccache:" + path
                args += ["--bind",
                         f"{dirpaths.get_basedir()}/ccache", "/tmp/ccache"]

            senv = {}
            senv["PATH"] = path
            senv["HOME"] = "/"
            if uses_ccache:
                senv["CCACHE_DIR"] = "/tmp/ccache"

            if uses_sccache:
                args += ["--bind",
                         f"{dirpaths.get_basedir()}/sccache", "/tmp/sccache"]
                # args += ["--ro-bind",
                #          f"{dirpaths.get_basedir()}/sccache/config", "/tmp/sccache/config"]

        else:  # not sandboxed
            senv = os.environ.copy()
            senv["TMPDIR"] = "/tmp"
            # deps_sysroot=os.path.join(sys)
            sysroot = "/"
            # deps_sysroot = dirpaths.get_basedir() + "/" + sysroot_drv_hash + \
            #     "-sysroot" + "/sysroot/"
            args += ["--ro-bind", sysroot_dir, "/tmp/workdir/sysroot"]

            # try:
            #     ce = os.environ.get("CCACHE_DIR")
            #     if ce:
            #         if ce != "/tmp/ccache":
            #             args += ["--bind", ce, ce]
            # except:
            #     pass

        args += ["--chdir", "/tmp/workdir/build"]
        args += ["/tmp/workdir/build.sh"]

        t1 = timeit.default_timer()
        bwrap_wrap = bubblewrap.get_bwrap_wrap(
            sysroot=sysroot, sysroot_args=bwrap_bi_drv_args, extra_bwrap_args=args, network=deterministic_fetcher
        )

        chroot_string = "#!/bin/sh\n"
        chroot_string += "run(){"
        chroot_string += "OLD=$(pwd)\n"
        chroot_string += "cd $(dirname $0)/sysroot.link\n"
        chroot_string += "\n".join(' '.join(mc)
                                   for mc in mount_commands) + "\n"
        chroot_string += "cd $OLD\n"
        chroot_string += (''.join([s+" " for s in bwrap_wrap])[
            : -1-len("/tmp/workdir/build.sh")] + "sh\n")

        with open(f"{workdir}/chroot.sh", "w", encoding="utf-8") as f_chroot:
            f_chroot.write(chroot_string)
        subprocess.run(
            ["chmod", "+x", f"{workdir}/chroot.sh"], check=True)

        subprocess_popen_dir = None

        # def fun(): return buildscript.run_build_scipt(workdir, tmp_workdir, bwrap_wrap,
        #                                               senv, subprocess_popen_dir, name, delete_tmpfs_build_on_fail)
        print("running crating wrap")

        def wrap():
            for m in mount_commands:

                print(f"running command {m}({type(m)})")
                subprocess.run(m, check=True, cwd=sysroot_link_dir)
            print(f"running build script")
            buildscript.run_build_scipt(
                workdir, tmp_workdir, bwrap_wrap, senv, subprocess_popen_dir, name, delete_tmpfs_build_on_fail)

        print("unsharing")
        namespace.unshare_run(wrap)

        if deterministic_fetcher:

            if name.startswith("cosmic"):
                try:
                    buildscript.check_deterministic_output(
                        workdir + "/out/destdir",
                        output_file,
                        output_sha256sum
                    )
                except:
                    computed = hashes.compute_file_or_dir_sha256sum(
                        workdir + "/out/destdir/" + output_file)
                    with open(f"pkgs/c/{name.replace("-sources", "")}/src.sha256sum", "w") as f:
                        f.write(computed)

            buildscript.check_deterministic_output(
                workdir + "/out/destdir",
                output_file,
                output_sha256sum
            )
        subprocess.run(["touch", status_file], check=True)
        t2 = timeit.default_timer()
        buildtime = datetime.timedelta(seconds=t2-t1)
        print(f"building {name} took {buildtime}")
        with open(dirpaths.get_basedir() + "/tmp/buildtimes.txt", "a", encoding="utf-8") as f:
            f.write(f"{name}\t-\t{buildtime}\n")
        print(f"finished building {name}")

        if tmpfs_build and delete_tmpfs_build_on_success:
            for d in [tmp_workdir]:
                print(f"removing {d}")
                try:
                    print()
                    subprocess.run(["rm", "-rf", d], check=True)
                except subprocess.CalledProcessError:
                    # go, permission and tihngs
                    print(f"warning: failed to delete {d}")


def build(*args, **kwargs):
    b = builder()
    try:
        r = b.build(*args, **kwargs)
    except Exception as e:
        b.print_failed()
        raise e
    return r
