extends State

#IDLE

func enter():
	player.anim.play("idle")
	
func run():
	player.v.x = 0
	
func change():
	#idle to run
	if (player.left or player.right) and player.on_ground:
		return fsm.states.run
	#idle to jump
	if player.on_ground and player.jump:
		return fsm.states.jump
	#idle to attack
	if player.attack:
		return fsm.states.attack
	#idle to fall
	if not player.on_ground and player.v.y>0:
		return fsm.states.fall
		
func exit():
	pass
