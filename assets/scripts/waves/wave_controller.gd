
class_name WaveController extends Node3D

signal wave_started(index: int)
signal any_wave_started
signal stopped_everything

static var inst : WaveController

@export var music_player : AudioStreamPlayer
@export var predefined_waves : Dictionary
@export var spawn_radius : float = 22.0
@export var spawn_origin : Node3D = self
@export var nav_region : NavigationRegion3D
@export var timer : Timer
@export var bell : Bell

@export var ui_anim_player : AnimationPlayer
@export var time_hour_hand : Control
@export var time_minute_hand : Control
@export var time_label : Label

var current_wave : Wave
var is_enemies_cleared : bool
var time_left_at_wave_start : float = 60.0
@export var is_game_over : bool

var music_clip : StringName :
	get: return music_player["parameters/switch_to_clip"]
	set(value):
		if music_player["parameters/switch_to_clip"] == value: return
		music_player["parameters/switch_to_clip"] = value

@export var wave_index : int = -1
var next_wave : Wave :
	get:
		wave_index += 1
		if predefined_waves.has(wave_index):
			return predefined_waves[wave_index]
		else:
			return Wave.new_from_wave_index(wave_index)

var wave_hour : int :
	get: return wave_index % Wave.HOURS_IN_DAY


var random_floor_position : Vector3 :
	get: return spawn_origin.global_position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).limit_length() * spawn_radius


func _ready() -> void:
	inst = self
	if is_game_over: return
	timer.timeout.connect(proceed_to_next_wave)
	proceed_to_next_wave()


func _process(delta: float) -> void:
	if is_game_over: return

	var time := timer.wait_time if timer.is_stopped() else timer.time_left

	if not timer.is_stopped():
		time_label.text = get_time_string(time)
		time_minute_hand.rotation_degrees = -360.0 * time / time_left_at_wave_start


func proceed_to_next_wave() -> void:
	if not bell.try_ring_bell():
		start_wave(next_wave)


func stop_everything() -> void:
	stopped_everything.emit()
	music_clip = &"death"
	timer.stop()
	is_game_over = true


func start_wave(wave: Wave) -> void:
	current_wave = wave

	if wave_index == Wave.Events.WESLEY:
		music_clip = &"silence"
	else:
		match wave_hour:
			Wave.Hour.HIGH_NOON: music_clip = &"high_noon"
			Wave.Hour.MIDNIGHT: music_clip = &"dead_of_night"
			_: music_clip = &"standard"

	ui_anim_player.play(&"notify_clock")
	get_tree().call_group(&"wave_timed", "set_current_hour", wave_index)
	wave_started.emit(wave_index)
	any_wave_started.emit()

	if timer.is_stopped():
		timer.wait_time = wave.duration + (timer.wait_time if Wave.wave_stops_time(wave_hour, 1) else 0.0)
	else:
		timer.wait_time = timer.time_left + wave.duration
		timer.stop()

	if not Wave.wave_stops_time(wave_hour):
		time_label.text += "   +   " + get_time_string(wave.duration)
	time_hour_hand.rotation_degrees = (360.0 * wave_hour / Wave.HOURS_IN_DAY) + 90.0
	time_minute_hand.rotation_degrees = 0.0

	await ui_anim_player.animation_finished
	actually_start_wave()


func actually_start_wave() -> void:
	time_left_at_wave_start = timer.wait_time
	if not Wave.wave_stops_time(wave_hour):
		timer.start()
	for scene_path in current_wave.scenes:
		var scene : PackedScene = load(scene_path)
		for i in current_wave.scenes[scene_path]:
			spawn_scene(scene)
			await get_tree().create_timer(0.25).timeout
	check_enemy_group.call_deferred()

	if wave_index == Wave.Events.WESLEY:
		await get_tree().create_timer(3.0).timeout
		music_clip = &"wesley"


func end_wave() -> void:
	bell.is_enabled = true
	if wave_index == Wave.Events.WESLEY:
		music_clip = &"dead_of_night"
	elif wave_hour == Wave.Hour.HIGH_NOON:
		music_clip = &"dead_of_night"


func spawn_scene(scene: PackedScene) -> void:
	var node : Node3D = scene.instantiate()
	var at := random_floor_position + Vector3.UP * 50.0
	var query := PhysicsRayQueryParameters3D.create(at, at + Vector3.DOWN * 100, 1)
	var spacestate := get_world_3d().direct_space_state
	var hit := spacestate.intersect_ray(query)
	at = hit["position"]
	setup_spawned_node.call_deferred(node, at)


func setup_spawned_node(node: Node3D, at: Vector3) -> void:
	get_tree().root.add_child(node)
	node.global_position = at
	node.global_rotation_degrees.y = randf_range(0, 360)


func check_enemy_group() -> void:
	if not get_tree(): return

	is_enemies_cleared = get_tree().get_node_count_in_group(&"enemy") == 0
	if is_enemies_cleared:
		end_wave()


static func get_time_string(time: float) -> String:
	var minutes := floori(time / 60)
	var seconds := floori(fmod(time, 60))
	var milliseconds := floori(fmod(time, 1) * 10)
	return "%02d:%02d.%01d" % [minutes, seconds, milliseconds]
