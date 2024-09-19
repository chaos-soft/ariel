extends Node3D

var config: ConfigFile = ConfigFile.new()


func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_O:
            $FileDialog.current_dir = config.get_value('master', 'last_dir', 'res://')
            $FileDialog.show()


func _ready() -> void:
    config.load('user://config.ini')
    var last_dir = config.get_value('master', 'last_dir')
    if not last_dir or not DirAccess.dir_exists_absolute(last_dir):
        $FileDialog.show()
    else:
        $MeshInstance3D/slider.run()


func set_dir(dir: String) -> void:
    config.set_value('master', 'last_dir', dir)
    config.save('user://config.ini')
    $MeshInstance3D/slider.restart(true)
