extends Node

@export var generated_tile_scene: PackedScene
@export var tile_properties: Resource #= preload("res://data/tiles/tile_types.tres")
@export var map_size: int = 32
var water_scene: PackedScene = preload("res://water_tile.tscn")

## CONSTANTS
enum GridDirection {NW, W, SW, N, S, NE, E, SE}

## HEIGHT MAP
var height_map: Dictionary = {}
var world_grid: Array = []

## Initializes empty world map that will hold a 2D-array of WorldTiles with metadata about the world
func _initialize_world_map():
	for x in map_size:
		world_grid.append([])
		for y in map_size:
			world_grid[x].append(WorldTile.new("default", 0, Vector2i(x, y), null, []))
			
	# Map neighbors
	for x in map_size:
		for y in map_size:
			var neighbors = get_neighbors(world_grid[x][y])
			world_grid[x][y].neighbors = neighbors

func _create_height_map():
	var hmap = FastNoiseLite.new()
	hmap.noise_type = FastNoiseLite.TYPE_SIMPLEX
	hmap.seed = 1
	hmap.frequency = 0.05
	hmap.fractal_octaves = 4
	hmap.fractal_lacunarity = 2
	hmap.fractal_gain = 0

	var grid = {}
	for x in range(map_size):
		for y in range(map_size):
			var rand = floor(4 * abs(hmap.get_noise_2d(x,y)))
			grid[Vector2i(x, y)] = rand
	return grid

# Return all neighbors of a tile
func get_neighbors(tile: WorldTile):
	var neighbors = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if(x == 0 and y == 0): continue
			if(
				tile.position.x + x >= 0 and 
				tile.position.x + x < len(world_grid) and
				tile.position.y + y >= 0 and
				tile.position.y + y < len(world_grid[x])):
				neighbors.append(world_grid[tile.position.x + x][tile.position.y + y])
			else:
				neighbors.append(null)
	return neighbors

func _ready():
	print("hello")
	_initialize_world_map()
	self.height_map = _create_height_map()
	for x in range(map_size):
		for y in range(map_size):
			var tile_type = tile_properties.tile_array[height_map[Vector2i(x, y)]]
			var tile_height = height_map[Vector2i(x, y)]
			var tile = generated_tile_scene.instantiate()
			tile.position = Vector3(x, tile_height, y)
#			world_grid[x][y] = WorldTile.new(tile_type, tile_height, Vector2i(tile.position.x, tile.position.z), tile, world_grid[x][y].neighbors)
			
			# Update default tile with generated attributes
			world_grid[x][y].type = tile_type
			world_grid[x][y].height = tile_height
			world_grid[x][y].tile_scene = tile
			
			var is_edge_tile_bottom = (y == map_size - 1)
			var is_edge_tile_right = (x == map_size - 1)
			
			# Get list of heights of neighbors
			var neighbor_heights = 	world_grid[1][31].neighbors.map(func(i): 
				if(i != null): 
					return i.height 
				else: 
					return null
			)
			
			tile.get_node("MeshInstance").build_fancy_tile(
				Color8(
					int(tile_properties.tile_reference[tile_type].r), 
					int(tile_properties.tile_reference[tile_type].g), 
					int(tile_properties.tile_reference[tile_type].b),
					1),
					is_edge_tile_bottom,
					is_edge_tile_right,
					neighbor_heights)
			add_child(tile)

	print(world_grid[1][31].neighbors)
	var east_neighbor: WorldTile = world_grid[1][1].neighbors[GridDirection.E]
	print(east_neighbor.height)
	print(world_grid[1][31].neighbors.map(func(i): 
		if(i != null): 
			return i.height 
		else: 
			return null
		)
	)
	print("done")
	
class WorldTile:
	var type: String = ""
	var height: int = 0
	var position: Vector2i = Vector2i()
	var tile_scene: PackedScene = null
	var neighbors: Array = []

	func _init(_type, _height, _position, _tile_scene, _neighbors):
		self.type = _type
		self.height = _height
		self.position = _position
		self.tile_scene = _tile_scene
		self.neighbors = _neighbors
		
	func _to_string():
		return str(self.type) + ": " + str(self.position) + ", height: " + str(self.height)
