#!/bin/sh


USER_NAME=$2

USER_IS_UNLOCK_USER=0
[[ $USER_NAME == "user" ]] && USER_IS_UNLOCK_USER=1
[[ $USER_NAME == "user0" ]] && USER_IS_UNLOCK_USER=1
[[ $USER_NAME == "user1" ]] && USER_IS_UNLOCK_USER=1
[[ $USER_NAME == "user2" ]] && USER_IS_UNLOCK_USER=1

LOGIN="/usr/bin/login"

export PATH="/usr/bin:/bin"

# check if the user is valid
if [ $USER_IS_UNLOCK_USER -eq 0 ]; then
    if [ "${USER_NAME}" = "root" ]; then 
        exec ${LOGIN} "root"
    fi
    printf "${USER_NAME} does not exist"
    exit 1
fi

# check if the vault exists and is already unlocked, login with busybox if so
if [ -d  /home/.shadow/$USER_NAME  ]; then
    fscrypt status /home/.shadow/$USER_NAME | grep -i unlocked | grep -i yes >/dev/null 
    
    if [ $? -eq 0 ];then

        "${LOGIN}"  $USER_NAME
        exit
    fi
fi
# if it was not unlokced, ask for the password and unlock it

printf "------------------------------\n"
printf "Please type your password:"
read -r -s PASSWORD

printf $PASSWORD|fscrypt unlock /home/.shadow/$USER_NAME --quiet
unlock_status=$?
# mount stuff


#####################################################################################
do_bind(){
    # Will fail if not unencrypted

    # make sure home exists (to be bind-mounted at /home/$USER_NAME)
    if [ ! -d  /home/.shadow/$USER_NAME/home  ]; then 
        mkdir -p /home/.shadow/$USER_NAME/home 
        chown -R $USER_NAME:$USER_NAME /home/.shadow/$USER_NAME/home 
    fi 

    # Make sure the mountpoint exists
    if [ ! -d /home/$USER_NAME ]; then
        mkdir -p /home/$USER_NAME
        #TODO: chown this?
    fi 

    findmnt /home/$USER_NAME > /dev/null ||  mount --bind /home/.shadow/$USER_NAME/home /home/$USER_NAME

    #chown -R $USER_NAME:$USER_NAME /home/$USER_NAME #(moved up)

    # Generate a session-specific password hash
    PASS=$(openssl passwd $PASSWORD)
    while true ; do
        echo $PASS|grep \/ > /dev/null || break
        PASS=$(openssl passwd $PASSWORD)
        
    done

    # Delete previous password hash if it exists
    rm -rf /run/shadow

    # Store the session password hash
    cp -p /etc/shadow /run/shadow
    sed -i -e  "s/^\($USER_NAME:\)[^:]*\(:.*\)$/\1$PASS\2/" /run/shadow
    findmnt /etc/shadow > /dev/null ||    mount --bind /run/shadow /etc/shadow
    
    if [ ! -d  /home/.shadow/$USER_NAME/nix  ]; then 
        mkdir  /home/.shadow/$USER_NAME/nix 
        chown -R $USER_NAME:$USER_NAME  /home/.shadow/$USER_NAME/nix 
    fi
    mount --bind /home/.shadow/$USER_NAME/nix /nix 
}
###############################################################################################


if [  -d /home/.shadow/$USER/ ]; then
    do_bind


else
    printf "User not in database, please enter your password again to create a new user:\n"
    printf "Password:"
    read -r -s PASSWORD_CHECK
    if [ ! "${PASSWORD}" = "${PASSWORD_CHECK}" ]; then 
        printf "Passwords don't match!\n"
        exit 1
    fi
################### BEGIN CREATE ######################################

    mkdir -p /home/.shadow/$USER_NAME

    tune2fs -O encrypt /dev/disk/by-uuid/dd95fdd6-681c-4ebe-98eb-25822368a556

    fscrypt setup --force --quiet /home

    echo $PASSWORD | fscrypt encrypt /home/.shadow/$USER_NAME \
        --source=custom_passphrase \
        --user=$USER_NAME \
        --name=$USER_NAME \
        --quiet 

    # Create the home directory in the  "secret dirocrory". This will be bind-mounted to ~/
    mkdir -p /home/.shadow/$USER_NAME/home    
    chown -R $USER_NAME:$USER_NAME /home/.shadow/$USER_NAME/home

    if [ -d /home/$USER_NAME/ ]; then
        for f in $( ls -a /home/$USER_NAME/ ); do
            mv /home/$USER_NAME/$f /home/.shadow/$USER_NAME/home  
        done
    fi
################### END CREATE ######################################

    do_bind

    unlock_status=0
    printf "a home directory has been created for you\n"

fi

if [ $unlock_status -eq 0 ]; then
    "${LOGIN}" -f $USER_NAME
    exit 0
else 
    printf "wrong vault password"
    exit 1
fi

