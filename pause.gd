extends Node

@onready var camera: Camera3D = get_node('/root/Node3D/camera')
@onready var info: Label = get_node('/root/Node3D/MarginContainer/Panel/info')
@onready var slider: MeshInstance3D = get_node('/root/Node3D/slider')


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed('pause'):
        if slider.tween.is_running():
            camera.kill_tween()
            slider.rotation_.kill_tween()
            slider.kill_tween()
            info.show_hide('paused')
            await get_tree().create_timer(info.tween_timeout).timeout
