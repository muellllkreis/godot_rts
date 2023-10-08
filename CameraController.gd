extends Node3D

## PARAMS
# movement
@export var movement_speed = 10
# rotation
@export var min_elevation_angle = 10
@export var max_elevation_angle = 90
@export var rotation_speed = 10
@export var allow_rotation = true
# zoom
@export var min_zoom = 5
@export var max_zoom = 90
@export var zoom_speed = 50
@export var zoom_speed_damp = 0.5 
@export var zoom_to_cursor = false

## VARIABLES
# movement
var _last_mouse_position = Vector2()
var _is_rotating = false
@onready var elevation = $Elevation
@onready var camera = $Elevation/Camera3D

# zoom
var _zoom_direction = 0

func _process(delta):
	_move(delta)
	_rotate(delta)
	_zoom(delta)
	
func _unhandled_input(event):
	# test if we are rotating
	if event.is_action_pressed("camera_rotate"):
		_is_rotating = true
		_last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		_is_rotating = false
	# test if we are zooming
	if event.is_action_pressed("camera_zoom_in"):
		_zoom_direction = -1
	if event.is_action_pressed("camera_zoom_out"):
		_zoom_direction = 1
	pass
	
func _move(delta):
	# initialize velocity vector
	var velocity = Vector3()
	# populate it based on user input
	if Input.is_action_pressed("camera_forward"):
		velocity -= transform.basis.z
	if Input.is_action_pressed("camera_backward"):
		velocity += transform.basis.z
	if Input.is_action_pressed("camera_left"):
		velocity -= transform.basis.x
	if Input.is_action_pressed("camera_right"):
		velocity += transform.basis.x
	velocity = velocity.normalized()
	# translate camera based on input
	position += velocity * delta * movement_speed
	pass

func _rotate(delta):
	if not _is_rotating or not allow_rotation:
		return
	# calculate mouse movement
	var displacement = _get_mouse_displacement()
	# use horizontal displacement to rotate
	_rotate_left_right(delta, displacement.x)
	# vertical displacement to elevate
	_elevate(delta, displacement.y)
	pass
	
func _zoom(delta):
	# calculate new zoom
	var new_zoom = clamp(camera.position.z + zoom_speed * delta * _zoom_direction, min_zoom, max_zoom)
	# clamp zoom between min and max zoom
	camera.position.z = new_zoom
	# stop zooming
	_zoom_direction *= zoom_speed_damp
	if (abs(_zoom_direction) <= 0.0001):
		_zoom_direction = 0
	pass
	
## HELPERS
func _get_mouse_displacement():
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - _last_mouse_position
	_last_mouse_position = current_mouse_position
	return displacement

func _rotate_left_right(delta, val):
	rotation_degrees.y += val * delta * rotation_speed
	pass
	
func _elevate(delta, val):
	# calculate new elevation
	var new_elevation = elevation.rotation_degrees.x - val * delta * rotation_speed	
	# clamp new elevation between min and max
	new_elevation = clamp(new_elevation, -max_elevation_angle, -min_elevation_angle)
	# set new elevation based on new value
	elevation.rotation_degrees.x = new_elevation
