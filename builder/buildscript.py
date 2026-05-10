
import subprocess

try:
    import dirpaths
    import hashes
except:
    from builder import dirpaths, hashes
import os


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
        print(f"ERROR: expected:{sha256sum}, got:{computed}")
        raise Exception(f"Wrong sha256sum for {output_filepath}")


def in_ns(mounts, fun):
    for m in mounts:
        subprocess.run(m, check=True)
    fun()


def run_build_scipt(workdir, tmp_workdir, bwrap_wrap, senv, subprocess_popen_dir, name, delete_tmpfs_build_on_fail):
    print(f"run_build_script starting for name {name}")
    with open(f"{workdir}/b.log", "a", encoding="utf-8") as f:

        with subprocess.Popen(
            args=bwrap_wrap,
            env=senv,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
            text=True,
            errors="replace",
            cwd=subprocess_popen_dir
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
            try:
                with open(dirpaths.get_basedir() + "/failed.txt", "a", encoding="utf-8") as f:
                    f.write(name + "\n")
            except:
                print("failed to write fail status")
            if delete_tmpfs_build_on_fail:
                for d in [tmp_workdir]:
                    print(f"removing {d}")
                    try:
                        print()
                        subprocess.run(["rm", "-rf", d], check=True)
                    except subprocess.CalledProcessError:
                        # go, permission and tihngs
                        print(f"warning: failed to delete {d}")
            raise subprocess.CalledProcessError(status, cmd=bwrap_wrap)
