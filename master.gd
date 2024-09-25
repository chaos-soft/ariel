extends Node3D

var config: ConfigFile = ConfigFile.new()


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed('open_file_dialog'):
        $FileDialog.current_dir = config.get_value('master', 'last_dir', 'res://')
        $FileDialog.show()


func _ready() -> void:
    config.load('user://config.ini')
    var last_dir = config.get_value('master', 'last_dir')
    if not last_dir or not DirAccess.dir_exists_absolute(last_dir):
        $FileDialog.show()
    else:
        $MeshInstance3D.run()


func set_dir(dir: String) -> void:
    config.set_value('master', 'last_dir', dir)
    config.save('user://config.ini')
    $MeshInstance3D.reset_position_tween()
    await get_tree().create_timer($MeshInstance3D.timeout_tween).timeout
    $MeshInstance3D.reload_images()
    $MeshInstance3D.restart_tween()
