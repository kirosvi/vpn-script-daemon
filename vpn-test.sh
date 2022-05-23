#!/bin/bash

function is_user_exist() {
        if [[ -f $USERNAME ]]; then
          echo "user exist"
          exit 1
        else
          echo "user not exist"
        fi
}

### Get options
while getopts "u:m:crh" options ;
do
  case $options in
  u)
    USERNAME="$OPTARG"
    U=1
  ;;
  m)
    EMAIL="$OPTARG"
    E=1
  ;;
  c)
    CREATE=1
  ;;
  r)
    REMOVE=1
  ;;
  h)
    echo_help
    exit 0
  ;;
  *)
    echo " None defined options!"
    echo_help
    exit 0
  esac
OPTS="$OPTS$options"
done

if [[ $OPTS == "" ]]; then
  echo -n "None defined options"
  echo_help
  exit 0
fi

### Check for valid collection of options
CHECK=$((CREATE+U))
if [ "$CHECK" -lt 2 ] && [ "$REMOVE" -eq 0 ]; then
  echo "Must specify 'user' and 'action' parametrs"
  exit 0
fi

CHECK2=$((CREATE+REMOVE))
if [[ "$CHECK2" -eq 2 ]]; then
  echo "You can't create and delete user at same time"
  exit 0
fi

CHECK3=$((REMOVE+U))
if [ "$CHECK3" -lt 2 ] && [ "$CREATE" -eq 0 ]; then
  echo "Must specify 'user' and 'action' parametrs2"
  exit 0
fi

# Get email for local user
if [[ "$E" -ne 1 ]]; then
  EMAIL="$USERNAME"@emailexample.org
fi


# MAIN
if [[ "$REMOVE" -eq 1 ]]; then
  echo "removing user $USERNAME $EMAIL"
  echo "removed $(date) $EMAIL" > $USERNAME
fi
if [[ "$CREATE" -eq 1 ]]; then
  is_user_exist
  echo "creating user $USERNAME $EMAIL"
  touch $USERNAME
  echo "created $(date) $EMAIL" > $USERNAME
fi
