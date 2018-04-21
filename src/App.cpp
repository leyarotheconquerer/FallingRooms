#include "App.h"
#include <Urho3D/Engine/EngineDefs.h>
#include <Urho3D/LuaScript/LuaScript.h>
#include <Urho3D/Input/InputEvents.h>
#include <Urho3D/IO/Log.h>

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
	SharedPtr<LuaScript> luaScript (new LuaScript(context_));
	context_->RegisterSubsystem(luaScript);
	if (luaScript->ExecuteFile("LuaScripts/Main.lua"))
	{
		luaScript->ExecuteFunction("Start");
	}
	else
	{
		ErrorExit("Unable to start Main.lua");
	}
}

void App::Stop()
{
	LuaScript* luaScript = context_->GetSubsystem<LuaScript>();
	if (luaScript && luaScript->GetFunction("Stop", true))
	{
		luaScript->ExecuteFunction("Stop");
	}
}