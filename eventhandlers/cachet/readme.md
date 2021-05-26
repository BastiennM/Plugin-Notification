
![](https://lh6.googleusercontent.com/h_pTYUp7w3t-wyD-67Fhh5ukO8wUeYw9Q57jtEHDnO5p566tQMefS4ssx7S7hNgPfT2OGwANdLby_Md3WKWtsao5VnfzZIBZfN77znH4Xbthdb0NBJ8qwhjV-azNGdwuiFNBhFDn)


# Introduction

Le plugin d’alert CachetHq permet de mettre à jour automatiquement le statut des composants cachet, afin de performer un affichage clair sur la vue public.

.

# Utilisation

  
Le plugin permet de mettre à jour le statut d’un composant Cachet, pour cela il faut renseigner dans la commande les arguments suivants :

  
  
| Argument | Macro  | Obligatoire |
|--|--| --|
| hostname | Adresse IP ou lien du cachet | Oui |
| proto| protocole à utiliser lors de la requête | Non (par défaut https)|
| api-key| Clé API de votre compte cachet | Oui |
| component-id | ID de votre composant | Oui |
| component-status | Statut du composant | Oui |
| name| Nom de l’incident | Non |
| urlpath | Chemin vers cachet | Non (par défaut /) |
| port | Port du cachet | Non (par défaut 8000) |
| status | Statut de l’incident | Oui |
| language| Langage du message | Non (par défaut français) |
  



## Exemples:

Mise à jour du composant portant l’id numéro 2 avec un statut “Opérationnel”:

    ./centreon_plugins.pl --plugin=eventhandlers::cachet::plugin --mode=alert --hostname="xxx.xxx.xxx.xxx" --proto="http" --api-key="BDDOsCRvGOIOf85HU2xQ" --component-id="2" --component-status="0" --status="1" --message="Message de l’incident" --name="Nom de l’incident"

  

### API-key:

Votre clé API se trouve sur le dashboard Cachet dans l’onglet “user”.

  

![](https://lh3.googleusercontent.com/rZGMilP2IL6J4wkFur8GANcJXWRnVv5kP-4lyG-H9n2TzZEjneQdN6SIYFu4jsec9FePh9Og1RIXUeEW64lC_gTIQMowLA6-TEBwnOoeB-dq977aLFRPxCEqpCSfyjx0xk0SgTFK)

  

### Component-id:

L’id du composant Cachet est récupérable sur le composant concerné dans son URL

  

![](https://lh3.googleusercontent.com/2CyxaugigTDrkpb-bk4VTNnLuTTwwg8MyVgXKlXU0e2frSLQrkSZ-poF3Hn6ZZZ0fG54mKLBOX3xD_1fg6jxS2znCz9CTENE_eoJxTtl_w2iEg3njX55u9S-AZ6CJWS8q1TLJUhM)

  
  
  

### Component-status:

Le statut du composant correspond à des entiers allant de 0 à 3 avec pour chaque état les correspondances suivantes :

  
| component-status | Centreon | CachetHQ|
|--|--| --|
| 0 | OK | Opérationnel |
| 1 | WARNING| Problème de performance|
| 2 | CRITICAL | Panne partielle |
| 3 | UNKNOWN | Panne majeure|

### Name:

| component-status | Message |
|--|--|
| Opérationnel | Le service fonctionne normalement|
|Problème de performances | Problème de performances|
|Panne partielle | Panne partielle|
|Panne majeure |Panne majeure|


Le nom de l’incident  affiché est défini par défaut par le status du composant:

Il peut être modifié ensuite grâce à l’argument --name.

  
### Message:

Le message affiché est défini par défaut par le status du composant:

| component-status | Message |
|--|--|
| Opérationnel | Aucun problèmes détecté|
|Problème de performances | Nous rencontrons quelques problèmes de performances|
|Panne partielle | Une panne partielle à été détecté, nos équipe sont averti et travaillent à le régler|
|Panne majeure |Une panne majeure à été détecté, nos équipe sont averti et travaillent à le régler|
  

Il peut être modifié ensuite grâce à l’argument --message.

### Status:

Correspond au statut de l’incident, il en possède quatres différents, chacun des chiffre correspond à son statut:

  
| Status | Icône | Signification|
|--|--|--|
| 1 | ![](https://lh3.googleusercontent.com/9Q8nFiaFaAzJxTbm17FhFRPIfuOWAO8ISSx1sCtB8AmAczzhPiYI-pCJTXNUCKkhbUf5NHTVp6qtJ2bay1F4N4-2iGq7lP9Tm7lW55oPjFEi9z0Rl9kEamQXuCxGgv_4rMEIGCha) | Enquête en cours|
|2|![](https://lh6.googleusercontent.com/zNVssNExVC2zwlipxCoBz4XOIWk7zYC1UmT5egIp_aALO9kIsoKIeag2D_bb3RelFYzQRtYTg4KOwvoooIJ7Iuo7CwWEcvmmQabHt88BH2tqpqhjSYWxvvG95ndxpmB6Ms0c-hff)|Identifié|
|3|![](https://lh6.googleusercontent.com/ht5C2y5AyHyYAmMdd-xLTDpxr4lIozvxmcpjT0IVna8GS8KKjKpQ2eDhbaTPhwTWn3T-kBmlyMrVxvgLZKzsX5QTInzUv4XcO4b3fLS0kCq43G2r-hX0I1ONWZ8ztPWtNQIge4va)|Sous surveillance|
|4|![](https://lh6.googleusercontent.com/HpXBGuXUDzCELW-OQ9BrYvUo-TVHa_HcOoxvMxAXhvEpaMDOyZP-VHmZWXH2hOmmCSZkvQtxf1NBoIQNsyhg1_kUeBQh3QoErbei0XLK533QJS6rW6-Fg2gPRvKk746fSyARHzuz)|Corrigé|

Il est par défaut attribué au 1er statut, c’est à dire “Enquête en cours”


### Language:

  

Grâce à l’argument --language, vous pouvez sélectionner la langue d’affichage de vos messages sur la vue client.

  

Les valeurs ci-dessous sont des valeurs par défaut et seront écrasées si l’argument --message où --name est appelé.

Ils fonctionnent indépendamment, vous pouvez donc ne remplacer qu’un des deux sans écraser la valeur par défaut du deuxième

  

    my %cachet_message = (
	    "fr" => {
		    1 => {
		    name =>  "Tout va bien",
		    message =>  "Aucun problèmes détecté"
		    },
		    2 => {
		    name =>  "Probleme de performances",
		    message =>"Petit problème de performances"
		    },
		    3 => {
		    name =>"Panne partielle",
		    message =>"petite panne"
		    },
		    4 => {
		    name=>"Panne majeure",
		    message=>"grosse panne"
		    }
		}
    );  

Dans le cas où vous souhaitez ajouter une langue, il vous faut copier le code ci-dessus et le rajouter en changeant la langue et les messages affichés.
