#!/bin/bash

# Fonction pour afficher un message en vert
function echo_green {
  echo -e "\033[32m$1\033[0m"
}

# Fonction pour afficher un message en rouge
function echo_red {
  echo -e "\033[31m$1\033[0m"
}

# Fonction pour calculer le hash SHA256 d'un fichier
function sha256sum_file {
  local file="$1"
    openssl dgst -sha256 "$file" | cut -d ' ' -f 2
}

# Fonction pour comparer deux hash
function compare_hash {
  if [ "$1" = "$2" ]; then
    echo_green "Les hash sont identiques"
  else
    echo_red "Les hash sont différents"
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
echo "1. Vérifier le hash d'un seul fichier"
echo "2. Comparer deux fichiers entre eux"
echo "3. Comparer un fichier avec un hash"

read -r choix

case "$choix" in
  1)
    echo "Entrez le chemin du fichier dont vous voulez vérifier le hash :"
    read -r fichier
    hash=$(sha256sum_file "$fichier")
    echo_green "Le hash du fichier est : $hash"
    ;;
  2)
    echo "Entrez le chemin du premier fichier :"
        read -r fichier1
        hash1=$(shasum -a 256 "$fichier1" | cut -d' ' -f1)

        echo "Entrez le chemin du deuxième fichier :"
        read -r fichier2
        hash2=$(shasum -a 256 "$fichier2" | cut -d' ' -f1)

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
    echo "Pour le premier fichier, voulez-vous entrer le chemin (C) ou le hash (H) ?"
    read -r choix1
    if [ "$choix1" = "C" ]; then
      echo "Entrez le chemin du premier fichier :"
      read -r fichier1
      hash1=$(sha256sum_file "$fichier1")
    elif [ "$choix1" = "H" ]; then
      echo "Entrez le hash du premier fichier :"
      read -r hash1
    else
      echo_red "Choix invalide"
      exit 1
    fi

    echo "Pour le deuxième fichier, voulez-vous entrer le chemin (C) ou le hash (H) ?"
    read -r choix2
    if [ "$choix2" = "C" ]; then
      echo "Entrez le chemin du deuxième fichier :"
      read -r fichier2
      hash2=$(sha256sum_file "$fichier2")
    elif [ "$choix2" = "H" ]; then
      echo "Entrez le hash du deuxième fichier :"
      read -r hash2
    else
      echo_red "Choix invalide"
      exit 1
    fi

    compare_hash "$hash1" "$hash2"
    ;;
  *)
    echo_red "Choix invalide"
    exit 1
    ;;
esac
