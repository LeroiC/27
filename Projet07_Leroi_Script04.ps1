# Contenu de Projet07_Leroi_Script04.ps1
# Date : 10.03.2022
# Version 1.0 - Leroi Cyrille

### Script de Sauvegarde quotidienne de nuit ###

# Copie les fichiers de l'utilisateur dans sont dossier personnel.

<# L'environnement GetFolderPath est une valeur dynamique qui permet de définir l'emplacement d'un répertoire d'un utilisateur actif.
    
    Description des options :

    /D = Copie les fichiers modifiés à partir de la date spécifiée.
    /E = Copie les répertoires et sous-répertoires, y compris les répertoires vides.
    /R = Remplace les fichiers en lecture seule.
    /S = Copie les répertoires, sauf s'ils sont vides. Si vous omettez /S, xcopy fonctionne dans un répertoire unique.
    /I = Si la destination n'existe pas et que plus d'un fichier est copié, considére la destination comme devant être un répertoire. 
    /C = Continue la copie même si des erreurs se produisent.
    /Z = Copie les fichiers du réseau en mode redémarrable.
    /Y = Supprime la demande de confirmation de remplacement de fichiers de destination existants. Peut être pré-réglé dans la variable d'environnement COPYCMD.

 Créer une GPO pour exécuter automatiquement le script
 Example 1:
 Cette GPO se trouve dans: Utilisateurs/Stratégies/Paramètres Windows/Script (ouverture/fermeture de session), puis dans l'onglet "Script Powershell".
 Example 2:
 Cette GPO se trouve dans: Utilisateurs/Préférences/Paramètres du Panneau de configuration/Tâches planifiées , Nouveau/Tâches planifiées ;
 Renseigner le Nom de la tache , Executé : "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" , Arguments :le chemin du script , puis dans l'onglet "Planifié".
#>

# Variable de Source.

$SourceDisk = [Environment]::GetFolderPath("UserProfile")
 
# Variable de Destination.

$DestinationDisk = "$env:HOMESHARE\$env:USERNAME"

# Commande copie de fichiers.

XCOPY $SourceDisk $DestinationDisk /D /E /R /I /C /Z /Y

####### Merci d'avoir utilisé ce script #######

