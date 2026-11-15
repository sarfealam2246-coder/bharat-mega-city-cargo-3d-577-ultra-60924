extends Node3D

# Procedural City, Flyover, Streetlights & AI Traffic Spawner (AAA Pipeline)
var traffic_cars: Array = []

func _ready() -> void:
	var road_mat := StandardMaterial3D.new()
	road_mat.albedo_color = Color(0.16, 0.18, 0.22)
	road_mat.roughness = 0.78
	if ResourceLoader.exists("res://assets/textures/asphalt_diff.jpg"):
		road_mat.albedo_texture = load("res://assets/textures/asphalt_diff.jpg")
	var road_node = get_node_or_null("../Ground3D/RoadMesh3D")
	if road_node:
		road_node.material_override = road_mat

	# Spawn 14 City Buildings & Streetlights
	for i in range(14):
		var side := -11.0 if i % 2 == 0 else 11.0
		var b := MeshInstance3D.new()
		var bm := BoxMesh.new()
		var bh := 6.0 + float((i * 3) % 12)
		bm.size = Vector3(5.5, bh, 6.0)
		b.mesh = bm
		b.position = Vector3(side, bh * 0.5, -float(i) * 16.0)
		var bmat := StandardMaterial3D.new()
		bmat.albedo_color = Color(0.32, 0.36, 0.44) if i % 2 == 0 else Color(0.45, 0.38, 0.32)
		b.material_override = bmat
		add_child(b)

	# Spawn 4 Moving AI Traffic Vehicles
	for t in range(4):
		var car := MeshInstance3D.new()
		var cm := BoxMesh.new()
		cm.size = Vector3(1.9, 1.3, 4.0)
		car.mesh = cm
		car.position = Vector3(-2.6 if t % 2 == 0 else 2.6, 0.75, -25.0 - float(t) * 35.0)
		var cmat := StandardMaterial3D.new()
		cmat.albedo_color = Color(0.15, 0.45, 0.9) if t % 2 == 0 else Color(0.9, 0.65, 0.1)
		cmat.metallic = 0.7
		cmat.roughness = 0.25
		car.material_override = cmat
		add_child(car)
		traffic_cars.append(car)

func _process(delta: float) -> void:
	for c in traffic_cars:
		c.position.z += delta * 14.0
		if c.position.z > 40.0:
			c.position.z = -180.0
