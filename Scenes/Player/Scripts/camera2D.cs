using Godot;

public partial class Camera : Camera2D
{
	[Export] private Node2D _objectToFollow = null;

	public override void _Ready()
	{
	}

	public override void _Process(double delta)
	{
		Position = _objectToFollow.Position;
	}
}
