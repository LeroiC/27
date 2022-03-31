# Contenu de Projet07_Leroi_Script01.ps1
# Date : 10.03.2022
# Version 1.3 - Leroi Cyrille
# Révisions : 
# - 1.3 : Ajout gestion des autorisations NTFS
# - 1.2 : Ajout blocs Try/Catch/Finally
# - 1.1 : Ajout filtre : Vérifier la présence de l'utilisateur dans l'AD 
# - 1.0 : Création d'utilisateurs avec un dossier partagé

###### Script de création des utilisateurs avec un dossier partagé a leur nom.######

#### Taper les commandes suivantes avant de continuer :
## Pour autoriser l'execution du script.

# Set-Execution Policy Unrestricted 

# Pour importer le module Active Directory.

# Import-Module ActiveDirectory 

# Pour importer le module NTFSSecurity.

# Import-Module NTFSSecurity

### Les droit d'acces au dossier sont gérez par permission NTFS.
## Les droit de partage sont attribuez pour Tout le monde en Modification.
## L'utilisateur est le propriétaire du dossier et a un accès de Modification.


# Demande le Nom de l'utilisateur.

$Nom = Read-Host "Merci de rentrer le Nom de l'utilisateur à créer"

# Demande le Prénom de l'utilisateur.

$Prenom = Read-Host "Merci de rentrer le Prénom de l'utilisateur à créer"

# Demande le Login de l'utilisateur.

$Login = Read-Host "Merci de rentrer le login de l'utilisateur à créer"

# Demande l'Email de l'utilisateur.

$Email = Read-Host "Merci de rentrer l'Email de l'utilisateur à créer"

# Demande le Mot de Passe de l'utilisateur.

$MotDePasse = Read-Host "Merci de rentrer le Mot de Passe de l'utilisateur à créer"

# Demande le chemin du dossier de l'utilisateur.

$Dossier = Read-Host "Merci de rentrer le Chemin du dossier à créer"

# Prépatation des variables

$Profil      = $Nom + ' ' + $Prenom
$ShareName   = $Login + '$'
$SharePath   = $Dossier + $Nom
$NTFSShare   = $SharePath + '\'
$ToutleMonde = "Tout le monde"
$Utilisateur = "Utilisateurs"

# Essaye la commande

Try{
	 
### Vérifier la présence de l'utilisateur dans l'AD sinon le créer.

     # Filtre les utilisateurs existants.

     $User = "SamAccountName -Like ""*$Login*"""
     $Users = @{Filter = $User}

     if (Get-ADUser @Users){

        # Affiche un message si l'utilisateur est deja enregistré.

        Write-Host -fore Yellow "L'identifiant $Profil existe déjà dans l'AD"
        }
        else{  

        # Créer un nouvel utilisateur dans l'AD.

	New-ADUser -Name $Profil  `
                   -SamAccountName $Login  `
                   -Surname $Nom  `
                   -GivenName $Prenom   `
                   -EmailAddress $Email  `
                   -UserPrincipalName $Email  `
                   -AccountPassword (ConvertTo-SecureString -AsPlainText $MotDePasse -Force)  `
                   -ChangePasswordAtLogon $true  `
                   -Enabled $true

	# Création du dossier a son Nom.

	New-Item -Path $Dossier  `
                 -Name $Nom  `
                 -ItemType Directory

	# Partage du dossier.

    	New-SmbShare -Name $ShareName  `
                     -Path $SharePath  `
                     -ChangeAccess $ToutleMonde

        # Désactive l'héritage tout en copiant les autorisations NTFS héritées.

        Get-Item $NTFSShare | Disable-NTFSAccessInheritance

        # Ajout de l'autorisation "Modifié" NTFS pour l'utilisateur.

        Add-NTFSAccess -Path $NTFSShare `
                       -Account $Email `
                       -AccessRights Modify

        # Modifier le proprietaire sur le dossier.

        Set-NTFSOwner -Path $NTFSShare `
                      -Account $Email

        # Suppression des autorisations NTFS du groupe Utilisateurs.

        Remove-NTFSAccess –Path $NTFSShare `
                          –Account $Utilisateur `
                          -AccessRights FullControl

	# Message de création

	Write-Host -fore Green "REUSSITE - Création de l'utilisateur : $Profil"
	}
}
# Sinon affiche le resultat de l'erreur.

Catch{
       
      Write-Warning "ECHEC - Une erreur est survenue :`n $($Error[0])"   

}
# Finalement message de fin.

Finally{     

      Write-Output "Merci d'avoir utilisé ce Script"
}