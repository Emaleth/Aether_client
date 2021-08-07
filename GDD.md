# Project Aether
## Game Design Document
## by Emaleth

### GENRE:
- third person (action) mass multi online role playing game

### SETTING:
- Future / Alternative Reality / Different Dimension
- Magitech / Technomagic
- Nature heavy with bits of advanced technology

### LORE:
- ?

### TECHNICAL INFO:
- Engine:		Godot (latest)
- Database:		.json
- Models:		blender (latest)
- Sfx/Bgm:		public domain or else
- Textures:		public domain or else
- Materials:	MAterial Maker

## UI:
- Based on skyrim mod "skyui". 
- Designed for keyboard use therefore making it easly adaptable to gamepad / touch screen.
- Heavy use of gasussian blur for the background.
- Click on item to see actions dependant on the content of the button. 
- Labels insted of icons for faster development.

## COMBAT:
?

## ATTRIBUTES:
- CHARACTER:
	- STRENGHT (
		melee damage,
		ranged damage,
		block force
		)
	- DEXTERITY (
		melee speed,
		ranged speed,
		cast speed, 
		movement speed,
		block chance,
		focus amount && regen
		)	
	- CONSTITUTION (
		health amount && regen,
		stamina amount && regen
		)
	- INTELLIGENCE (
		spell cost,
		spell force
		)
	- WISDOM (
		mana amount && regen	
		) 		
	- FATE (
		drop chance
		) 
	
- EQUIPMENT:
	- ATTACK
	- DEFENCE
	- BLOCK

- DERIVATES:
	- BLOCK CHANCE
	- PARRY CHANCE
	- RESOURCE REGENERATION
	- RESOURCE AMOUNT

## RESOURCES:
- HEALTH
- MANA (magick)
- STAMINA (melee)
- FOCUS (ranged)

## MOVEMENT:
Ideally something in between assasins creed and titanfall (sliding mechanic). Unlikely to happen...

- PLAYER MOVEMENT STATES:
	- IDLE
	- WALK
	- RUN
	- SPRINT
	- CROUCH
	- CRAWL
	- SLIDE
	- JUMP

- PLAYER COMBAT STATES:
	- IDLE
	- CAST
	- AIM
	- RANGED
	- MELEE
