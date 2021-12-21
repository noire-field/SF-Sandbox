extends Spatial


var dissolving := false
var dis_per = 0;
onready var mat = get_node("Sphere_mesh").get_surface_material(0)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		dissolving = true
	
	if dissolving:
		mat.set_shader_param("dissolve", dis_per)
		dis_per += delta
		if dis_per > 1.0:
			dissolving = false
