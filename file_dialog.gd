extends FileDialog


func _ready() -> void:
    self.connect('dir_selected', get_node('/root/Node3D').set_dir)
