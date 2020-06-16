extends State


func enter():
	player.anim.play("jump")
func run():
	#fall to move for motion in air
	if player.left :
		player.v.x = -1*player.air_speed
	if player.right :
		player.v.x = 1*player.air_speed
func change():
	#fall to jump in air jump
	if player.jump and player.jump_timer > .4 :
		player.jump_timer = 0
		return fsm.states.jump
	#fall to idle
	if player.on_ground:
		return fsm.states.idle
	
	#fall to attack
	if player.attack:
		return fsm.states.attack
	#fall to wall_slide
	if player.on_wall:
		return fsm.states.wall_slide
func exit():
	pass
