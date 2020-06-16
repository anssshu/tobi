#--------------------------------------------code for kinematic character-----------------
extends KinematicBody2D	
#-------------------------------------------declare the class variables----------------
#var v = Vector2()
export var speedScale = 1
var g = Vector2(0,1200)*speedScale
var walkspeed = 400*speedScale
var jumpspeed = 500
var accn = 1000*speedScale
var n = Vector2(0,-1)
var t = Vector2()
var vt = Vector2()
var vn = Vector2()
var col_normal = Vector2(0,-1)# for wall jump
var swim_speed = 200
export var simple_mode = false
#---------------------
var velocity = Vector2()
signal my_signal(col)
#------------------declare the class variables--------------------
#export var accn = 200

var on_wall = false
var colliding = false
var on_ground = false
var not_dusting = true


var face = "right"

var state_machine = {
	idle = "idle",
	jump = "jump",
	run = "run",
	throw = "throw",
	swim = "swim",
	dead = "dead"
}

var current_state = self.state_machine.idle
var previous_state =  self.state_machine.jump

var timer #stone throwing timer

var move = {
	left = Vector2(-1,0),
	right = Vector2(1,0),
	up = Vector2(0,-1),
	down = Vector2(0,1)
}

#var n = Vector2(0,-1) #initialise the collision normal
#---------------------------------------------------------------------------------

#-------------------preloads--------------------------------------------------------
var implode = preload("res://objects/implode/implode.tscn")
var stone = preload("res://objects/stone/stone.tscn")
#for movement on curve and plane surface

var ray_cast_to = 50*Vector2(1,0)

#-------------------------------------------------------------------
func _draw():
	#draw_line($RayCast2D.position,self.ray_cast_to,Color(0,0,0,1))
	#draw_line($groundRay.position,$groundRay.cast_to,Color(0,0,0,1))
	#draw the collision normal
	#draw_line(pos,n,Color(1,0,0,1)
	pass
#---------------
#-----------------------------------------------initialize object ----------------------
func _ready():
	#connect my_signal for collision detection
	self.connect("my_signal",self,"on_stay_collision")
	#initialize connection for collision detection
	timer = $Timer
	#set the life of the player
	globals.health = 1
	position = globals.check_point
#-------------------------------------------------player behaviour------------------------------------------------
func _physics_process(delta):
	update()
	if globals.health == 0 and self.current_state != "dead":
		die()
	
	#motion logic 
	if self.current_state != "dead":
		if self.current_state == "swim":
			self.swim(delta)
		else:
			if simple_mode:
				self.simple_move(delta)
			else :
				self.move_player(delta)
			self.calculate_state_transition()
			self.update_state_logic()
#------------------------------------------------------helper functions---------------------------------------------------------------------------------	
func swim(dt):
	g = Vector2(0,400)
	velocity += g*dt
	var c = move_and_collide(velocity*dt)
	#input processing
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")

	if left :
		velocity = move.left*200
	if right :
		velocity = move.right*200
	if up :
		velocity = move.up*200
	if down :
		velocity = move.down*200
	if not (left or right or up or down):
	
		velocity.x *= 0.99
	
	velocity = move_and_slide(velocity,n)
func simple_move(dt):
	#g = Vector2(0,400)
	velocity += g*dt
	var c = move_and_collide(velocity*dt)
	#input processing
	var left = Input.is_action_pressed("ui_left")
	var right =  Input.is_action_pressed("ui_right")
	var jump =  Input.is_action_just_pressed("ui_up")
	

	if left and not right  and on_ground and abs(velocity.x)<walkspeed:#move left
		velocity.x += -accn*dt
	if right and not left  and on_ground and abs(velocity.x)<walkspeed:#move left
		velocity.x += accn*dt
	if is_on_floor() and jump :
		velocity.y = -jumpspeed 
	
	if not (left or right or jump):
	
		velocity.x *= 0.99
	
	velocity = move_and_slide(velocity,Vector2(0,-1))
func move_player(dt):
	on_ground = $groundRay.is_colliding()#is_on_floor()
	#for continueous movements on vertical and curvey surfaces
	if on_ground:
		g = -n*1200
		#velocity = Vector2()
	else:
		g= Vector2(0,1200)
	#print(velocity)
	#input processing
	var left = Input.is_action_pressed("ui_left")
	var right =  Input.is_action_pressed("ui_right")
	var jump =  Input.is_action_just_pressed("ui_up")
	
	
	#update rotation and velocity
	var angle = PI/2 + n.angle()
	self.rotation = lerp(self.rotation,angle,.5)
	
	
	velocity += g*dt
	
	t = n.rotated(PI/2)
	vt = velocity.dot(t)*t #tangential velocity
	vn = velocity.dot(n)*n #normal velocity
	
	var is_on_air = not (is_on_floor() or is_on_ceiling() or is_on_wall())
	
	# ray and col_normal for wall jump
	if face == "left":
		ray_cast_to = Vector2(-60,-20)
		col_normal = Vector2(1,0)
	if face == "right":
		ray_cast_to = Vector2(60,-20)
		col_normal = Vector2(-1,0)
	
	#wall finding
	$RayCast2D.set("cast_to",self.ray_cast_to)
	var rc = $RayCast2D.get_collider()
	if rc and rc.name == "Map" and not on_ground:	
		on_wall =$RayCast2D.is_colliding() 
	else:
		on_wall = false
	#on_wall  = is_on_wall()
	
	#sliding on the wall
	if on_wall and (left or right) :
		#g= Vector2(0,0)
		velocity = Vector2(0,20)
	if not on_wall:
		g=Vector2(0,1200)
	
	
	#on_wall = is_on_wall()
	
	
		
	if on_wall and jump :
		#first jump
		vt = jumpspeed*col_normal*.6
		vn = jumpspeed*n*1
		velocity = vn+vt
		#then change the face
		if col_normal.x == -1:
			self.face = "left"
		if col_normal.x == 1:
			self.face = "right"
	
	
	
	
	#move left on ground
	if left and not right  and on_ground and vt.length()<walkspeed:#move left
		vt += -accn*t*dt
		velocity = vt+vn
	
	#move right on ground
	if  right and not left and on_ground and vt.length()<walkspeed:#move right
		vt += accn*t*dt
		velocity = vt+vn	
	
	# left right during jump in air
	if left and is_on_air and  velocity.length()>20 and rotation <0 and abs(velocity.x)<500:
		velocity.x += -10
	if right and is_on_air and velocity.length()>20  and rotation <0 and abs(velocity.x)<500 :
		velocity.x += 10
	
	#when stop
	if on_ground and not (left or right) :
		#make the tangential velocity 0
		
		vt *=.2 #Vector2()
		velocity = vt+vn
	#when stop on vertical walls player is pushed out
	if on_ground and not (left or right) and n.y >0:
		velocity = n*100
		#velocity = Vector2(0,0)
	#jumpl logic
	if on_ground and jump :
		#print("jump")
		vn = jumpspeed*n
		velocity = vn+vt	
		
	#gravity 
	#if is_on_air:
		#g = Vector2(0,1200)
	#procell collision	
	var i = 0 
	var c = move_and_collide(velocity*dt) #it holds collision data
	if c:
		#for wall collision 
		if face == "left":
			col_normal = Vector2(1,0)
		if face == "right":
			col_normal = Vector2(-1,0)
		#col_normal = c.normal
		emit_signal("my_signal",c)
		#calculate collision normal
		#collision with tile maps
		if c.collider.name == "Map":
			n = Vector2(0,-1)
		else:
			n = c.normal
		i = 1
		#g = -g*n
	else:
		#n=Vector2(0,-1)
		i=0
	
	#object on air change collision normal for rotation
	if is_on_air  and abs(velocity.y)>500:
		n = n.slerp(Vector2(0,-1),.1)
		#print("collision:",c)
	
	if i==1 and colliding==false :
		on_enter_collision(c)
		colliding = true
	if i==0 and colliding :
		on_exit_collision(c)
		colliding = false	
	
	velocity = move_and_slide(velocity,n)
func on_stay_collision(c):
	#if c.normal.x == -1 or c.normal.x == 1:
		#on_wall = true
		#velocity =Vector2(0,0)
		#g = Vector2(0,0)
	pass
func on_enter_collision(c):
	#print("enter collision")
	"""
	if c.normal.x == -1 or c.normal.x == 1:
		on_wall = true
		velocity =Vector2(0,0)
		g = Vector2(0,0)
		"""
	pass
func on_exit_collision(c):	
	#on_wall = false
	#g= Vector2(0,1200)
	pass
#------------------------------helper functions---------------------------------------------------------
#-------------------------------------------------------------------
func die():
	if globals.life > 0:
		globals.life -= 1
	var s = implode.instance()
	s.position = self.position
	#s.scale = Vector2(0.5,0.5)
	#s.modulate = Color(1,0,0,1)
	get_tree().root.add_child(s)
	self.current_state = "dead"
	hide()
	#stop throw timer
	$Timer.stop()
	if globals.life != 0:
		play_end_animation()
	
func throw_stone(stone):
	var s = stone.instance()
	s.position = self.position+Vector2(-20,-40)
	#s.get_node("sprite").modulate = Color(0,0,0,1)
	if self.face == "left":
		s.v.x=-1*s.v.x
		s.v += Vector2(self.velocity.x,0)
	if self.face == "right":
		s.v += Vector2(self.velocity.x,0)
	get_tree().root.add_child(s)
		
#-----------------------------------------update object logic on each frame-------------------------------------	

	
	
	
#---------------------------------------------helper methods -----------------------------------------------------------------------------		
 
#-------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------
#calculate state transition
func calculate_state_transition():
	var c = current_state
	
		
	#logic for state transition
	if Input.is_action_pressed("ui_left"):
		self.face = "left"
	if Input.is_action_pressed("ui_right"):
		self.face = "right"
	#run state
	if self.on_ground == true   and abs(velocity.x) > 10.0:
		self.current_state = self.state_machine.run 
	#jump state	
	if self.on_ground == false :
		self.current_state = self.state_machine.jump	
	#idle state	
	if abs(velocity.dot(n.rotated(PI/2))) < 10 and self.on_ground == true :
		self.current_state = self.state_machine.idle
	#throw state	
	if Input.is_action_pressed("ui_accept"):
		self.current_state = self.state_machine.throw	
	#if the current state has changed from the stored value update previous state
	if c!=current_state:
		previous_state = c
			
#------------------------------------------------------------------------------------------------------------
#move on plane surface this is not in use now

#-------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
#update animation
func update_state_logic():
	#face left logic
	if self.face == "left":
		$sprite.flip_h = true
		$scarf/sprite.flip_h = true
		$scarf.rotation = 0
		$scarf/AnimationPlayer.play("wave")
		$scarf/sprite.position.x = $sprite.position.x + 120
	#face right logic
	if self.face == "right":
		$sprite.flip_h = false
		$scarf/sprite.flip_h = false
		$scarf/AnimationPlayer.play("wave")
		$scarf.rotation = 0
		$scarf/sprite.position.x = $sprite.position.x 
	#play the dust
	if previous_state == "jump" and self.on_ground and not_dusting :
		not_dusting = false
		$dust/AnimationPlayer.play("dust")
	#idle state
	if self.current_state == "idle":
		$AnimationPlayer.play("idle")
	#jump state
	if self.current_state == "jump":
		$AnimationPlayer.play("jump")
		not_dusting = true
	#run state	
	if self.current_state == "run":
		$AnimationPlayer.play("run")
	#throw state
	if self.current_state == "throw":
		if velocity.length() > 20:
			$AnimationPlayer.play("throw_running")
		else:
			$AnimationPlayer.play("throw")
	#continueous stone throwing
	if Input.is_action_just_pressed("ui_accept"):
		timer.start()
		throw_stone(stone)
	if Input.is_action_just_released("ui_accept"):
		timer.stop()
#------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
#throw timer 
func _on_Timer_timeout():
	throw_stone(stone)




#after player dies restart timer starts and 
#plays the end animation and after the animation seen is reloaded
func play_end_animation():
	var anim = get_node("/root/scene/ui/scene_transition/end/AnimationPlayer")
	anim.seek(0)
	anim.play("become_dark")
	
	#get_tree().reload_current_scene()
	#var p = get_node("/root/ground/player")
	#p.position = Vector2(2000,300)
	