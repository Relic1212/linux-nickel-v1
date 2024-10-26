
#include <stdio.h>
#include <sys/mount.h>
#include <sys/stat.h>

int main(int argc,char* argv[]){
    
    int status = 0;
    if (mount( NULL, "/sys", "sysfs", 0, NULL) != 0){
        printf("Failed to mount /sys\n");
        status=1;
    }

    if (mkdir("/dev/shm",0755)==0){
        if (mount(NULL,"/dev/shm","tmpfs",MS_NODEV|MS_NOSUID,NULL ) !=0 ){
            printf("Failed to mount /dev/shm\n");
            status=1;
        }

    }else{
        printf("Failed to crate /dev/shm\n");
        status=1;
    }

    if (mkdir("/dev/pts",0755)==0){
        if (mount(NULL,"/dev/pts","devpts",0,"gid=5" )!=0 ){
            printf("Failed to create /dev/shm\n");
            status=1;
        }

    }else{
        printf("Failed to crate /dev/shm\n");
        status=1;
    }


    // TODO: hidepid
    if (mount( NULL, "/proc", "proc", 0, NULL) != 0){
        printf("Failed to mount /proc\n");
        status=1;
    };
  
    if (mount(NULL,"/run","tmpfs",0,"mode=775"  ) !=0){
        printf("Failed to mount /run\n");
        status=1;
    }else{
        if (mkdir("/run/lock",0755)!=0){
            printf("Failed to create /var/lock\n");
            status=1;
        }
        if (mkdir("/run/udev",0755)!=0){
            printf("Failed to create /run/udev\n");
            status=1;
        }

    }
    
    struct stat d = {0};
   
    if (stat("/sys/fs",&d)!=0){
        if  (mkdir("/sys/fs",0755)==0){
            if (stat("/sys/fs/cgroup",&d)!=0){
                if (        mkdir("/sys/fs/cgroup",0755)!=0){
                    status=1;
                    printf("Failed to create /sys/fs/cgroup\n");
                }
            }
        }else{
            status=1;
            printf("Failed to create /sys/fs\n");

        }
    }
    if (mount("cgroup", "/sys/fs/cgroup","cgroup2",0,"rw")!=0){
        status=1;
        printf("Faild to mount cgroups\n");
    }

    if (mount(NULL,"/tmp","tmpfs",MS_NODEV|MS_NOSUID,"mode=1777"  ) !=0){
        printf("Failed to mount /tmp\n");
        status=1;
    }
    return status;
}
