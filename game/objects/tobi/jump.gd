extends State

#player stand state

func enter():
	player.anim.play("jump")
	player.v.y = -player.jump_speed
func run():
	#jump to move for motion in air
	if player.left :
		player.v.x = -1*player.air_speed
	if player.right :
		player.v.x = 1*player.air_speed
	pass
func change():
	
	#jump to fall
	if player.v.y >0 and not player.on_wall :
		return fsm.states.fall
	#jump to wall_slide
	if player.v.y >0 and  player.on_wall :
		return fsm.states.wall_slide
	
	#jump to wall jump
	if player.on_wall and player.jump:
		return fsm.states.wall_jump
	#jump to attack
	if player.attack:
		return fsm.states.attack
func exit():
	pass
