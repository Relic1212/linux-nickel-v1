import json
import subprocess
import sys
import timeit
import datetime

try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher, sysroot_utils
except ModuleNotFoundError:
    import bubblewrap
    import hashes
    import util_functions
    import dirpaths
    import fetcher
    import sysroot_utils

import os


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


def check_deterministic_output(output_path: str, filename: str, sha256sum: str):
    outputs = os.listdir(output_path)
    if len(outputs) > 1:
        raise Exception(
            f"ERROR {output_path} ({filename}) has more than 1 file")
    elif len(outputs) != 1:
        raise Exception(f"no outputs (not {filename}) in " + output_path)
    output_filepath = f"{output_path}/{filename}"
    if not os.path.isfile(output_filepath):
        raise Exception(f"{output_filepath} is not a file")

    computed = hashes.compute_file_or_dir_sha256sum(output_filepath)
    print("verifying", output_filepath)
    if computed != sha256sum:
        print(f"ERROR: {computed}!={sha256sum}")
        raise Exception(f"Wrong sha256sum for {output_filepath}")


class DependencyException(Exception):
    pass


class builder:
    def __init__(self):
        self.failed_builds = []

    def print_failed(self):
        if len(self.failed_builds) > 0:
            print("The following failed to build", self.failed_builds)

    def build(self, h: str, pkg_drvs: dict, pkg_names: dict, pkghash2sysroothash: dict, keep_going: bool = False, prev_failed=None, delete_tmpfs_build_on_success=True) -> None:

        # h=hash
        # drv_s=pkgs[hash]

        drv_s = pkg_drvs[h]
        drv = json.loads(drv_s)
        name = pkg_names[h]

        workdir = dirpaths.get_basedir() + "/" + h + "-workdir"
        status_file = workdir + "/0.txt"
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
        sysroot_drv_hash = pkghash2sysroothash[h]

        subprocess.run(["rm", "-rf", workdir], check=True)
        failed = False
        failed_names = []
        # if prev_failed is None:
        #     prev_failed = []

        for bi_drv in drv["buildInputDrvs"]:
            if type(bi_drv) is str:
                bi_drv_drv_hash = bi_drv
            else:
                bi_drv_drv_hash = bi_drv["drvHash"]
            try:
                if keep_going:
                    if bi_drv_drv_hash in self.failed_builds:
                        raise DependencyException("Previous failure")

                self.build(h=bi_drv_drv_hash, pkg_drvs=pkg_drvs, pkg_names=pkg_names,
                           pkghash2sysroothash=pkghash2sysroothash, keep_going=keep_going)
            except subprocess.CalledProcessError as e:
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
        os.makedirs(workdir + "/sysroot", exist_ok=True)
        os.makedirs(workdir + "/out/destdir", exist_ok=True)
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
        symlink_build_inputs = drv['symlinkBuldInputs']

        if symlink_build_inputs:
            bwrap_bi_drv_args = sysroot_utils.prepare_sysroot_symlink(
                drv, workdir)
        elif not sandboxed:
            bwrap_bi_drv_args = []

            sysroot_utils.build_sysroot(
                sysroot_drv_hash, drv["buildInputDrvs"], uses_ccache)

        else:
            bwrap_bi_drv_args = []

            sysroot_utils.build_sysroot(
                sysroot_drv_hash, drv["buildInputDrvs"], uses_ccache)

        for si_drv in drv["sourceInputDrvs"]:
            dest = si_drv["dest"]
            si_h = si_drv["src"]
            full_dest = workdir + f"/packed/{si_h}"
            if dest != "":
                full_dest += f"/{dest}"
            # should not exist as workdir was deleted and si_h is unique
            os.makedirs(full_dest)
            si = pkg_drvs[si_h]
            copy_src(h=si_h, dest=full_dest)

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
        build_script_path = workdir + "/build.sh"
        with open(build_script_path, "w", encoding="utf-8") as f:
            f.write(build_command)
        subprocess.run(["chmod", "+x", build_script_path], check=True)

        ropaths = ["packed", "files", "patches", "build.sh"]
        args = []
        for ropath in ropaths:
            args += ["--ro-bind", f"{workdir}/{ropath}",
                     f"/tmp/workdir/{ropath}"]

        rwpaths_tmp = ["src", "build"]

        tmp_workdir = f"/tmp/build-{h}"
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
            if symlink_build_inputs:
                sysroot = workdir + "/sysroot/"
                for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev", "/pkgs"]:
                    os.makedirs(sysroot + "/" + d, exist_ok=True)
            else:
                sysroot = dirpaths.get_basedir() + "/" + sysroot_drv_hash + \
                    "-sysroot" + "/sysroot/"

            # os.environ.clear()

            path = "/usr/bin:/usr/sbin:/bin:/sbin"
            if uses_ccache:
                path = "/usr/lib/ccache:" + path
                for compiler in [
                    "gcc",
                    "cc",
                    "clang",
                    "g++",
                    "clang++",
                    "x86_64-pc-linux-musl-c++",
                    "x86_64-pc-linux-musl-g++",
                    "x86_64-pc-linux-musl-gcc",
                    "x86_64-linux-musl-c++",
                    "x86_64-linux-musl-g++",
                    "x86_64-linux-musl-gcc",
                ]:
                    if os.path.exists(sysroot + "/usr/bin/" + compiler):
                        cmd = ["ln", "-s", "/usr/bin/ccache", compiler]
                        directory = sysroot + "/usr/lib/ccache"
                        senv = {"PATH": os.getenv("PATH"), "HOME": "/"}
                        if symlink_build_inputs:
                            subprocess.run(cmd, cwd=directory,
                                           env=senv, check=True)

                os.environ["CCACHE_DIR"] = "/tmp/ccache"
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

        else:  # not sandboxed
            senv = os.environ.copy()
            senv["TMPDIR"] = "/tmp"
            sysroot = "/"
            deps_sysroot = dirpaths.get_basedir() + "/" + sysroot_drv_hash + \
                "-sysroot" + "/sysroot/"
            args += ["--ro-bind", deps_sysroot, "/tmp/workdir/sysroot"]

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
        with open(f"{workdir}/b.log", "a", encoding="utf-8") as f:
            # with open(f"{workdir}/error.log", "a", encoding="utf-8") as f_error:
            # bubblewrap.run_in_bwrap_chroot(sysroot=sysroot, extra_bwrap_args=args, env=senv, stderr=errorfile,stdout=logfile)
            bwrap_wrap = bubblewrap.get_bwrap_wrap(
                sysroot=sysroot, sysroot_args=bwrap_bi_drv_args, extra_bwrap_args=args, network=deterministic_fetcher
            )
            chroot_string = ("#!/bin/sh\n" + ''.join([s+" " for s in bwrap_wrap])[
                : -1-len("/tmp/workdir/build.sh")] + "sh\n")

            with open(f"{workdir}/chroot.sh", "w", encoding="utf-8") as f_chroot:
                f_chroot.write(chroot_string)
            subprocess.run(
                ["chmod", "+x", f"{workdir}/chroot.sh"], check=True)

            with subprocess.Popen(
                args=bwrap_wrap,
                env=senv,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                text=True,
                errors="replace"
            ) as proc:
                try:
                    for line in proc.stdout:
                        try:
                            print(line, end="")
                        except UnicodeDecodeError:
                            print("UnicodeDecodeError")
                        try:
                            f.write(line)
                        except UnicodeDecodeError:
                            print("UnicodeDecodeError")
                except UnicodeDecodeError:
                    print("UnicodeDecodeError")
            f.close()
            status = proc.returncode
            if status != 0:
                print("env =", senv)
                print(f"Failed to build {name}")
                raise subprocess.CalledProcessError(status, cmd=bwrap_wrap)
        if deterministic_fetcher:
            # computed = hashes.compute_file_or_dir_sha256sum(workdir + "/out/destdir/" + output_file)
            # with open(f"pkgs/c/{name.replace("-sources","")}/src.sha256sum","w") as f:
            #     f.write(computed)

            check_deterministic_output(
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
