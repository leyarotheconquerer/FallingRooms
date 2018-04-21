LD 41 Game
==========

Tentative title: *Falling Rooms*

This is a game attempt for the Ludum Dare 41.

Theme
-----

Combine Two Incompatible Genres

Concept
-------

Rogue-like tetris

In essense, the dungeon is a tetris board.
Rooms fall from above and must be oriented to fall appropriately.
Navigate through the dungeon and defeat foes found within.
Try to find the exit, gathering wealth along the way.
Wealth is the measure of your success.
Rooms have entrances and exits that must be lined up.
Rooms with easy monsters yield less wealth?
Rooms provide option to bypass or take on challenge?
Each piece has two rooms, one of each type?

* Setting
	- Low fantasy
* Weapons
	- Sword
	- Bow
* Enemies
	- Spider
	- Bow Dude
	- Troll?
* Rooms
	- Treasure room
	- Hallway
	- Hall
	- Bedroom
	- Well
	- Prison
	- Exit
* Rewards
	- Gold
	- Health potion
	- Weapons?


* Real time movement and combat
	- Tetris tiles fall in real time, slowly
	- _Or tiles fall when item is obtained in room_
* Free-roaming 3D map
	- Like a table-top
	- Delete rooms that are exited? when row is complete.... detecting that could be fun
* Camera top down (follows player?)
	- Start camera at exit
	- Pan to player
* Menu to restart
	- Score at end of each try

Details
-------

* Board
	- Board shall be at least 11 blocks to a side (meaning at least 4 blocks to complete game)
* Pieces/rooms
	- Pieces shall be no longer than 3 blocks to a side
	- Pieces shall each have at least 3 entrances (promotes choice of which shall lead to the next)
	- Pieces shall each be predominated by one challenge
* Player characteristics
	- Player shall have health points
	- Player shall start with a sword
	- Player has a wallet for storing gold
	- Player is reset on death
* Melee weapons
	- Weapons sweep to deal damage
	- Sweeps happen at a rate determined by the monster
* Ranged weapons
	- Ranged weapons fire at a rate towards the opponent
	- Ranged weapons may be dodged
* Room types
	- There are two divisions of rooms
	- Combat rooms
		- Spiders (more numerous, but melee)
		- Ogre (less numerous, but melee)
		- Bowmen (less numerous, ranged)
	- Non-combat rooms
		- Chest rooms (free treasure)
		- Skill (don't fall off?)
		- Insignificant rooms?
		- Block puzzles?
	- In addition there are special rooms
		- Spawning room
			- Player starts in this room
		- Exit room
			- Upon exiting, the player is spawned in a new level to continue
* Collision types
	- Character -> Room (physical) = layer 1
	- Room -> Room (non physical) = layer 2
	- Room -> Board (physical) = layer 3

Assets
------
* Player
	+ Player Model
		- Model
		- Walk Animation
		- Die Animation
	+ Sword Model
		- Model
		- Attack Animation
		- Sweep collision
	+ Player Animations
* Enemies
	+ Spider Model
		- Model
		- Sweep collision
		- Walk Animation
		- Attack Animation
		- Die Animation
	+ Ogre Model
		- Model
		- Sweep collision
		- Walk Animation
		- Attack Animation
		- Die Animation
	+ Bowman model
		- Model
		- Arrow Model
		- Walk Animation
		- Attack Animation
		- Die animation
* Rooms
	+ Empty room
		- Walls
		- Doors
	+ Prison room
		- Bars
		- Bench
		- Bucket
	+ Bedroom
		- Bed
		- Desk
		- Drawers
	+ Halls
		- Column
		- Banner
	+ Treasure room
		- Chest
		- Pile of dirt
	+ Well room
		- Well
		- Pond/fountain
	+ Exit
		- Stairs
* Board
	+ Model
* UI
	+ Player Health
	+ Player Gold
	+ Enemy Health