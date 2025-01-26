
class_name CharacterRootMotion extends RootMotionView

@onready var character : CharacterBody3D = self.get_parent()
@onready var anim_mixer : AnimationMixer = self.get_node(animation_path)


var root_velocity_global : Vector3

func _process(delta: float) -> void:
	var root_position := anim_mixer.get_root_motion_position()
	root_velocity_global = Quaternion.from_euler(character.global_rotation) * root_position / delta
	# root_velocity_global = current_rotation * root_position / delta
	# var root_rotation = anim_mixer.get_root_motion_rotation()
	# character.quaternion = character.quaternion * root_rotation


func _physics_process(delta: float) -> void:
	if root_velocity_global:
		character.velocity = root_velocity_global
		character.move_and_slide()

