extends MeshInstance3D

const rotation_ = preload('res://rotation.gd')
signal image_changed
var extensions = ['.jpg', '.png', 'jpeg', 'webp']
var image_index: int = 0
var images: Array[String] = []
var images_random: Array[String] = []
var path: String = ''
var tween: Tween = null
var tween_delay: float = 30
var tween_timeout: float = 0.6


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed('prev_image'):
        image_index -= 2
    if Input.is_action_just_pressed('prev_image') or Input.is_action_just_pressed('next_image'):
        await reset_position_tween()
        change_image()
        restart_tween()


func _ready():
    rotation_.new(self)


func change_image() -> void:
    if image_index < 0:
        reset_index()
    if image_index == images_random.size():
        randomize_images()
    var file = images_random[image_index]
    if file:
        var image = Image.load_from_file('{0}/{1}'.format([path, file]))
        image.generate_mipmaps()
        var ratio = float(image.get_width()) / image.get_height()
        mesh.size.x = ratio * mesh.size.y
        material_override.albedo_texture = ImageTexture.create_from_image(image)
        image_changed.emit(path, file, image)
    image_index += 1


func kill_tween() -> void:
    if tween:
        tween.kill()


func loop() -> void:
    tween = create_tween().set_trans(Tween.TRANS_QUAD).set_loops()
    tween.tween_property(self, 'position:z', 0, tween_timeout)
    tween.tween_property(self, 'position:z', 30, tween_timeout).set_delay(tween_delay)
    tween.tween_callback(change_image)
    tween.tween_callback(reset_position)


func randomize_images() -> void:
    reset_index()
    images_random = images.duplicate()
    images_random.shuffle()


func reload_images() -> void:
    images = []
    images_random = []
    path = get_node('/root/Node3D').config.get_value('master', 'last_dir')
    var dir = DirAccess.open(path)
    for v in dir.get_files():
        if v.right(4) in extensions:
            images.append(v)
    reset_index()
    change_image()


func reset_index() -> void:
    image_index = 0


func reset_position() -> void:
    position.z = -30


func reset_position_tween() -> void:
    kill_tween()
    tween = create_tween().set_trans(Tween.TRANS_QUAD)
    tween.tween_property(self, 'position:z', -30, tween_timeout)
    await tween.finished


func restart_tween() -> void:
    kill_tween()
    loop()


func run() -> void:
    reload_images()
    loop()
