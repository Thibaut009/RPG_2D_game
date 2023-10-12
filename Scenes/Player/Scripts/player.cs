using Godot;
using System;

public partial class player : CharacterBody2D
{
	public const float Speed = 100.0f;
	public int stopDirection;

	private AnimationPlayer animations;
	private bool isMoving = false;

	public override void _Ready()
	{
		animations = GetNode<AnimationPlayer>("AnimationPlayer");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;
		Vector2 direction = Input.GetVector("move_left", "move_right", "move_up", "move_down");
		if (direction != Vector2.Zero)
		{
			velocity = direction * Speed;
			isMoving = true;
		}
		else
		{
			velocity = new Vector2(Mathf.MoveToward(Velocity.X, 0, Speed), Mathf.MoveToward(Velocity.Y, 0, Speed));
			isMoving = false;
		}

		Velocity = velocity;
		MoveAndSlide();
		UpdateAnimation();
	}

	private void UpdateAnimation()
	{
		if (isMoving)
		{
			string direction = GetAnimationDirection();
			animations.Play("walk_" + direction);
		}
		else
		{
			switch (this.stopDirection)
			{
				case 1:
					animations.Play("stop_left");
					break;
				case 2:
					animations.Play("stop_right");
					break;
				case 3:
					animations.Play("stop_up");
					break;
				default:
					animations.Play("stop_down");
					break;
			}
		}
	}

	private string GetAnimationDirection()
	{
		if (Input.GetActionStrength("move_left") == 1)
		{
			this.stopDirection = 1;
			return "left";
		}

		if (Input.GetActionStrength("move_right") == 1)
		{
			this.stopDirection = 2;
			return "right";
		}

		if (Input.GetActionStrength("move_up") == 1)
		{
			this.stopDirection = 3;
			return "up";
		}

		if (Input.GetActionStrength("move_down") == 1)
		{
			this.stopDirection = 4;
			return "down";
		}

		// Si aucune touche n'est enfoncée, retournez la direction par défaut
		this.stopDirection = 0;
		return "default";
	}
}
