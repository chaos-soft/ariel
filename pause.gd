extends Node

@onready var info: Label = get_node('/root/Node3D/MarginContainer/Panel/info')


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed('pause'):
        if not get_tree().paused:
            info.show_hide('paused')
            await get_tree().create_timer(info.tween_timeout).timeout
        get_tree().paused = not get_tree().paused
