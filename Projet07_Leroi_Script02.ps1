# Contenu de Projet07_Leroi_Script02.ps1
# Date : 10.03.2022
# Version 1.1 - Leroi Cyrille
# Révisions : 
# - 1.1 : Ajout blocs Try/Catch/Finally 
# - 1.0 : Liste des membres d'un groupe


### Script qui Liste des membres d'un groupe et enregistre le tout dans un fichier .txt ###



# Essayer cette commande.

try{

     # Demande le Nom d'un groupe.

     $group = Read-Host "Merci de rentrer le Nom d'un groupe de l'AD"

     # Demande le chemin du fichier .txt.

     $chemin = Read-Host "Merci de rentrer le chemin du fichier .txt"
     
     # Cette commande permet d'obtenir la liste des membres de l'AD qui sont dans un groupe.

     Get-ADGroupMember $group | Out-File $chemin

     # Message de création du fichier.

     Write-Host -Fore Green "REUSSITE - Copie du fichier $chemin"

}
# Sinon affiche le resultat de l'erreur.

Catch {

     Write-Warning "ECHEC - Une erreur est survenue :`n $($Error[0])"
       
}
# Finalement message de fin.

Finally{     

      Write-Output "Merci d'avoir utilisé ce Script"
}


