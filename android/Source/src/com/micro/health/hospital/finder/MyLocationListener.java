package com.micro.health.hospital.finder;

import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;

public class MyLocationListener implements LocationListener
{
	
	
	public MyLocationListener() {
		}

	@Override
	public void onLocationChanged(Location loc)
	{
		
	}

	@Override
	public void onProviderDisabled(String provider)
	{
/**		Toast.makeText(getApplicationContext(),
		"Gps Disabled",
		Toast.LENGTH_SHORT).show();*/
	}

	@Override
	public void onProviderEnabled(String provider)

	{

	/**	Toast.makeText(getApplicationContext(),

		"Gps Enabled",

		Toast.LENGTH_SHORT).show();
		*/

	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras)
	{

	}
}
