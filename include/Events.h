#ifndef FallingRooms_Events_H
#define FallingRooms_Events_H

#include <Urho3D/Core/Object.h>

namespace FallingRooms
{
	/// Loads a level
	URHO3D_EVENT(E_LOADLEVEL, LoadLevel)
	{
		URHO3D_PARAM(P_LEVEL, Level); // Urho3D::String
	}
}

#endif //FallingRooms_Events_H