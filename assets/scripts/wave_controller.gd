
class_name WaveController extends Node3D

signal wave_started(index: int)

static var inst : WaveController

@export var predefined_waves : Array[Wave]
@export var spawn_radius : float = 22.0
@export var spawn_origin : Node3D = self
@export var nav_region : NavigationRegion3D
@export var timer : Timer
@export var bell : Bell

@export var ui_anim_player : AnimationPlayer
@export var time_label : Label

var current_wave : Wave
var is_enemies_cleared : bool

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
	var time := timer.wait_time if timer.is_stopped() else timer.time_left
	var minutes := floori(time / 60)
	var seconds := floori(fmod(time, 60))
	var milliseconds := floori(fmod(time, 1) * 10)
	var time_string = "%02d:%02d.%01d" % [minutes, seconds, milliseconds]
	time_label.text = time_string


func proceed_to_next_wave() -> void:
	if not bell.try_ring_bell():
		start_wave(next_wave)


func start_wave(wave: Wave) -> void:
	current_wave = wave

	ui_anim_player.play(&"notify_clock")
	get_tree().call_group(&"wave_timed", "set_current_hour", wave_index)
	# wave_started.emit(wave_index)

	if timer.is_stopped():
		timer.wait_time = wave.duration
	else:
		timer.wait_time = timer.time_left + wave.duration
		timer.stop()
	await ui_anim_player.animation_finished
	actually_start_wave()


func actually_start_wave() -> void:
	timer.start()
	for scene in current_wave.scenes:
		for i in current_wave.scenes[scene]:
			spawn_scene(scene)
	check_enemy_group.call_deferred()


func end_wave() -> void:
	bell.is_enabled = true


func spawn_scene(scene: PackedScene) -> void:
	var node : Node3D = scene.instantiate()
	setup_spawned_node.call_deferred(node)


func setup_spawned_node(node: Node3D) -> void:
	get_tree().root.add_child(node)
	node.global_position = spawn_origin.global_position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).limit_length() * spawn_radius



func check_enemy_group() -> void:
	if not get_tree(): return

	is_enemies_cleared = get_tree().get_node_count_in_group(&"enemy") == 0
	if is_enemies_cleared:
		end_wave()
