extends Camera3D

@onready var label: Label = get_node('/root/Node3D/MarginContainer/Panel/info')
var positionX: int = 7
var positionY: int = 0
var positionZ: int = 0
var position_: Vector3 = Vector3(positionX, positionY, positionZ)


func _input(_event: InputEvent) -> void:
    if Input.is_action_pressed('zoom_in'):
        position_.x -= 1
    elif Input.is_action_pressed('zoom_out'):
        position_.x += 1
    elif Input.is_action_just_pressed('reset_camera'):
        position_.x = positionX
        position_.y = positionY
        position_.z = positionZ
    elif Input.is_action_pressed('up'):
        position_.y += 0.5
    elif Input.is_action_pressed('down'):
        position_.y -= 0.5
    elif Input.is_action_pressed('left'):
        position_.z += 0.5
    elif Input.is_action_pressed('right'):
        position_.z -= 0.5
    if position != position_:
        label.show_hide('{0}'.format([position_]))


func _process(delta: float) -> void:
    position = position.move_toward(position_, 10 * delta)
