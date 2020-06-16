extends State


func enter():
	player.anim.play("jump")
	if player.check_player_on_right_wall():
		player.face = "left"
		player.v.x = -500
		player.v.y = -800
	if player.check_player_on_left_wall():
		player.face = "right"
		player.v.x = 500
		player.v.y = -800
func run():
	pass
func change():
	#wall_jump to fall
	if player.v.y>0:
		return fsm.states.fall	
	#wall_jump to wall_slide
	if player.v.y >0 and  player.on_wall :
		return fsm.states.wall_slide
	#wall_jump to attack
	if player.attack:
		return fsm.states.attack
	
func exit():
	pass
