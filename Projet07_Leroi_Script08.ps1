# Contenu de Projet07_Leroi_Script08.ps1
# Version 1.1 - Leroi Cyrille
# Révisions : 
# - 1.1 : Ajout blocs Try/Catch 
# - 1.0 : Liste les les imprimantes partagé

### Script qui Liste les les imprimantes partagé et enregistre le tout dans un fichier .txt ###

# Variable génération de fichier .txt

$chemin ="C:\Scripts\Projet07_Leroi_AD08.txt"

     # Essayer cette commande.

try{

    # Cette ligne de commande permet d'obtenir la liste des Partages.

     Get-CimInstance -Class Win32_Printer | Out-File $chemin

     Write "Copie du fichier $chemin"
}

     # Sinon, affiche le résultat de l'erreur.

catch
{
    Write-Host -Fore Yellow "Une erreur est survenue :`n $($Error[0])" 
}

# Message de fin.

Write-Host -fore Green "Merci d'avoir utilisé ce script"
