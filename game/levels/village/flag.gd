extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#when player enters the flag timer starts and when it times out
func _on_Timer_timeout():
	#get_tree().change_scene("res://stages/stage1/ground.tscn")
	globals.current_level = 2
	game.set_state(game.states.game_play)
	globals.check_point = Vector2(550,200)
	#globals.reset()
	$Timer.stop()
	



#when player enters the flag
func _on_Area2D_body_entered(body):
	if body.name == "player":
		$Timer.start()
	