# Projet07

Bienvenue sur le GitHub du Projet 7 "Créez des services partagés en entreprise et automatisez des tâches".

Je publie ici huit scripts rédigés sur Windows Server 2019 avec Powershell ISE.

Script 1: Créer un nouvel utilisateur ainsi qu'un dossier partagé à son nom (Projet07_Nom_Script01.ps1) (Script Interactif)

Script 2: Lister les membres d'un groupe (Projet07_Nom_Script02.ps1) et extraire le résultat dans le fichier "Projet07_Nom_AD02.txt" (Script Silencieux)

Script 3: Récupérer la liste des groupes dont un utilisateur est membre (Projet07_Nom_Script03.ps1) et extraire le résultat dans le fichier "Projet07_Nom_AD03.txt" (Script Silencieux)

Script 4: Sauvegarde quotidienne de nuit des données de chaque poste client dans un dossier c:\SAV\ dédié sur le serveur (Projet07_Nom_Script04.ps1).

Fichier à fournir:

Script 5: Exportation de la liste des Utilisateurs (Projet07_Nom_AD05.txt).

Script 6: Exportation de la liste des Groupes(Projet07_Nom_AD06.txt).

Script 7: Exportation de la liste des dossiers partagés(Projet07_Nom_AD07.txt).

Script 8: Exportation de la liste des imprimantes installées et partagées(Projet07_Nom_AD08.txt).


# Etapes à suivre :

Script 1: Il suffit de rentré les informations demandés nom, prénom, login, email, mot de passe, chemin du dossier. Une fois saisi, le ou les utilisateurs seront ajoutés au sein de l'AD.

Script 1xlsx: Les données fournies sont dans un fichier .xlsx. Il est demandé de saisir le chemin du fichier .xlsx, un mot de passe et le chemin du dossier. Une fois saisi, le ou les utilisateurs seront ajoutés au sein de l'AD.

Script 2: Il est uniquement demandé à l'utilisateur d'entrer le nom d'un groupe. Le script génère donc la liste des utilisateurs du groupe et envoie le résultat dans un fichier .txt

Script 3: Comme pour le second script, il est demandé de rentrer cette fois-ci, le nom de l'utilisateur faisant partie de plusieurs groupes.

Script 4: Ce dernier script est silencieux, il ne demande donc aucune intervention de l'utilisateur. Il s'exécute automatiquement lors de la fermeture de session d'un utilisateur ou par GPO de planification.

Script 5/6/7/8: Comme pour le second script, mais cette fois il est demandé d'extraire la liste des utilisateurs, des groupes, des dossiers partagés et les imprimante partagées.

! Plus d'explications dans les fichiers .ps1 dans les commentaires précédés d'un # !
