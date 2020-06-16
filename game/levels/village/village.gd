#res://levels/village/village.gd
extends Node2D


#load bees
var bee = preload("res://objects/bee/bee.tscn")

# initialise the scene
func _ready():
	#connect the bee_timer
	$others/bee_timer.connect("timeout",self,"_on_bee_timer_timeout")
	#$others/bee_timer.start()
	
	
	
	
# spawn bee when the bee_timer starts	
func spawn_bee():
	var b=bee.instance()
	b.A = rand_range(100,50)
	b.speed = rand_range(5,7)
	b.swing_speed = rand_range(2,5)
	#get player position
	var p = get_tree().root.get_node("/root/scene/player").position
	b.position = Vector2(p.x+800,p.y+rand_range(-400,-100))
	get_node("/root/scene").add_child(b)	
	#get_tree().root.add_child(b)
	#print(get_tree().root.name)
	
#when bee_timer ticks bees spawn
func _on_bee_timer_timeout():
	spawn_bee()

#first check point
func _on_start_bee_timer_body_entered(body):
	if body.name == "player":
		spawn_bee()
		$others/bee_timer.start()
		globals.check_point = body.position
		

#second check point
func _on_stop_bee_timer_body_entered(body):
	if body.name == "player":
		$others/bee_timer.stop()
		globals.check_point = body.position
		#get_node("/root/ground/CanvasLayer/text_timer").start()


