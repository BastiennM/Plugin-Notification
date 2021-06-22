![](https://lh3.googleusercontent.com/hO6UoC8Q6B93662X1JpNTb4GlmlNcXNSnq9u61jwRhU9wL5LcmGkjaBxJ4xndrG70bSl5VPMppPLx8kFvpj17eQRmFy0Zm2uE23zRGKICnJxPxjKFEjXBpNoFOxt77A7P3LpdtoT)


# Introduction

Le plugin d’alert Mattermost permet de notifier via un message l’état des hôtes / services.

.
# Creation du bot
# Création du bot

Pour créer un bot il faut vous rendre dans Integration > Bot account > Add Bot Accounts
 

![](https://lh4.googleusercontent.com/k-LEaMo4TzoNjwdFGI5d6lUjnWlXSRUZqEWadnD5OgP8bFBjvSMIGvceW2GgKdOa7V3omsAlbdYYm0Xt5pKhDkzVV06gIAXNy8swABfMKfnyzM3Xg4l7_OFMwcyLt2WTD2CK5hyS)

  

Une fois le bot créer il vous faut récupérer son Bearer token :

![](https://lh3.googleusercontent.com/yUCmwVcmvlAlNGfpYuHV-asxCtYTNJ0AN0fsZD-jwRjQeYxsfmKmf5ScWqt-x5dvbFujGtb0cm_ywvdAepLkq8FZ8S3j7rk7kgA5RN4KHAxGq82C4tHbVO4e6qJPYcxEMggK_PC_)

Veillez à bien le noter car une fois la fenêtre fermée il n’y a plus moyen de la récupérer.

# Arguments

  
Liste des argumetns du plugin :
  
| Argument | Macro  | Obligatoire |
|--|--| --|
| hostname | Adresse IP ou lien de mattermost | Oui |
| port| Port de mattermost | Non|
| proto| Protocole à utiliser lors de la requête | Non (par défaut http)|
| urlpath | Chemin vers mattermost| Non (par défaut /api/v4/post)|
| channel-id | ID du channel mattermost | Oui |
| bearer-token|Bearer token du user qui envoie les notifications | Oui|
| service-description| Description du service | Non  |
| service-state| État du service | Non |
| service-output| Output du service qui sera affiché |  Non|
| host-name| Nom de l'hôte | Non |
| host-state| État de l'hôte | Non  |
| host-output| Output de l’hôte qui sera affiché | Non |
| notification-type| Type de la notification | Non |
| link-url| Lien du rapport de l'incident | Non |
| time|Date et heure à laquelle l’incident est survenu | Non |

### Channel-id:

L’id de votre channel se trouve dans les infos du channel

  

![](https://lh6.googleusercontent.com/wYPklpPNFqKHtMyHRunbK2X4cp7NHvbYTMDACiXdhwNnuwqXXzSiOBE6YKA9ypqy4gvIHLsufOlg5078DGJF9lqLcOswqcEUof4FsNv_ZlyrC0fs49zdcf444eLyW9DyE73UUelH)

  

### Bearer-token:

Se référer à la création du bot

### Service-description:

Une description du service qui s'affiche à l’endroit suivant sur la notification :

### ![](https://lh4.googleusercontent.com/ssiZbYF3VJtpW1xxPRoNlEra8887v2DuQYwgE3IV7tNATNqmY528LZSmo6_4RJ1ERdK4JHqPMYuoh8CGGK8z938Ya1AJilXyeiWwX9Jhuzkovj0LV_bdM6ALMm0GxfcfjCyE9c9k)

### Service-state:

  

État du service, correspond au cas par cas à un icône et un bandeau de couleur sur le côté gauche permettant de visualiser rapidement l’état.
| service-state| Icône | Couleur |
|--|--| --|
| ok|![](https://lh3.googleusercontent.com/5ZMo4SCZMxFdlRZ8sPcFnjZNekfATdo3U14ftphJo1IJj2WVWmTsNB6JM0OD8TK9j3RGAgLUXxJQKqKv8430NkHqA9z_1f7mcTlvCZjiqzBjc4zGuAimkIYvcK4IOI0GC0EB26Px) | ![](https://lh6.googleusercontent.com/n58rhhwH-9PPuaVWZOeW0R8dIDekZkIbpp8GRj2lxp7CffF5ppwl4l2ciwQ82opb_IHHR762nqhC5uU6bQIXLhXQiv7hYit1SAwzuCZLsEYyYIBtqYgsDHZrCtyYubxkFYYEJvyu)|
| warning |![](https://lh3.googleusercontent.com/99Mq0iApfe8-MqAKd4tm9gAneCBB1V1etoxE2V4QFNIAkan565zALkS4VxS07Mjn1JdS73tp2NwFXuhKncywCGNPWADo4vBwaS4vQqcCSAVGN4DygoJSgibOw-gEVGQ_QTjwgQcH) | ![](https://lh5.googleusercontent.com/4PPu6K8bPDJI-_-en-8q8keUE6JUNvwBHpaWnb83u9aa6iDqTxQAFyw-Ts98ETOL-J6iQbcqLYbKbihCylzsQsewvrMRSqXARsfLQGr8KqmfSqcSyRV1X2-XR8d8RZvbhotHnMh3)|
| critical |![](https://lh3.googleusercontent.com/wYzxzlL00xdJVXv6cSsBOUuHj_GNtmiDJOoz3AWFhxTgSIeOqpSt3Zvm6cSeR69OZDVGWBkIyt9RhDFhIf7lZLaYASU7PWf9kCaEOVYIld7GZAYvt44EzDDfhh1BD0uUKb9KGDXF) | ![](https://lh3.googleusercontent.com/n8Jz1mlJ_YEUg5dW3uUOZ6SFnD9x4YmHSUwUFFd7wpQzvxhUKB5POMvjv_RnQdysuPZzj9Ko1xCWUQXW3F4n-O98AWyT8RVJpQ6v_8Vcc8hzlrvarZLdiTlEDAg1aXQHmi8IAOjx)|
| unknown| ![](https://lh6.googleusercontent.com/lLxxn9aM07SMliTFkAvhw8BWUxrBYi2vFjcpaAMAWz-K4TW3Zl2T6iyx0eP0zWMf1TiXShH-DHDpCJHM2IHySWL7t5EySOfU3OK0P-Y6FrznpoFIWsDiRuj7qx384d3XndXrZSaL)|![](https://lh5.googleusercontent.com/bZdiBiZfyvEYYA8i-SRAttzIPSDc8biDOiBGn8gVuBA5JiwO1tZD_Tenk3BVYB0-j_U_p_XLwQUUwwsoCZgkBIP8qapfQPqzUWDmbiN_fXyAhuOahXDg0drcg3nPnHvj4MnkrMOg) |

Il s’affiche à l’endroit suivant sur la notification :

![](https://lh5.googleusercontent.com/KIlKnLtT8w47hOBKp8epsdJxAvBZkrkiYPkAY6jGxTuqiZlj80ao_-4l3YMlplSbuc7ySWrCTaOXe0Yupz47c69iAstLyRYKFoKujxXoHoCgk5NcajBRwgJ2yZO2-pIS4J74fE5F)

  

### Service-output:

Message qui s’affiche à l’endroit suivant sur la notification : ![](https://lh3.googleusercontent.com/ssVPnNQ_ZuFKxZOR0Yl5zHmu5pneks-5VOyqh9iE5XjfYFSzPvQqSyQ1KbJYl7SCPjGySQ_WqvBto1wCOdIhIT5-n3IAE_oIGvSAJbf6lI14wEAqt-iJgm20zH-XjFbn7ylKssvN)

  

### Host-name:

Correspond au nom de l’hôte qui sera affiché à l’endroit suivant :

  

![](https://lh5.googleusercontent.com/9-5fGrmTe_WXN3LWWLxr5G9tOpkofrVsrh98fJul4K2F9obluv-gjLoqr4vZ9Puzgl4pJ31Ndh0HBPgk8hSy0ATzMDUt2gvSwLPmGkO0MWVhDThRA5mXZqXbtnlD1UArb13s4i1O)

  

### Host-state:

État de l’hôte qui correspond au cas par cas à un icône et un bandeau de couleur sur le côté gauche permettant de visualiser rapidement l’état.

  | host-state| Icône | Couleur |
|--|--| --|
| up|![](https://lh3.googleusercontent.com/5ZMo4SCZMxFdlRZ8sPcFnjZNekfATdo3U14ftphJo1IJj2WVWmTsNB6JM0OD8TK9j3RGAgLUXxJQKqKv8430NkHqA9z_1f7mcTlvCZjiqzBjc4zGuAimkIYvcK4IOI0GC0EB26Px) | ![](https://lh6.googleusercontent.com/n58rhhwH-9PPuaVWZOeW0R8dIDekZkIbpp8GRj2lxp7CffF5ppwl4l2ciwQ82opb_IHHR762nqhC5uU6bQIXLhXQiv7hYit1SAwzuCZLsEYyYIBtqYgsDHZrCtyYubxkFYYEJvyu)|
| down |![](https://lh3.googleusercontent.com/wYzxzlL00xdJVXv6cSsBOUuHj_GNtmiDJOoz3AWFhxTgSIeOqpSt3Zvm6cSeR69OZDVGWBkIyt9RhDFhIf7lZLaYASU7PWf9kCaEOVYIld7GZAYvt44EzDDfhh1BD0uUKb9KGDXF) | ![](https://lh3.googleusercontent.com/n8Jz1mlJ_YEUg5dW3uUOZ6SFnD9x4YmHSUwUFFd7wpQzvxhUKB5POMvjv_RnQdysuPZzj9Ko1xCWUQXW3F4n-O98AWyT8RVJpQ6v_8Vcc8hzlrvarZLdiTlEDAg1aXQHmi8IAOjx)|
| unreachable| ![](https://lh6.googleusercontent.com/lLxxn9aM07SMliTFkAvhw8BWUxrBYi2vFjcpaAMAWz-K4TW3Zl2T6iyx0eP0zWMf1TiXShH-DHDpCJHM2IHySWL7t5EySOfU3OK0P-Y6FrznpoFIWsDiRuj7qx384d3XndXrZSaL)|![](https://lh5.googleusercontent.com/bZdiBiZfyvEYYA8i-SRAttzIPSDc8biDOiBGn8gVuBA5JiwO1tZD_Tenk3BVYB0-j_U_p_XLwQUUwwsoCZgkBIP8qapfQPqzUWDmbiN_fXyAhuOahXDg0drcg3nPnHvj4MnkrMOg) |

Il s’affiche sur la notification à l'endroit suivant :

![](https://lh5.googleusercontent.com/EZ1iGxMX7ySAfZtk1qj8TNz_RA9aQRtYDi8byKgHQ5vjE2xrKkMYjULmoAs-1rHMgfqQQsnFPBxXLWl15OW69qVRkQlROAkjrzVLrPLYBsnhx4YzC8KMIixppYdhYrqLn7DWDlnt)

  
  

### Host-output :

Message qui s’affiche sur la notification à l’endroit suivant:

  

![](https://lh6.googleusercontent.com/dluKqeOOJLBFkhUVnbIlPTnFjLQ8yydOA18ipbc5UpgalUk3edTR8I3lpRDHwA2oHcFi63639IwzXB9LHqX60GuEUpFo6fAP5e-lJt6XIyoxzRsJZEhxCWmcjUASmGXclVuHUPP7)

  

### Notification-type :

  

Type de notification qui s’affiche sur la notification à l’endroit suivant :

  

![](https://lh3.googleusercontent.com/lF0Dp_HwJVCUGwC3ffMrtQYGtLqCMN2cnZkPZUojrnnJzMlN3lYLmlT8Tb_V1Y3s0xSEGf_v-V61vEEU_VJ7g1QgtwSSbWks7QGjm3YthPbvjPpgyAk3eRI54TMtAMEZz4f2IhHR)

  

### Link-url :

  

Lien qui redirige vers le rapport de l’incident :

  

![](https://lh3.googleusercontent.com/uRO60D92t5_-lJEL8-t3eZFKoVBIOoskUdljwDho7HkiiLCPpfUYwOTA03xrXpHkr67CFRkcXvLW1hHiJa7Wm9DY2pmVKQ0q0N4ZPnTtGRxQs154bD_98dDLHzGyrfHbBC-77yJX)

  

### Time:

  

Heure / Date qui s’affiche sur la notification :

  

![](https://lh4.googleusercontent.com/xgF2VlsMAdGmLKgVLlkMqJbC7Ba-DAm_LVEmzUvtf9uX4glLG3IphUMAu9ibFP304iZ64jU1YqNCkPEZu0ZL5Meq-RuWxhgYrUIpl6jjgscWmygHXSmrvJVVvq4Nv0n12ujvrbLq)

  
  
  
  

# Exemples :

  

## En ligne de commande :

### Service :

  

Envoi d’une notification à mattermost sur l’état d’un service (arguments statiques) :

  

    ./centreon_plugins.pl --plugin=notification::mattermost::plugin --mode=alert --hostname=192.168.73.108 --channel-id="74i544t69idupcb39mjonnrzma" --port=80 --proto="http" --bearer-token="ou44jg7jr3fwxkr54zmrrs1zso" --host-name="AMQ001" --service-state="CRITICAL" --service-description="Broker state" --service-output="Unable to connect to the Broker (Timeout)" --link-url="https://www.google.fr" --notification-type="PROBLEM"

  

### Hôte :

Envoi d’une notification à mattermost sur l’état d’un hôte (arguments statiques) :

  

    ./centreon_plugins.pl --plugin=notification::mattermost::plugin --mode=alert --hostname=192.168.73.108 --channel-id="74i544t69idupcb39mjonnrzma" --port=80 --proto="http" --bearer-token="ou44jg7jr3fwxkr54zmrrs1zso" --host-name="AMQ001" --host-state="DOWN" --host-output="Ping timeout" --link-url="https://www.google.fr" --notification-type="PROBLEM"

  

## Depuis centreon :

  

### Service :

Envoi d’une notification à mattermost sur l’état d’un service (arguments dynamiques) :

  

    /usr/lib/centreon/plugins/centreon-plugins/centreon_plugins.pl --plugin=notification::mattermost::plugin --mode=alert --hostname=192.168.73.108 --channel-id="74i544t69idupcb39mjonnrzma" --port=80 --proto="http" --bearer-token="ou44jg7jr3fwxkr54zmrrs1zso" --host-name="$HOSTNAME$" --service-state="$SERVICESTATE$" --service-description="$SERVICEDESC$" --service-output="$SERVICEOUTPUT$" --link-url="www.google.com" --notification-type="$NOTIFICATIONTYPE$"

### Hôte :

Envoi d’une notification à mattermost sur l’état d’un hôte (arguments dynamiques) :

    /usr/lib/centreon/plugins/centreon-plugins/centreon_plugins.pl --plugin=notification::mattermost::plugin --mode=alert --hostname=192.168.73.108 --channel-id="74i544t69idupcb39mjonnrzma" --port=80 --proto="http" --bearer-token="ou44jg7jr3fwxkr54zmrrs1zso" --host-name="$HOSTNAME$" --host-state="$HOSTSTATE$" --host-output="$HOSTOUTPUT$" --link-url="www.google.com" --notification-type="$NOTIFICATIONTYPE$"

### Lien de rapport :

Si vous souhaitez ajouter un lien de rapport vers centreon il vous suffit de rajouter l’argument --link avec le lien suivant :

  

Service URL:

  

    [urlcentreon]/centreon/main.php?p=20201&o=svcd&host_name=$HOSTNAME$&service_description=$SERVICEDESC$

  

Host URL:

  

    [urlcentreon]/centreon/main.php?p=20202&o=hd&host_name=$HOSTNAME$

