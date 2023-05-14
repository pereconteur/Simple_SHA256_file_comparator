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
  local file="${1%\'*}"
  file="${file#*\'}"
  shasum -a 256 "$file" | cut -d ' ' -f 1
}

# Function to compare two hashes
function compare_hash {
  if [ "$1" = "$2" ]; then
    echo_green "Les hashs sont identiques"
  else
    echo_red "Les hashs sont différents"
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

echo "Que voulez-vous faire ?"
echo "1. Vérifier le hachage d'un seul fichier"
echo "2. Comparer deux fichiers"
echo "3. Comparer un fichier avec un hachage"

read -r choice

case "$choice" in
  1)
    echo "Saisissez le chemin d'accès du fichier dont vous souhaitez vérifier le hachage :"
    read file_path
    hash=$(sha256sum_file "$file_path")
    echo_green "Le hachage du fichier est le suivant : $hash"
    ;;
  2)
    echo "Saisissez le chemin d'accès du premier fichier :"
    read file_path1
    hash1=$(sha256sum_file "$file_path1")

    echo "Saisissez le chemin d'accès du deuxième fichier :"
    read file_path2
    hash2=$(sha256sum_file "$file_path2")

    if [[ "$hash1" == "$hash2" ]]; then
      echo -e "\033[32mLes deux fichiers sont identiques.\033[0m"
      echo -e "\033[32m$hash1\033[0m"
    else
      echo -e "\033[31mLes deux fichiers sont différents : \033[0m"
      compare_hashes "$hash1" "$hash2"
      compare_hashes "$hash2" "$hash1"
    fi
    ;;
  3)
    echo "Pour le premier fichier, voulez-vous saisir le chemin (C) ou le hachage (H) ?"
    read -r choice1
    if [ "$choice1" = "P" ] || [ "$choice1" = "p" ]; then
      echo "Saisissez le chemin d'accès du premier fichier :"
      read file1
      hash1=$(sha256sum_file "$file1")
    elif [ "$choice1" = "C" ] || [ "$choice1" = "c" ]; then
      echo "Saisissez le hachage du premier fichier :"
      read -r hash1
    else
      echo_red "Invalid choice"
      exit 1
    fi

    echo "Pour le deuxième fichier, voulez-vous saisir le chemin (C) ou le hachage (H) ?"
    read -r choice2
    if [ "$choice2" = "P" ] || [ "$choice2" = "p" ]; then
      echo "Saisissez le chemin d'accès du deuxième fichier :"
      read file2
      hash2=$(sha256sum_file "$file2")
    elif [ "$choice2" = "C" ] || [ "$choice2" = "c" ]; then
      echo "Saisissez le chemin d'accès du deuxième fichier :"
      read -r hash2
    else
      echo_red "Choix non valide"
      exit 1
    fi

    compare_hash "$hash1" "$hash2"
    compare_hashes "$hash1" "$hash2"
    compare_hashes "$hash2" "$hash1"
    ;;
  *)
    echo_red "Choix non valide"
    exit 1
    ;;
esac
