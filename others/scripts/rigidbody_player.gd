#-------------------------------------------code for rigid body character-----------------------------------------------------------
extends RigidBody2D

#------------------------------------------declare the class variables--------------------
export var accn = 100
var jump_speed = 1200
var top_speed = 1000
var on_ground = false
var not_dusting = true
var implode = preload("res://objects/implode/implode.tscn")
var stone = preload("res://objects/stone/stone.tscn")
var face = "right"
var state_machine = {
	idle = "idle",
	jump = "jump" ,
	run = "run",
	throw = "throw"
}
var current_state = self.state_machine.idle
var previous_state =  self.state_machine.jump
var timer 
var move = {
	left = Vector2(-1,0),
	right = Vector2(1,0),
	up = Vector2(0,-1),
	down = Vector2(0,1)
}
var final_velocity = Vector2(0,0)
var n = Vector2(0,-1) #initialise the collision normal

#for movement on curve and plane surface

#var ray_cast_to = -100*n
#-------------------------------------------initialize object----------------------
func _ready():
	
	timer = $Timer
	# on_begin_contact
	self.connect("body_entered",self,"on_begin_contact")
	
#-------------------------------------------------------------------
#func _draw():
	#draw_line($RayCast2D.position,self.ray_cast_to,Color(1,1,0,1))
#------------------------------------------------------------
func die():
	var s =implode.instance()
	s.position = self.position
	s.scale = Vector2(0.5,0.5)
	s.modulate = Color(1,0,0,1)
	get_tree().root.add_child(s)
	self.queue_free()
func throw_stone(stone):
	var s = stone.instance()
	s.position = self.position+Vector2(-20,-40)
	if self.face == "left":
		s.v.x=-1*s.v.x
		s.v += Vector2(self.linear_velocity.x,0)
	if self.face == "right":
		s.v += Vector2(self.linear_velocity.x,0)
	get_tree().root.add_child(s)
		
#-----------------------------------------update object logic on each frame-------------------------------------	
func _integrate_forces(state):
	update()
	if globals.life == 0:
		die()
	#print(abs(state.linear_velocity.x))
	# 1 calculate  the collision normal 
	self.calculate_collision_normal(state)
	
	#self.n = $RayCast2D.get_collision_normal()
	#if self.n == Vector2() or !on_ground:
	#	self.n = Vector2(0,-1)
	#print(n)
	# 2  set the ray cast direction		
	#$RayCast2D.set("cast_to",self.ray_cast_to)      
	
		
	# 3 determine if the object is on the ground or not
	self.determine_object_on_ground()
	#tweak gravity scale as per on ground
	if on_ground and self.rotation != 0:
		self.gravity_scale =0
	else:
		self.gravity_scale = 30
	
	# 4 calculate player states
	self.calculate_state_transition(state)
	
	# 5 calculate final player movements
	self.calculate_player_movements(state)
	
	# 6 update state logic
	self.update_state_logic()
#---------------------------------------------helper methods -----------------------------------------------------------------------------		
#calculate collision normal with ray cast
func calculate_collision_normal_with_rayCast(state):
	self.n = $RayCast2D.get_collision_normal() 
# calculate  the collision normal 	using collider
func calculate_collision_normal(state):
	if state.get_contact_count()>0 :
		#print()
		if state.get_contact_collider_object(0).name == "Map":
			self.n = Vector2(0,-1)
		else:
			self.n = state.get_contact_local_normal(0) #calculate the collision normal
		#state.linear_velocity = state.linear_velocity.slide(self.n)
	#else:
		#self.n = Vector2(0,-1)

#-------------------------------------------------------------------------------------------------------------------------------------
# check whether the object is on the ground or not
func determine_object_on_ground():
	
	if $RayCast2D.is_colliding():
		self.on_ground = true
		
	else :
		self.on_ground = false

#------------------------------------------------------------------------------------------------------
#calculate state transition
func calculate_state_transition(state):
	#print(n)
	self.rotation = PI/2+n.angle()
	var c = current_state
	#throw stone logic
	if Input.is_action_just_pressed("ui_accept"):
		timer.start()
		throw_stone(stone)
	if Input.is_action_just_released("ui_accept"):
		timer.stop()
		
		
	#logic for state transition
	if Input.is_action_pressed("ui_left"):
		self.face = "left"
		$sprite.flip_h = true
		$scarf/sprite.flip_h = true
		$scarf.rotation = 0
		$scarf/AnimationPlayer.play("wave")
		$scarf/sprite.position.x = $sprite.position.x + 120
	
	if Input.is_action_pressed("ui_right"):
		self.face = "right"
		$sprite.flip_h = false
		$scarf/sprite.flip_h = false
		$scarf/AnimationPlayer.play("wave")
		$scarf.rotation = 0
		$scarf/sprite.position.x = $sprite.position.x 
	
	if self.on_ground == true   and abs(state.linear_velocity.x) > 0.0:
		self.current_state = self.state_machine.run 
		
	if self.on_ground == false :
		self.current_state = self.state_machine.jump	
		
	if abs(state.linear_velocity.x) < 10 and self.on_ground == true :
		self.current_state = self.state_machine.idle
	if Input.is_action_pressed("ui_accept"):
		self.current_state = self.state_machine.throw	
	#if the current state has changed from the stored value update previous state
	if c!=current_state:
		previous_state = c
		
	#play the dust
	if previous_state == "jump" and self.on_ground and not_dusting :
		not_dusting = false
		$effects/AnimationPlayer.play("dust")
	
#------------------------------------------------------------------------------------------------------------

#calculate player movements
func calculate_player_movements(state):
	var v= state.linear_velocity  # save the linear velocity
	var t = n.rotated(PI/2)
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	
	if left and abs(t.dot(v))<top_speed :
		final_velocity  =  self.n.rotated(-PI/2)*accn
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if right and abs(t.dot(v))<top_speed :
		final_velocity = self.n.rotated(PI/2)*accn
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if Input.is_action_pressed("ui_down"):
		#self.set_deferred("mode",0)
		pass
		
	if Input.is_action_just_pressed("ui_up") and on_ground:
		final_velocity = move.up*jump_speed
		state.linear_velocity = state.linear_velocity+final_velocity
		
	if Input.is_action_just_pressed("ui_jump")  and on_ground:
		final_velocity = move.up*jump_speed*1.5
		state.linear_velocity = state.linear_velocity+final_velocity
	if (not left and not right)and on_ground:
		state.linear_velocity = state.linear_velocity.project(n)
		
#-----------------------------------------------------------------------------------------------------------------------
#update animation
func update_state_logic():
	
	
	if self.current_state == "idle":
		$AnimationPlayer.play("idle")
	
	if self.current_state == "jump":
		$AnimationPlayer.play("jump")
		not_dusting = true
		
	if self.current_state == "run":
		$AnimationPlayer.play("run")
	if self.current_state == "throw":
		if linear_velocity.length() > 20:
			$AnimationPlayer.play("throw_running")
		else:
			$AnimationPlayer.play("throw")
	
#------------------------------------------------------------------------------------------------------------
#collision code for the player 
func on_begin_contact(obj):
	# if player collides with the chicken
	print("i hit ",obj.get_class())
	if obj.get("prop") == "chicken":
		obj.set_deferred("mode",0)


#--------------------------------------------------------------------------------------------------------------


#throw timer 
func _on_Timer_timeout():
	throw_stone(stone)
