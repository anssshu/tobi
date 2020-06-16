extends State

#RUN

func enter():
	player.anim.play("run")
	player.get_node("sprite/scarf/sprite").play("run")
#when player is in run state
func run():
	#run state logic
	if player.left:
		player.dir = -1
	if player.right :
		player.dir = 1
	player.v.x = player.dir*player.run_speed
	
func change():
	#run to idle
	if not (player.left or player.right or player.jump) and player.on_ground:
		return fsm.states.idle
	#run to jump
	if player.on_ground and player.jump:
		return fsm.states.jump
		
	#run to duck
	if player.down:
		return fsm.states.duck
		
	#run to attack or running attack
	if player.attack:
		return fsm.states.attack
		
	#run to fall
	#if not player.on_ground and player.v.y>100:
		#return fsm.states.fall
func exit():
	pass
