extends State


func enter():
	pass
func run():
	pass
func change():
	#duck to jump
	if player.jump:
		return fsm.states.jump
	
	#duck to idle
	if player.v.length() < 100:
		return fsm.states.idle
func exit():
	pass
