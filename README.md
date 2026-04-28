# 🚨 police_pa

Leo Vehicle & helicopter public address system for FiveM.

## Features

- `/pa` Live PA microphone *(included, needs broader testing)*
- `/paurl` Stream audio through loudspeaker
- `/paevac` Emergency evacuation tone
- `/pastop` Stop all broadcasts
- `/pavol` Adjust PA volume

## Included
- Police vehicle support
- Helicopter allowlist
- Positional moving loudspeaker audio
- Radio submix effects
- Auto cleanup if vehicle:
  - gets DV'd
  - explodes
  - despawns
  - driver exits

## Tested
✅ URL PA broadcasts  
✅ Evac tone  
✅ Volume controls  
✅ Vehicle tracking  
✅ Deletion failsafes  

⚠ `/pa` microphone mode included but still pending wider testing.

## Dependencies

```cfg
ensure qb-core
ensure pma-voice
ensure xsound
ensure police_pa
```

## Install

```cfg
ensure police_pa
```

## Helicopter Support

```text
polmav
buzzard
buzzard2
as350
swift
swift2
frogger
frogger2
supervolito
annihilator
```

## Commands

```text
/pa
/paurl <url>
/paevac
/pastop
/pavol 0.1-1.0
```

### default is loud btw i wouldnt make it be able to go higher than 1 in the code!

## Resource
police_pa


```/paevac``` Youtube Evac Preview:
(https://www.youtube.com/watch?v=0hv1aauZqBs)
