extends Node3D

func build_tile(tile_ref):
	print("Tile:", tile_ref)
	var tile_scene:PackedScene = load("res://assets/tiles/{tile_ref}".format({"tile_ref": tile_ref}))
	var tile_model:Node3D = tile_scene.instantiate()
	add_child(tile_model)
