package com.micro.health.hospital.finder.prefs;

import com.micro.health.hospital.finder.HospitalApplication;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class AppPreferences {
	
	private static final String APP_SHARED_PREFS = "hospitalfinderprefs"; //  Name of the file -.xml
    private SharedPreferences appSharedPrefs;
    private Editor prefsEditor;
    
    public AppPreferences(Context context)
    {
    	this.appSharedPrefs = context.getSharedPreferences(APP_SHARED_PREFS, Activity.MODE_PRIVATE);
        this.prefsEditor = appSharedPrefs.edit();
    }
    
    public boolean getUseCurrentLocation() {
		return appSharedPrefs.getBoolean(HospitalApplication.USECURRENTLOCATION, true);
	}

	public void setUseCurrentLocation(boolean count) {
		prefsEditor.putBoolean(HospitalApplication.USECURRENTLOCATION, count);
        prefsEditor.commit();
	}
	
    public String getCity() {
		return appSharedPrefs.getString(HospitalApplication.CITY, "");
	}

	public void setCity(String count) {
		prefsEditor.putString(HospitalApplication.CITY, count);
        prefsEditor.commit();
	}
	
	public int getZipCode() {
		return appSharedPrefs.getInt(HospitalApplication.ZIPCODE, 0);
	}

	public void setZipCode(int zipcode) {
		prefsEditor.putInt(HospitalApplication.ZIPCODE, zipcode);
        prefsEditor.commit();
	}
	
	public int getDistance() {
		return appSharedPrefs.getInt(HospitalApplication.DISTANCE, 30);
	}

	public void setDistance(int distance) {
		prefsEditor.putInt(HospitalApplication.DISTANCE, distance);
        prefsEditor.commit();
	}
	
	public double getLatitude() {
		return appSharedPrefs.getString(HospitalApplication.LATITUDE, "").equals("")?0:Double.parseDouble(appSharedPrefs.getString(HospitalApplication.LATITUDE, ""));
	}

	public void setLatitude(double zipcode) {
		prefsEditor.putString(HospitalApplication.LATITUDE, zipcode+"");
		prefsEditor.commit();
	}
	
	public double getLongitude() {
		return appSharedPrefs.getString(HospitalApplication.LONGITUDE, "").equals("")?0:Double.parseDouble(appSharedPrefs.getString(HospitalApplication.LONGITUDE, ""));
	}

	public void setLongitude(double zipcode) {
		prefsEditor.putString(HospitalApplication.LONGITUDE, zipcode+"");
        prefsEditor.commit();
	}

}
