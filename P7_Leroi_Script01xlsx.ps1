# Contenu de Projet07_Leroi_Script01xlsx.ps1
# Date : 20.02.2022
# Version 1.3 - Leroi Cyrille
# Révisions : 
# - 1.3 : Ajout gestion des autorisations NTFS
# - 1.2 : Ajout blocs Try/Catch
# - 1.1 : Ajout filtre : Vérifier la présence de l'utilisateur dans l'AD 
# - 1.0 : Création d'utilisateurs avec un dossier partagé


###### Scripts de création des utilisateurs avec un dossier partagé a leur nom.


### Les droits sont gérez par les Permissions NTFS.
## L'utilisateur est le propriétaire et a un accès de Modification a son dossier.
## Les droit de partage sont attribuez pour Tout le monde en Modification.

### Attention même mot de passe pour TOUS!!!
## Décommenter les 2 lignes marqué ###### si vous souhaitez ajouter un utilisateur à la fois. 

#### Taper les commandes suivantes avant de continuer :
## Pour autoriser l'execution du script.

# Set-Execution Policy Unrestricted 

# Pour importer le module Active Directory.

# Import-Module ActiveDirectory 

# Pour importer le module NTFSSecurity.

# Import-Module NTFSSecurity

# Pour importer le module ImportExcel.

# Import-Module -Name ImportExcel



######## Editer le ficher Utilisateurs XLSX.

### Chant a remplir OBLIGATOIREMENT :
## Nom, Prénom, Site, Actif, Service, LoginNT, Email, NomR 

###################################################################################

# Demande le nom de l'utilisateur présent dans le fichier XLSX.

#$Username = Read-Host "Rentrer le Nom et Prénom de l'utilisateur à créer"           ######

# Importe les données du fichier XLSX.

$XLSXFile = Read-Host "Merci de rentré le chemin du fichier"
$XLSXData = Import-Excel -Path $XLSXFile `
                         -StartRow 5 `
                         -WorksheetName "MainBase" `
                         -DataOnly #| Where-Object{ $_.NomR -like "$username*"}      ###### avant | (Pipe)
                                                  
# Demande le mot de passe de l'utilisateur.

$Password = Read-Host "Merci de rentré le Mot de Passe de l'utilisateur"

# Demande le chemin de destination du dossier.

$Sauvegarde = Read-Host "Merci de rentré le chemin de destination du dossier        Exemple : C:\SAV\exemple\   "


# Boucle dans le fichier XLSX.

Foreach($User in $XLSXData){

    # Préparation des variables.

    $UserNom         = $User.Nom
    $UserPrenom      = $User.Prénom
    $UserSite        = $User.Site
    $UserActif       = $User.Actif
    $UserDesactive   = $User.Désactivé
    $UserFonction    = $User.Fonction
    $UserDepartement = $User.Département
    $UserService     = $User.Service
    $UserNote        = $User.Note
    $UserTel2        = $User.Tel2
    $UserMobile      = $User.Mobile
    $UserLogin       = $User.LoginNT
    $UserDel         = $User.Détruit_le
    $Useremail       = $User.email
    $UserAlias1      = $User.Alias1
    $UserCritique    = $User.Critique
    $UserPhysique    = $User.Physique
    $UserNomComplet  = $User.NomR
    $OUService       = "OU=$UserService,OU=$UserSite,DC=acme,DC=fr"    
    $UserSave        = $UserLogin + '$'
    $UserHomeDrive   = "\\$env:COMPUTERNAME\$UserSave"    
    $SmbShare        = $Sauvegarde + $UserNom
    $GroupeGlobal    = "GG_" + $UserService
    if ( $UserCritique -match "Oui" ){ $UserCritique = "Critique" }
    $Description    = "$UserNote $UserAlias1 $UserDesactive $UserDel $UserCritique $UserPhysique" 
    if ( $UserActif -match "Oui" ){ $UserActif = $True  } 
    if ( $UserActif -match "Non" ){ $UserActif = $False }  
    
    # Essayer cette commande.

    Try{
	
### Vérifier la présence de l'utilisateur dans l'AD sinon le créer.

      # Filtre les utilisateurs existants.

      $user = "SamAccountName -Like ""*$UserLogin*"""
      $Users = @{Filter = $user}

      if (Get-ADUser @Users){

         # Affiche un message si l'utilisateur est deja enregistré.

         Write-Host -fore Yellow "L'identifiant $UserNomComplet existe déjà dans l'AD"
         }
         else{      

         # Ajout de l'utilisateur.

         New-ADUser -Name $UserNomComplet `
                    -DisplayName $UserNomComplet `
                    -GivenName $UserPrenom `
                    -Surname $UserNom `
                    -SamAccountName $UserLogin `
                    -UserPrincipalName $UserEmail `
                    -EmailAddress $UserEmail `
                    -Title $UserFonction `
                    -Department $UserDepartement `
                    -Office $UserFonction `
                    -Organization $Userdomain `
                    -Type $UserType `
                    -OfficePhone $UserTel2 `
                    -MobilePhone $UserMobile `
                    -Description $Description `
                    -HomeDrive 'Z' `
                    -HomeDirectory $UserHomeDrive `
                    -Path $OUService `
                    -Enabled $UserActif `
                    -AccountPassword(ConvertTo-SecureString -AsPlainText $Password -Force) `
                    -ChangePasswordAtLogon $true 
                    
          # Celle-ci est pour l'ajouter a son groupe. 

          Add-ADgroupMember -Identity $GroupeGlobal `
                            -Members $UserLogin 

          # Celle-ci est pour la création du dossier a son Nom.

          New-Item -Path $Sauvegarde `
                   -Name $UserNom  `
                   -ItemType Directory

          # Celle-ci est pour le partage du dossier.                    

          New-SmbShare -Name $UserSave `
                       -Path $SmbShare `
                       -FullAccess $UserLogin

          # Désactiver l'héritage tout en copiant les autorisations NTFS héritées.

          Get-Item $SmbShare | Disable-NTFSAccessInheritance

          # Celle-ci est pour l'autorisation "Modifié" NTFS.

          Add-NTFSAccess -Path $SmbShare `
                         -Account $UserEmail `
                         -AccessRights Modify

          # Modifier le proprietaire sur le dossier.

          Set-NTFSOwner -Path $SmbShare `
                        -Account $UserEmail

          # Supprimer des autorisations NTFS du profil Utilisateur.

          Remove-NTFSAccess –Path $SmbShare `
                            –Account "Utilisateurs" `
                            -AccessRights FullControl
          
          # Message de création

	      Write-Host -fore Green "Création de l'utilisateur : $UserNomComplet"

          # Netoyage des variables.

          Clear-Variable User* -Force
    
          }
      }

      # Sinon affiche le resultat de l'erreur.

      Catch{
       
      Write-Warning "ECHEC - Une erreur est survenue :`n $($Error[0])"   

      }

} #Foreach($User in $XLSXData)

# Message de fin.

Write-Output "Merci d'avoir utilisé ce Script"

