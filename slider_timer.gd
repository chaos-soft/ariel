extends Timer

@onready var mesh: MeshInstance3D = self.get_parent()
var extensions = ['.jpg', '.png', 'jpeg']
var images: Array[String] = []
var images_random: Array[String] = []
var is_move: bool = true
var path: String = ''
var positionZ: int = -30


func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_PAGEDOWN:
            restart()


func _process(_delta: float) -> void:
    if not mesh:
        return
    if is_move:
        mesh.position = mesh.position.move_toward(Vector3(0, 0, positionZ), 1)
        if mesh.position.z == 30:
            change_image()
            reset_position(false)
    else:
        mesh.position.z = positionZ


func _ready() -> void:
    self.connect('timeout', loop)


func change_image() -> void:
    if images_random.size() == 0:
        get_images_random()
    var file = images_random.pop_front()
    if file:
        var image = Image.load_from_file('{0}/{1}'.format([path, file]))
        image.generate_mipmaps()
        var ratio = float(image.get_width()) / image.get_height()
        mesh.mesh.size.x = ratio * mesh.mesh.size.y
        mesh.material_override.albedo_texture = ImageTexture.create_from_image(image)


func get_images_random() -> void:
    images_random = images.duplicate()
    images_random.shuffle()


func loop() -> void:
    is_move = true
    positionZ = 0
    var i = 1
    while i <= 27:
        if self.is_stopped():
            return
        await get_tree().create_timer(1).timeout
        i += 1
    positionZ = 30


func reset_position(is_move_: bool = true) -> void:
    is_move = is_move_
    positionZ = -30


func restart(is_reset_images: bool = false) -> void:
    reset_position()
    # Для выключения loop().
    self.stop()
    await get_tree().create_timer(3).timeout
    if is_reset_images:
        images = []
        images_random = []
    self.run()


func run() -> void:
    path = get_node('/root/Node3D').config.get_value('master', 'last_dir')
    var dir = DirAccess.open(path)
    for v in dir.get_files():
        if v.right(4) in extensions:
            images.append(v)
    change_image()
    self.start()
    loop()
