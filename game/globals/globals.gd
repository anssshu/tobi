#this script is for storing the global values 
# all global values declared in this file can be accessed from any script

extends Node

#load the paths of each object and scenes to be used for preload of all tscn files
var res = {
	#lua style dictionary
	
	main_menu = "res://common/menus/menu/menu.tscn",
	load_levels = "res://common/menus/loadlevels/levels.tscn",
	settings = "res://common/menus/settings/settings.tscn",
	gameover = "res://common/menus/gameover/gameover.tscn",
	
	level1 = "res://levels/village/village.tscn",
	level2 = "res://levels/jungle/jungle.tscn",
	level3 = "res://levels/cave/cave.tscn",
	level4 = "res://levels/dark_forest/dark_forest.tscn",
	level5 = "res://levels/castle/castle.tscn",
}
var score = 0 
var health = 1
var life = 3
var keys = 0
var mute =  false
var cleared_levels = 1 #0,1,2
var check_point = Vector2(600,400)
var current_level = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func reset():
	globals.keys = 0
	globals.health = 1
	globals.score = 0
	globals.life = 3
	globals.check_point = Vector2(1000,400)
