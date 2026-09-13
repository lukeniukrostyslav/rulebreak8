extends "res://scripts/game.gd"

# Keep the original game controller stable while switching the runtime to the
# expanded challenge renderer. This makes the migration reversible and small.
func _ready() -> void:
    challenge_view = ChallengeViewV2.new()
    super._ready()
