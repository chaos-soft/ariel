extends Camera3D

@onready var info: Label = get_node('/root/Node3D/MarginContainer/Panel/info')
@onready var slider: MeshInstance3D = get_node('/root/Node3D/MeshInstance3D')
var config: Dictionary = {}
var position_: Vector3 = Vector3(positionX, positionY, positionZ)
var positionX: int = 7
var positionY: int = 0
var positionZ: int = 0
var tween: Tween = null
var tween_timeout: float = 0.6


func _input(_event: InputEvent) -> void:
    if tween and tween.is_running():
        return
    if Input.is_action_pressed('zoom_in'):
        position_.x -= 1
    elif Input.is_action_pressed('zoom_out'):
        position_.x += 1
    elif Input.is_action_just_pressed('reset_camera'):
        position_ = Vector3(positionX, positionY, positionZ)
    elif Input.is_action_pressed('up'):
        position_.y += 0.5
    elif Input.is_action_pressed('down'):
        position_.y -= 0.5
    elif Input.is_action_pressed('left'):
        position_.z += 0.5
    elif Input.is_action_pressed('right'):
        position_.z -= 0.5
    if position != position_:
        info.show_hide('{0}'.format([position_]))


func _process(delta: float) -> void:
    if tween and tween.is_running():
        position = position_
    else:
        position = position.move_toward(position_, 10 * delta)


func _ready() -> void:
    slider.image_changed.connect(on_image_changed)


func kill_tween() -> void:
    if tween:
        tween.kill()


func on_image_changed(path: String, file: String, _image: Image) -> void:
    kill_tween()
    await reset_position(Vector3(positionX, positionY, positionZ))
    parse_config(path)
    if file in config:
        var c = config[file]
        if 'position' in c:
            await reset_position(Vector3(c['position'][0], c['position'][1], c['position'][2]))
        if 'tween' in c:
            tween = create_tween()
            tween.tween_property(
                self,
                c['tween'][0],
                Vector3(c['tween'][1][0], c['tween'][1][1], c['tween'][1][2]),
                slider.tween_delay,
            )


func parse_config(path: String) -> void:
    if not config:
        var file = FileAccess.open('{0}/config.json'.format([path]), FileAccess.READ)
        var content = file.get_as_text()
        config = JSON.parse_string(content)


func reset_position(value: Vector3) -> void:
    position_ = value
    tween = create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(self, 'position', value, tween_timeout)
    # TODO: Почему не работает: await tween.finished?
    await get_tree().create_timer(tween_timeout).timeout
