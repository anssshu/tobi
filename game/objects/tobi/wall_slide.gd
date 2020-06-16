extends State


func enter():
	player.anim.play("jump")
func run():
	pass
func change():
	#wall_slide to idle
	if player.on_ground:
		return fsm.states.idle
	#wall_slide to wall_jump
	if player.up:
		return fsm.states.wall_jump
func exit():
	pass
