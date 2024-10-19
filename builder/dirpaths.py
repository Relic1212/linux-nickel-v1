def get_basedir() -> str:
    """Get tha base path for the build directory. The directory with returned will
    containe directories whose names are hashes for either derivations, sources
    or packages.

    Returns:
        str: _description_
    """
    return "./build"
