

import os

from lib import util_functions
def run_in_bwrap_chroot(sysroot:str, extra_bwrap_args="",network=False)->int:
    """
    RUn a command in a bubblewrap chroot
    sysroot: root to chroot into
    """
    
    net_args=""
    if network:
        net_args="--ro-bind /etc/resolv.conf /etc/resolv.conf"
        if not os.path.isdir(sysroot + "/etc"):
            os.mkdir( sysroot + "/etc" )
        if not os.path.exists(sysroot + "/etc/resolv.conf"):
            os.system(  "touch "+ sysroot + "/etc/resolv.conf" )
    bwrap_wrap = f'''
unshare --map-root-user bwrap \\
        --ro-bind {sysroot} / \\
        --tmpfs /run \\
        --dev /dev \\
        --tmpfs /tmp \\
        {net_args} {extra_bwrap_args}
        '''
    
    
    e=bwrap_wrap.strip().split()[-1]
    bwrap_chroot=bwrap_wrap.strip()[:-len(e)]+" /bin/sh"

    try:
        util_functions.write_script(script_content=bwrap_chroot,script_filepath=sysroot + "/bwrap.sh")
    except:
        pass
    status= os.system(bwrap_wrap)
    if status!=0:
        print(f"running {bwrap_wrap} \n failed!")
        return status
    return 0
        
 

