extends Control

var g =3

# Called when the node enters the scene tree for the first time.
func _ready():
	$ui/settings.grab_focus()
	#preload("res://scenes/main.tscn")
	$ui/play.connect("button_down",self,"on_play")
	$ui/levels.connect("button_down",self,"on_levels")
	$ui/settings.connect("button_down",self,"on_settings")
	$ui/exit.connect("button_down",self,"on_exit")
func _process(delta):
	
	if Input.is_action_just_pressed("ui_up") and (g > -1 and g < 3):
		g = g+1	
	if Input.is_action_just_pressed("ui_down") and (g > 0 and g < 4):
		g = g-1	
	if g== 3:
		$ui/play.grab_focus()
	if g == 2 :
		$ui/levels.grab_focus()
	if g == 1 :
		$ui/settings.grab_focus()
	if g == 0 :
		$ui/exit.grab_focus()
		
func on_play():
	game.set_state(game.states.game_play)
func on_levels():
	game.set_state(game.states.load_levels)
func on_settings():
	game.set_state(game.states.settings)	
func on_exit():
	game.set_state(game.states.exit)