#!/bin/bash

echo "Entrez le chemin absolu du premier fichier à comparer: "
read file1

# Vérification de l'existence du fichier
if [[ ! -f "$file1" ]]; then
    echo "Le fichier $file1 n'existe pas."
    exit 1
fi

echo "Entrez le chemin absolu du deuxième fichier à comparer: "
read file2

# Vérification de l'existence du fichier
if [[ ! -f "$file2" ]]; then
    echo "Le fichier $file2 n'existe pas."
    exit 1
fi

# Récupération des SHA256 des deux fichiers
sha1=$(shasum -a 256 "$file1" | cut -d ' ' -f 1)
sha2=$(shasum -a 256 "$file2" | cut -d ' ' -f 1)

if [[ "$sha1" == "$sha2" ]]; then
    echo -e "\033[32mLes fichiers sont identiques.\033[0m"
else
    echo -e "\033[31mLes fichiers sont différents.\033[0m"
fi

echo "SHA256 du premier fichier ($file1): $sha1"
echo "SHA256 du deuxième fichier ($file2): $sha2"
