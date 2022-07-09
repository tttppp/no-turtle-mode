# No Turtle Mode for OpenRA Red Alert.

## Description

To reduce the incentive to wait for other players to kill each other in FFA games, this extension adds a Lua script that will periodically kill off the player with the lowest score. The interval can be configured via a dropdown menu in the lobby. The period for the final two players can be set to a different (e.g. larger) interval than the others.  

## Installation

For use with [oratools](https://github.com/ubitux/oratools).

Clone this project to `~/projects/no-turtle-mode` and create a directory `~/sandbox/maps` with the following structure:
```
maps
+-- overlay.png: An overlay png (with transparency)
+-- source-maps: A directory containing the source map pack
    +-- map1.oramap
    +-- map2.oramap
```

Assuming you also want to include ERCC and the latest [BI balance](https://github.com/tttppp/ora-balance-iteration) then use the following command to create the map pack at `/tmp/map-pack`:

```
ora-tool mappack \
    --overlay ~/sandbox/maps/overlay.png \
    --strip-tags \
    --rm ragl-briefing-rules.yaml lobby-rules.yaml ERCC2-rules.yaml ercc2-rules.yaml ercc2-sequences.yaml ragl-balance.yaml ragl-briefing.yaml briefing.yaml briefing-rules.yaml bain2-rules.yaml bain2-weapons.yaml ragl-actor-rules.yaml ragl-actor-sequences.yaml tox_sign.shp .DS_Store \
    --ext maps-extensions/ercc-bcc ~/projects/ora-balance-iteration/src ~/projects/no-turtle-mode \
    --title '{title} [No Turtle]' \
    --category NoTurtle \
    --out-dir /tmp/map-pack \
    ~/sandbox/maps/source-maps
```

## Bugs/Contributions

There are probably plenty of bugs and improvements that can be made. Please feel free to raise issues or pull requests in this GitHub repository.
