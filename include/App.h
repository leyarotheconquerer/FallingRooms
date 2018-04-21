#ifndef FallingRooms_App_H
#define FallingRooms_App_H

#include <Urho3D/Engine/Application.h>

namespace Urho3D
{
	class Context;
}

namespace FallingRooms
{
	class App : public Urho3D::Application
	{
		URHO3D_OBJECT(App, Urho3D::Application);

	public:
		App(Urho3D::Context* context);
		virtual ~App() {}

		virtual void Setup() override;
		virtual void Start() override;
		virtual void Stop() override;

	private:
		void HandleScriptReloadStarted(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData);
		void HandleScriptReloadFinished(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData);
		void HandleScriptReloadFailed(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData);
		void HandleUpdate(Urho3D::StringHash type, Urho3D::VariantMap& data);

		Urho3D::Context* context_;
	};
}

#endif //FallingRooms_App_H