extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"on_enter_collision")
	self.connect("body_exited",self,"on_exit_collision")
	self.connect("area_entered",self,"on_area_entered")
	self.connect("area_exited",self,"on_area_exited")


#collision handling code	
func on_enter_collision(body):
	pass
func on_exit_collision(body):
	pass
func on_area_entered(area):
	pass
func on_area_exited(area):
	pass

