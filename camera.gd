extends Camera3D

@onready var label: Label = get_node('/root/Node3D/MarginContainer/Panel/info')
var positionX: int = 8
var positionY: int = 0
var positionZ: int = 0
var position_: Vector3 = Vector3(positionX, positionY, positionZ)


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            position_.x += 1
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            position_.x -= 1
    elif event is InputEventKey and event.pressed:
        if event.keycode == KEY_R:
            position_.x = positionX
            position_.y = positionY
            position_.z = positionZ
        elif event.keycode == KEY_UP:
            position_.y += 0.5
        elif event.keycode == KEY_DOWN:
            position_.y -= 0.5
        elif event.keycode == KEY_LEFT:
            position_.z += 0.5
        elif event.keycode == KEY_RIGHT:
            position_.z -= 0.5
    if self.position != position_:
        label.show_hide('{0}'.format([position_]))


func _process(_delta: float) -> void:
    self.position = self.position.move_toward(position_, 0.2)
