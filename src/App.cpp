#include "App.h"
#include <Urho3D/Engine/EngineDefs.h>

using namespace FallingRooms;
using namespace Urho3D;

URHO3D_DEFINE_APPLICATION_MAIN(App);

App::App(Urho3D::Context* context) :
	Urho3D::Application(context),
	context_(context)
{
}

void App::Setup()
{
	engineParameters_[EP_FULL_SCREEN] = false;
	engineParameters_[EP_LOG_NAME] = "FallingRooms.log";
}

void App::Start()
{
}

void App::Stop()
{
}

void App::HandleScriptReloadStarted(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData)
{
}

void App::HandleScriptReloadFinished(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData)
{
}

void App::HandleScriptReloadFailed(Urho3D::StringHash eventType, Urho3D::VariantMap& eventData)
{
}

void App::HandleUpdate(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
}