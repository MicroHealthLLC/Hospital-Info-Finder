package com.micro.health.hospital.finder;

import java.util.ArrayList;

import android.app.Application;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;

import com.micro.health.hospital.finder.prefs.AppPreferences;

public class HospitalApplication extends Application{

	//XML Parsers
	public static final int COMPLETE = 1;
	
	//Return messages
	public static final int SUCCESS = 1;
	public static final int FAIL = 2;
	
	public static final String FROM = "from";
	public static final String ID = "id";
	
	public static final String NEARBY = "nearby";
	public static final String MAP = "map";
	public static final String RATING = "rating";
	public static final String LOCATION = "location";
	
	public static final String SEARCHTEXT = "searchtext";
	public static final String CURRENTLOCATION = "Current Location";
	public static final String LATITUDE = "latitude";
	public static final String LONGITUDE = "longitude";
	public static final String USECURRENTLOCATION = "usecurrentlocation";
	public static final String LOCATIONNAME = "locationname";

	public static final String GEOLOCS = "geolocs";
	
	public final static double MILESTOM = 1609.344;
	
	public final static int RATINGCOMPARE = 1;
	public final static int DISTANCECOMPARE = 2;
	
	public static LocationManager mlocManager;
	public static LocationListener mloclistener;
	
	public static int currentCompare = 1;
	
	private static ArrayList<String> historySearchList = new ArrayList<String>();
	public static AppPreferences prefs;
	
	//Preferences
	public static final String CITY = "city";
	public static final String DISTANCE = "distance";
	public static final String ZIPCODE = "zipcode";
	
	private static Location currentLocation;
	
	@Override
	public void onCreate() {
		super.onCreate();
		historySearchList.add(CURRENTLOCATION);
		prefs = new AppPreferences(getApplicationContext());
	}

	public static ArrayList<String> getHistorySearchList() {
		return historySearchList;
	}

	public static void setHistorySearchList(ArrayList<String> historySearchList) {
		HospitalApplication.historySearchList = historySearchList;
	}

	public static Location getCurrentLocation() {
		if(prefs.getLatitude() != 0 && prefs.getLongitude() != 0){
			currentLocation = new Location(LocationManager.NETWORK_PROVIDER);
			currentLocation.setLatitude(prefs.getLatitude());
			currentLocation.setLongitude(prefs.getLongitude());
			return currentLocation;
		} else {
			return null;
		}
		
	}

	public static void setCurrentLocation(double latitude, double longitude) {
		Location currentLocation1 = new Location(LocationManager.NETWORK_PROVIDER);
		currentLocation1.setLatitude(latitude);
		currentLocation1.setLongitude(longitude);
		currentLocation = new Location(currentLocation1);
		prefs.setLatitude(latitude);
		prefs.setLongitude(longitude);
	}

	@Override
	public void onTerminate() {
		super.onTerminate();
		Utils.removeMLocUpdates();
	}
	
	
	
	

	
	
}
