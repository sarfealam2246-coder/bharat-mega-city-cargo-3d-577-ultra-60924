extends VehicleBody3D

# Spec: GM-01 (Indian Cargo Truck) | Driver: CHR-01 | World: ENV-01 | Audio: SFX-01/HRN-01 | Tier: 50 MB Pro (Full PBR Textures & Sound Bank)
@export var max_steer := 0.48
@export var engine_power := 360.0
var steer_input := 0.0
var gas_input := 0.0
var reverse_gear := false
var lights_on := true

func _ready() -> void:
	if ResourceLoader.exists("res://assets/models/vehicle.glb"):
		var glb = load("res://assets/models/vehicle.glb")
		if glb:
			var inst = glb.instantiate()
			add_child(inst)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("#dc2626")
	mat.metallic = 0.78
	mat.roughness = 0.22
	var body_mesh = get_node_or_null("ChassisMesh")
	if body_mesh:
		body_mesh.material_override = mat

func _physics_process(delta: float) -> void:
	var h = Input.get_axis("ui_right", "ui_left")
	var v = Input.get_axis("ui_down", "ui_up")
	steering = move_toward(steering, (h + steer_input) * max_steer, delta * 3.4)
	var dir = -1.0 if reverse_gear else 1.0
	engine_force = (v + gas_input) * engine_power * dir
	var hud = get_node_or_null("../TouchHUD/SpeedLabel")
	if hud:
		hud.text = str(int(linear_velocity.length() * 3.6)) + " km/h | GM-01"
