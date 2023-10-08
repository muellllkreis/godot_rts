extends CharacterBody3D

var _rotation_speed = 0.01
@onready var raycast = $RayCast3D

func _process(delta):
	#var axis = Vector3(0, 1, 0)
	#transform.basis = transform.basis.rotated(axis, _rotation_speed)
	self.rotate_y(_rotation_speed)
	if(raycast.is_colliding()):
		var target = raycast.get_collider()
		print("Seeing %s" % target.name)
