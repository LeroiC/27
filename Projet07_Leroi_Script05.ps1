# Contenu de Projet07_Leroi_Script05.ps1
# Version 1.1 - Leroi Cyrille
# Révisions : 
# - 1.1 : Ajout blocs Try/Catch 
# - 1.0 : Liste des membres de l'AD

### Script qui Liste des membres de l'AD et enregistre le tout dans un fichier .txt ###

# Variable génération des fichiers .txt.

$chemin ="C:\Scripts\Projet07_Leroi_AD05.txt"

     # Essayer cette commande.

try{

     # Cette ligne de commande permet d'obtenir la liste des membres de l'AD.

     Get-ADUser -Filter * | Out-File $chemin

     Write "Copie du fichier $chemin"
}

     # Sinon, affiche le résultat de l'erreur.

catch
{
    Write-Host -Fore Yellow "Une erreur est survenue :`n $($Error[0])"   
}

# Message de fin.

Write-Host -fore Green "Merci d'avoir utilisé ce script"
