class_name SoundComponent extends Node

@export var click_sound : AudioStream
@export var hover_sound : AudioStream
var player : AudioStreamPlayer
var target : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	player = get_node("/root/Layout/AudioStreamPlayer")
	connect_signals()

func connect_signals() -> void:
	target.pressed.connect(on_pressed)
	target.mouse_entered.connect(on_hover)

func on_pressed() -> void:
	player.set_stream(click_sound)
	player.play()

func on_hover() -> void:
	player.set_stream(hover_sound)
	player.play()
