using Godot;
using System;

public class KinamaticBallRotation : Spatial
{
	KinematicPlayer ballspace;
	
	const double defaultRotSpeedReduce = 3.0;
	const double airRotationStopTime = 750.0; // 0.5s
	const double airRotationResetTime = 750.0;
	
	int count = 0;
	double onGroundTime = 0.0;
	
	public override void _Ready()
	{
		count = 0;
		onGroundTime = 0.0;
	}

	public override void _Process(float delta)
	{
		ballspace = this.GetParent<KinematicPlayer>();

		if(ballspace.IsOnFloor()) {
			onGroundTime = OS.GetSystemTimeMsecs();
			BallRotation(delta);
			ResetRotationFloor();
		} else {
			double currentTime = OS.GetSystemTimeMsecs();
			double jumpedTime = currentTime - onGroundTime;
			if(jumpedTime >= airRotationStopTime) { // x second(s) has passed since player jumps
				if(jumpedTime >= airRotationStopTime + airRotationResetTime) { // Reset Rotation
					ResetRotationAir();
				} else { // Slowly stop first
					double offset = (jumpedTime - airRotationStopTime) / airRotationResetTime;
					BallRotation(delta, (float)(defaultRotSpeedReduce + (offset * 15.0)));
				}
			} else {
				BallRotation(delta);
			}
		}
	}

	void BallRotation(float delta, float rotationSpeedReduce=(float)defaultRotSpeedReduce)
	{
		if(!ballspace.allowControl) return;
		
		var velocity = ballspace.playerVelocity;
		velocity.x /= rotationSpeedReduce; velocity.y /= rotationSpeedReduce; velocity.z /= rotationSpeedReduce;

		Transform t = GlobalTransform;
		Quat newrot= t.basis.Quat();
		if (velocity.Cross(Vector3.Up).Length()>0)
			newrot = new Quat((velocity.Cross(Vector3.Up)).Normalized(), -velocity.Length() * delta) * t.basis.Quat();
		t.basis = new Basis(newrot);
		GlobalTransform = t;
	}
	
	void ResetRotationFloor()
	{
		if(!ballspace.allowControl) return;
		
		double speed = ballspace.absPlayerVelocity.Length();
		Transform t = GlobalTransform;
		
		if(speed <= 0.5 && t.basis.Quat() != Quat.Identity) {
			if(count < 40) {
				var a = t.basis.Quat();
				var b = Basis.Identity.Quat();
				
				var c = a.Slerp(b, 0.05f);
				t.basis = new Basis(c);
			
				GlobalTransform = t;
				count++;
			} else {
				t.basis = new Basis(Quat.Identity);
				GlobalTransform = t;
			}
		}
		
		if(speed >= 2.0) {
			count = 0;
		}
	}
	
	void ResetRotationAir()
	{
		if(!ballspace.allowControl) return;
		
		double currentTime = OS.GetSystemTimeMsecs();
		if(currentTime - onGroundTime < 1000) return;
		
		Transform t = GlobalTransform;
		
		Quat playerQuat = t.basis.Quat();
		Basis defaultBasis = Basis.Identity;
		
		if(playerQuat != defaultBasis.Quat()) {
			//if(count < 10) {
				var a = playerQuat;
				var b = defaultBasis.Quat();
				
				var c = a.Slerp(b, 0.05f);
				t.basis = new Basis(c);
			
				GlobalTransform = t;
				count++;
			//} else {
			//	t.basis = new Basis(Quat.Identity);
			//	GlobalTransform = t;
			//}
		}
	}
}
