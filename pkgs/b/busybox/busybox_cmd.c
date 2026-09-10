#include <unistd.h>
#ifdef DEBUG
#include <stdio.h> 
#endif 

#ifndef APPLET
#error "APPLET not defined"
#endif

int main(int argc, char * argv[])
{


    char * argv2[argc+1];
    argv2[0] = APPLET;
    argv2[argc]=NULL;

#ifdef DEBUG
    printf("argc=%i\n", argc);
    printf("executing \"/usr/bin/busybox %s", APPLET);
#endif
    for (int i = 1; i < argc; i++) {
        argv2[i] = argv[i];
#ifdef DEBUG
        printf(" %s",argv2[i]);
#endif
    }
#ifdef DEBUG
    printf("\"\n");
#endif
    
    execv("/usr/bin/busybox", argv2);
    

    return 0;
}