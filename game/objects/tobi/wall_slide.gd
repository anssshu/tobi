extends State


func enter():
	player.anim.play("jump")
	player.g.y = 0
func run():
	#
	player.v.y=200
	
func change():
	#wall_slide to idle
	if player.on_ground:
		return fsm.states.idle
	#wall_slide to wall_jump
	if player.up:
		return fsm.states.wall_jump
	#wall_slide to fall
	if (player.left or player.right) == false or player.on_wall == false:
		return fsm.states.fall
func exit():
	player.g.y = 2*player.jump_height/pow(player.jump_time,2)
