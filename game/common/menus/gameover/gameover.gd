extends Node2D
export var active = false

func _ready():
	$menu.connect("button_down",self,"on_menu")
	$restart.connect("button_down",self,"on_restart")
	
	
	$menu.disabled = true
	$menu.visible = false
	
	$restart.grab_focus()
	
func _process(delta):
	#gameover logic
	if globals.life == 0 and not active:
		active = true
		game.set_state(game.states.game_over)
		$restart.grab_focus()
	if active:
		show()
		if Input.is_action_just_pressed("ui_up"):
			$restart.visible = true
			$restart.disabled = false
			$restart.grab_focus()
			
			$menu.disabled = true
			$menu.visible = false
		if Input.is_action_just_pressed("ui_down"):
			$menu.disabled = false
			$menu.visible = true
			$menu.grab_focus()
			
			$restart.disabled = true
			$restart.visible = false
	else:
		hide()
func on_menu():
	if active:
		globals.reset()
		self.visible = false
		get_tree().paused = false
		game.set_state(game.states.menu)
	
func on_restart():
	if active:
		globals.reset()
		self.visible = false
		get_tree().paused = false
		game.set_state(game.states.game_play)