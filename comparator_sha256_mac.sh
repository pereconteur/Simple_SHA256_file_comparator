#!/bin/bash

# Function to print a message in green
function echo_green {
  echo -e "\033[32m$1\033[0m"
}

# Function to print a message in red
function echo_red {
  echo -e "\033[31m$1\033[0m"
}

# Function to calculate the SHA256 hash of a file
function sha256sum_file {
  local file="$1"
  openssl dgst -sha256 "$file" | cut -d ' ' -f 2
}

# Function to compare two hashes
function compare_hash {
  if [ "$1" = "$2" ]; then
    echo_green "The hashes are identical"
  else
    echo_red "The hashes are different"
  fi
}

function compare_hashes() {
    local hash1=$1
    local hash2=$2
    local length=${#hash1}

    for (( i=0; i<$length; i++ )); do
        if [[ ${hash1:i:1} == ${hash2:i:1} ]]; then
            echo -ne "${hash1:i:1}"
        else
            echo -ne "\033[31m${hash1:i:1}\033[0m"
        fi
    done
    echo
}

echo "What do you want to do?"
echo "1. Verify the hash of a single file"
echo "2. Compare two files"
echo "3. Compare a file with a hash"

read -r choice

case "$choice" in
  1)
    echo "Enter the path of the file you want to check the hash of:"
    read -r file
    hash=$(sha256sum_file "$file")
    echo_green "The hash of the file is: $hash"
    ;;
  2)
    echo "Enter the path of the first file:"
    read -r file1
    hash1=$(shasum -a 256 "$file1" | cut -d' ' -f1)

    echo "Enter the path of the second file:"
    read -r file2
    hash2=$(shasum -a 256 "$file2" | cut -d' ' -f1)

    if [[ "$hash1" == "$hash2" ]]; then
      echo -e "\033[32mThe two files are identical.\033[0m"
      echo -e "\033[32m$hash1\033[0m"
    else
      echo -e "\033[31mThe two files are different: \033[0m"
      compare_hashes "$hash1" "$hash2"
      compare_hashes "$hash2" "$hash1"
    fi
    ;;
  3)
    echo "For the first file, do you want to enter the path (P) or the hash (H)?"
    read -r choice1
    if [ "$choice1" = "P" ] || [ "$choice1" = "p" ]; then
      echo "Enter the path of the first file:"
      read -r file1
      hash1=$(sha256sum_file "$file1")
    elif [ "$choice1" = "H" ] || [ "$choice1" = "h" ]; then
      echo "Enter the hash of the first file:"
      read -r hash1
    else
      echo_red "Invalid choice"
      exit 1
    fi

    echo "For the second file, do you want to enter the path (P) or the hash (H)?"
    read -r choice2
    if [ "$choice2" = "P" ] || [ "$choice2" = "p" ]; then
      echo "Enter the path of the second file:"
      read -r file2
      hash2=$(sha256sum_file "$file2")
    elif [ "$choice2" = "H" ] || [ "$choice2" = "h" ]; then
      echo "Enter the hash of the second file :"
      read -r hash2
    else
      echo_red "Invalid choice"
      exit 1
    fi

    compare_hash "$hash1" "$hash2"
    compare_hashes "$hash1" "$hash2"
    compare_hashes "$hash2" "$hash1"
    ;;
  *)
    echo_red "Invalid choice"
    exit 1
    ;;
esac
