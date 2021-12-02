using Godot;
using System;

public class SandboxKinematicBallRotation : Spatial
{
	public override void _Ready()
	{
		
	}

	public override void _Process(float delta)
	{
		base._Process(delta);
		BallRotation(delta);
	}

	void BallRotation(float delta)
	{
		SandboxKinematicPlayer ballspace = this.GetParent<SandboxKinematicPlayer>();
		if(!ballspace.allowControl) return;
		
		Vector3 velocity = ballspace.playerVelocity;
		velocity.x /= 2; velocity.y /= 2; velocity.z /= 2;
		
		Transform t = GlobalTransform;
		Quat newrot= t.basis.Quat();
		if (velocity.Cross(Vector3.Up).Length()>0)
			newrot = new Quat((velocity.Cross(Vector3.Up)).Normalized(), -velocity.Length() * delta) * t.basis.Quat();
		t.basis = new Basis(newrot);
		GlobalTransform = t;
	}
}
