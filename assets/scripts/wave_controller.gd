
class_name WaveController extends Node3D

signal wave_started(index: int)

static var inst : WaveController

@export var predefined_waves : Array[Wave]
@export var spawn_radius : float = 22.0
@export var spawn_origin : Node3D = self
@export var nav_region : NavigationRegion3D
@export var timer : Timer

@export var ui_anim_player : AnimationPlayer
@export var time_label : Label

var current_wave : Wave

var wave_index : int = -1
var next_wave : Wave :
	get:
		wave_index += 1
		if wave_index < predefined_waves.size():
			return predefined_waves[wave_index]
		else:
			return Wave.new_from_wave_index(wave_index)

func _ready() -> void:
	inst = self
	timer.timeout.connect(proceed_to_next_wave)
	proceed_to_next_wave()


func _process(delta: float) -> void:
	var minutes := floori(timer.time_left / 60)
	var seconds := floori(fmod(timer.time_left, 60))
	var milliseconds := floori(fmod(timer.time_left, 1) * 10)
	var time_string = "%02d:%02d.%01d" % [minutes, seconds, milliseconds]
	time_label.text = time_string


func proceed_to_next_wave() -> void:
	start_wave(next_wave)


func start_wave(wave: Wave) -> void:
	current_wave = wave

	timer.wait_time = wave.duration
	timer.start()

	for scene in wave.scenes:
		for i in wave.scenes[scene]:
			spawn_scene(scene)

	ui_anim_player.play(&"notify_clock")
	wave_started.emit(wave_index)


func end_wave() -> void:
	## TODO: show/enable bell

	pass


func spawn_scene(scene: PackedScene) -> void:
	var node : Node3D = scene.instantiate()
	get_tree().root.add_child.call_deferred(node)


func check_enemy_group() -> void:
	if get_tree().get_node_count_in_group(&"enemy") > 0: return

	end_wave()
