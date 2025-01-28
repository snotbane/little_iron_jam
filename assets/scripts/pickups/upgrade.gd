
class_name Upgrade extends Resource

@export var mesh_material : Material
@export var sprite : Texture2D
@export var signal_name : StringName
@export_file var pickup_scene_path : String
var pickup_scene : PackedScene :
	get: return load(pickup_scene_path)



func activate(node: Node) -> void:
	node.emit_signal(signal_name)
