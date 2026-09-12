#define _GNU_SOURCE

#include <sys/mount.h>
#include <linux/mount.h>


int main(){
    int i = fsopen("", 0);
    return i;
}