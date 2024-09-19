extends Timer

@onready var mesh: MeshInstance3D = self.get_parent()
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rotationX: float = 0
var rotationY: float = 90


func _process(_delta: float) -> void:
    if not mesh:
        return
    mesh.rotation_degrees = mesh.rotation_degrees.move_toward(
        Vector3(rotationX, rotationY, 0),
        0.01,
    )


func _ready() -> void:
    rotate()
    self.connect('timeout', rotate)
    self.start()


func rotate() -> void:
    rotationX = rng.randf_range(-10, 10)
    rotationY = rng.randf_range(80, 100)
