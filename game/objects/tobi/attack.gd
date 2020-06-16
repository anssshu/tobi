extends State

var running = false
func enter():
	#running throw
	if player.attack  and player.on_ground and (player.left or player.right):
		player.anim.play("running_throw")
		running = true
	else:
		player.anim.play("throw")
		running = false
	player.throw_stone()
	player.throw_timer.start()
func run():
	if player.on_ground and (player.left or player.right) and not running:
		running = true
		player.anim.play("running_throw")
	if not(player.left or player.right) and running:
		running = false
		player.anim.play("throw")
	#running attack
	if player.attack  and player.on_ground:
		player.v.x = (-int(player.left)+int(player.right))*player.run_speed
	pass
func change():
	#attack to idle
	if not (player.left or player.right or player.jump or player.attack) and player.on_ground:
		return fsm.states.idle
	#attack to run
	if not(player.attack) and (player.left or player.right) and player.on_ground:
		return fsm.states.run
	#attack to fall
	if not(player.attack) and player.v.y>0 and not(player.on_wall or player.on_ground):
		return fsm.states.fall
	#attack to jump without entering jump state
	if not(player.attack) and player.v.y<0 and not(player.on_wall or player.on_ground):
		#first exit attack state
		exit()
		fsm.state = fsm.states.jump
	#attack to enter jump
	if player.attack and player.on_ground and player.jump:
		return fsm.states.jump
	#attack to wall_slide
	if not(player.attack) and player.v.y>0 and player.on_wall and not (player.on_ground):
		return fsm.states.wall_slide
func exit():
	#stop the throw timer
	player.throw_timer.stop()
