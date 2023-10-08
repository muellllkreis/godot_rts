extends MeshInstance3D

enum GridDirection {NW, W, SW, N, S, NE, E, SE}

var mat = StandardMaterial3D.new()
var test_mat1 = StandardMaterial3D.new()
var test_mat2 = StandardMaterial3D.new()
var test_col1 = Color(1, 0, 0, 1)
var test_col2 = Color(1, 0, 1, 1)
	
func build_tile(color):
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	## FIRST TRIANGLE
	st.add_vertex(Vector3(0, 0, 0));
	st.add_vertex(Vector3(1, 0, 0));
	st.add_vertex(Vector3(0, 0, 1));
	
	## SECOND TRIANGLE
	st.add_vertex(Vector3(1, 0, 0));
	st.add_vertex(Vector3(1, 0, 1));
	st.add_vertex(Vector3(0, 0, 1));
	
	st.add_index(0);
	st.add_index(1);
	st.add_index(2);
	st.add_index(3);
	st.add_index(4);
	st.add_index(5);
	
	st.generate_normals()
	
	mesh = st.commit();
	
	mat.albedo_color = Color(color)
	set_surface_override_material(0, mat)
	
func _build_base_tile(scaling_factor=0.9):
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	## FIRST TRIANGLE
	st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
	st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
	st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
	
	## SECOND TRIANGLE
	st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
	st.add_vertex(Vector3(scaling_factor, 0, scaling_factor));
	st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
	
	st.add_index(0);
	st.add_index(1);
	st.add_index(2);
	st.add_index(3);
	st.add_index(4);
	st.add_index(5);
	
	st.generate_normals()
	
	return st.commit();
	
func _add_tile_bridge(base_tile, scaling_factor=0.75, direction=GridDirection.E):
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	if direction == GridDirection.N:
		## 1st triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
		
		## 2nd triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(1 - scaling_factor, 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(scaling_factor, 0, 0 - (1 - scaling_factor)));
	elif direction == GridDirection.E:
		## 1st triangle
		st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, scaling_factor));
		
		## 2nd triangle
		st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 1 - scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, scaling_factor));
	elif direction == GridDirection.S:
		## 1st triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, 1 + (1 - scaling_factor)));
		
		## 2nd triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, 1 + (1 - scaling_factor)));
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 + (1 - scaling_factor)));
	elif direction == GridDirection.W:
		## 1st triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, scaling_factor));
		
		## 2nd triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 1 - scaling_factor));
		
	st.add_index(0);
	st.add_index(1);
	st.add_index(2);
	st.add_index(3);
	st.add_index(4);
	st.add_index(5);
	st.generate_normals()
	return st.commit(base_tile);

func _build_triangular_connections(tile_mesh, scaling_factor=0.75, direction=GridDirection.NE):
	var st = SurfaceTool.new();
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	if direction == GridDirection.NE:
		## 1st triangle
		st.add_vertex(Vector3(scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 1 + (1 - scaling_factor)));
		
		## 2nd triangle
		st.add_vertex(Vector3(scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 1 + (1 - scaling_factor)));
		st.add_vertex(Vector3(scaling_factor, 0, 1 + (1 - scaling_factor)));
	elif direction == GridDirection.SE:
		## 1st triangle
		st.add_vertex(Vector3(scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(scaling_factor, 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 1 - scaling_factor));
		
		## 2nd triangle
		st.add_vertex(Vector3(scaling_factor, 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(1 + (1 - scaling_factor), 0, 1 - scaling_factor));
	elif direction == GridDirection.SW:
		## 1st triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 + (1 - scaling_factor)));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 1 + (1 - scaling_factor)));
		
		## 2nd triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 1 + (1 - scaling_factor)));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, scaling_factor));
	elif direction == GridDirection.NW:
		## 1st triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 1 - scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 0 - (1 - scaling_factor)));
		
		## 2nd triangle
		st.add_vertex(Vector3(1 - scaling_factor, 0, 1 - scaling_factor));
		st.add_vertex(Vector3(0 - (1 - scaling_factor), 0, 0 - (1 - scaling_factor)));
		st.add_vertex(Vector3(1 - scaling_factor, 0, 0 - (1 - scaling_factor)));

		
	st.add_index(0);
	st.add_index(1);
	st.add_index(2);
	st.add_index(3);
	st.add_index(4);
	st.add_index(5);
	st.generate_normals()
	return st.commit(tile_mesh);

func build_fancy_tile(color, is_edge_tile_bottom, is_edge_tile_right, neighbor_heights):
	## 1. BUILD BASE TILES WITH 0.75 TILES
	var scaling_factor = 0.75
	var base_tile = _build_base_tile()

	## 2. ADD EAST CONNECTION
	if not is_edge_tile_right:
		base_tile = _add_tile_bridge(base_tile, 0.9, GridDirection.E)
	## 3. ADD SOUTH CONNECTION
	if not is_edge_tile_bottom:
		base_tile = _add_tile_bridge(base_tile, 0.9, GridDirection.S)
	## 4. ADD DIAGONAL CONNECTION
	if not (is_edge_tile_bottom or is_edge_tile_right):
		base_tile = _build_triangular_connections(base_tile, 0.9, GridDirection.NE)
	
	## Assign final mesh to node
	mesh = base_tile
	
	mat.albedo_color = Color(color)
	test_mat1.albedo_color = Color(test_col1)
	test_mat2.albedo_color = Color(test_col2)
	set_surface_override_material(0, mat)
	for i in get_surface_override_material_count():
		set_surface_override_material(i, mat)
#	set_surface_override_material(1, test_mat1)
#	set_surface_override_material(2, test_mat2)
	
############################################
## BACKUP STUFF
## FIRST TRIANGLE
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
## SECOND TRIANGLE
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
#	st.set_normal(Vector3(0, 1, 0));
#	st.set_color(color);
	
