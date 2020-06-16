extends StateMachine

func _ready():
	add_state("menu")
	add_state("game_play")
	add_state("settings")
	add_state("load_levels")
	add_state("game_over")
	add_state("exit")
	
	#set the current state of the game
	#call_deferred("set_state",states.menu)
	#print("game state is working")
func _state_logic(delta):
	match state:
		states.menu:
			pass
		states.game_play:
			pass
		states.settings:
			pass
		states.load_levels:
			pass
		states.game_over:
			pass
		states.exit:
			pass
	
func _get_transition(delta):
	match state:
		states.menu:
			#menu to game play
			
			#menu to settings
			
			#menu to load levels
			
			#menu to exit
			pass
		states.game_play:
			#game play to pause
			
			#game play to game over
			
			
			pass
		
		states.settings:
			#settings to menu
			pass
		states.load_levels:
			#load levels to menu
			#load leveles to game play with a particular level
			pass
		states.game_over:
			#game over to menu
			
			#game over to game play with current level
			pass
		states.exit:
			pass
	return null
	
func _enter_state(new_state,old_state):
	match state:
		states.menu:
			get_tree().change_scene(globals.res.main_menu)
		states.game_play:
			if globals.current_level == 1:
				get_tree().change_scene(globals.res.level1)
			if globals.current_level == 2:
				get_tree().change_scene(globals.res.level2)
			if globals.current_level == 3:
				get_tree().change_scene(globals.res.level3)
			if globals.current_level == 4:
				get_tree().change_scene(globals.res.level4)
			if globals.current_level == 5:
				get_tree().change_scene(globals.res.level5)
		
		states.settings:
			get_tree().change_scene(globals.res.settings)
		states.load_levels:
			get_tree().change_scene(globals.res.load_levels)
		states.game_over:
			print(self.get_parent())
		states.exit:
			get_tree().quit()
	
func _exit_state(old_state,new_state):
	match state:
		states.menu:
			pass
		states.game_play:
			pass
		states.settings:
			pass
		states.load_levels:
			pass
		states.game_over:
			pass
		states.exit:
			pass
	
		