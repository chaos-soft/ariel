extends Node3D

var config: ConfigFile = ConfigFile.new()


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed('open_file_dialog'):
        $FileDialog.current_dir = config.get_value('master', 'last_dir', 'res://')
        $FileDialog.show()


func _ready() -> void:
    $FileDialog.connect('dir_selected', set_dir)
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    config.load('user://config.ini')
    var last_dir = config.get_value('master', 'last_dir')
    if not last_dir or not DirAccess.dir_exists_absolute(last_dir):
        $FileDialog.show()
    else:
        $slider.run()


func set_dir(dir: String) -> void:
    config.set_value('master', 'last_dir', dir)
    config.save('user://config.ini')
    await $slider.reset_position_tween()
    $slider.reload_images()
    $slider.restart_tween()
