
# Bienvenue dans le projet OpenStack Install Scripts sur GitHub

Ce projet vise à convertir les étapes du guide d'installation d'OpenStack en scripts utiles / simples. Le but n'est pas de fournir une solution d'automatisation parfaite . Mais l'idée est d'avoir des blocs de construction simples qui peuvent aider les développeurs et les passionnés à expérimenter OpenStack de manière beaucoup plus simple.

#### Plateforme prise en charge - Serveur Ubuntu 17.04 et 16.04
#### OpenStack version - Ocata

#### Prerequisites ####

 Les binaires _git_ doivent être installés sur votre serveur Ubuntu. Ceci est nécessaire pour récupérer les scripts sur votre serveur Ubuntu. 

Si vous utilisez VirtualBox, reportez-vous à ce blog pour les paramètres réseau - http://goo.gl/VTJVmv

#### Services OpenStack installés ####

Les services OpenStack suivants sont installés dans le cadre de ces scripts:

1. Keystone (Identity)
2. Glance (Image)
3. Nova (Compute)
4. Neutron (Networking)
5. Horizon (Dashboard)

#### Important Notes ####

1. Le script installe les packages Linux Bridge par défaut. L'installation d'OVS peut être effectuée à l'aide d'un script utilitaire fourni dans le répertoire `lib` .
2. De nombreux scripts détectent automatiquement le type de nœud OpenStack à l'aide du script `util/detect-nodetype.sh` .
3. Le contrôleur de type de nœud comprend des capacités de nœud de réseau. Il s'agit d'un nouveau comportement dans OpenStack depuis la version Liberty..
4. VXLAN est le type de réseau client par défaut utilisé.
5. Dans Ocata Nova, il prend en charge le module cellule (Cells) par défaut. Pour ajouter des nœuds de calcul pour la planification, vous devrez peut-être exécuter `nova-manage cell_v2 discover_hosts --verbose` sur le contrôleur.

## Comment utiliser les scripts étape par étape ##

1. Editer le fichier lib/config-parameters.sh 
   - Important: assurez-vous que les noms d'interface de gestion et de plan de données sont exacts.. 
   - Facultatif: modifiez le nom d'hôte à utiliser pour le contrôleur. Ce nom sera utilisé dans tous les fichiers de configuration. 
   - Facultatif: modifiez les mots de passe si nécessaire 

2. Installer les packages OpenStack en fonction du type de nœud
   - Si le nœud est de type contrôleur, exécutez la commande `sudo bash install.sh controller`
   - Si le nœud est de type compute, exécutez `sudo bash install.sh compute`

3. Configurez les packages OpenStack à l'aide de `sudo bash configure.sh <controller_ip_address>`. The **type de noeud** est détecté automatiquement.

4. Les actions de post-configuration peuvent être déclenchées à l'aide d'un script `sudo bash post-config-actions.sh` sur le nœud de contrôleur uniquement. Ce script interactif effectue les opérations suivantes:

   - **Nouveau dans Newton / Ocata:** créez des Flavours pour les instances. **Newton / Ocata n'est livré** avec aucune saveur par défaut
   - Active la vue basée sur un navigateur Web des fichiers journaux Nova et Neutron.
   - Télécharge et crée une image Cirros Glance pour démarrer les VM.
   - Crée deux réseaux OpenStack et leurs sous-réseaux

## Scripts utiles - Mise à jour de l'adresse IP ##

En cas de modification de l'adresse IP du contrôleur, utilisez le script `util/update-ip.sh` pour vous assurer que tous les paramètres de configuration sont mis à jour. Cette commande doit être exécutée sur le contrôleur ainsi que sur les nœuds de calcul.

Utilisation: `sudo bash util/update-ip.sh <management-interface-name> <controller-host-name> <controller-ip>`. Les deuxième et troisième paramètres sont utilisés pour les nœuds de réseau et les nœuds de calcul.

## Suppression des packages OpenStack ##

Vous pouvez supprimer tous les packages OpenStack en utilisant `sudo bash remove.sh`. Le type de nœud est détecté automatiquement et les packages correspondants sont supprimés.

## Redémarrage des services OpenStack ##

Le redémarrage des services OpenStack est parfois nécessaire, en particulier lorsque les entrées du fichier de configuration sont modifiées. Vous pouvez exécuter `sudo bash manage-services.sh` pour le faire. Le type de nœud est détecté automatiquement.

## Mise à jour du fichier /etc/hosts ##

Puisque toute configuration utilise le nom de l'hôte du contrôleur, il est important de mettre à jour le fichier `/etc/hosts` sur tous les nœuds pour mapper une adresse IP sur le nom d'hôte du contrôleur. Vous pouvez utiliser le script `util/update-etc-hosts.sh` à cet effet.
