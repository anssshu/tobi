extends Node
class_name StateMachine

var state = null 
var last_state = null
var state_name = null

var states = {}
onready var parent = get_parent()

func _set_state_name():
	if state != null:
		state_name =  states.keys()[state]
	else:
		state_name =  "not_defined"

func _physics_process(delta):
	if state != null :
		_state_logic(delta)
		var transition = _get_transition(delta)
	
		if transition != null:
			set_state(transition)

func add_state(state_name):
	states[state_name] = states.size()
	
func set_state(new_state):
	
	last_state = state
	state = new_state
	_set_state_name()
	print(state_name)
	if last_state != null :
		_exit_state(last_state,new_state)
	if state != null:
		_enter_state(new_state,last_state)
		

func _state_logic(delta):
	pass
	
func _get_transition(delta):
	return null
	
func _enter_state(new_state,old_state):
	pass
	
func _exit_state(old_state,new_state):
	pass
	
		