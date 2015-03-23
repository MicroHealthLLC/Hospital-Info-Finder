package com.micro.health.hospital.finder;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.util.Log;


public class Utils {
	private static ActivityIndicator activityIndicator;
	private static final String TAG = Utils.class.getCanonicalName();
	public static void hideActivityViewer() {
		if (activityIndicator != null) {
			activityIndicator.dismiss();
		}
	}

	public static void showActivityViewer(Context context, String str, boolean inverse) {
		if (activityIndicator == null) {
			activityIndicator = new ActivityIndicator(context, str, inverse);
		}
		activityIndicator.show();
	} 
	
	 public static void clearDialogs()
	 {
		 activityIndicator = null;
	 }
	 
	 public static void alertDialogShow(Context context, String title, String message)
	    {
	    	final AlertDialog alertDialog = new AlertDialog.Builder(context).create();
	    	alertDialog.setTitle(title);
	        alertDialog.setMessage(message);
	        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
	        	public void onClick(DialogInterface dialog, int which) {
	        		alertDialog.cancel();
	          } }); 
	        alertDialog.show();
	    }
	 
	 public static void createCurrentLocation(Context context) {
		 if(HospitalApplication.prefs.getUseCurrentLocation()) {
			 	HospitalApplication.mlocManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
			 	HospitalApplication.mloclistener = new MyLocationListener();
				HospitalApplication.mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, HospitalApplication.mloclistener);
				HospitalApplication.mlocManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, HospitalApplication.mloclistener);
				Location tempL = HospitalApplication.mlocManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
				if(tempL != null) {
					HospitalApplication.setCurrentLocation(tempL.getLatitude(), tempL.getLongitude());
				} else {
					Location tempT = HospitalApplication.mlocManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
					if(tempT != null) {
						HospitalApplication.setCurrentLocation(tempT.getLatitude(), tempT.getLongitude());
					}
				}
				
				if(HospitalApplication.getCurrentLocation() != null) {
					Geocoder geocoder = new Geocoder(context, Locale.ENGLISH);
					List<Address> addresses;
					try {
						addresses = geocoder.getFromLocation(HospitalApplication.getCurrentLocation().getLatitude(), HospitalApplication.getCurrentLocation().getLongitude(), 1);
						if(addresses !=null) {
							if(addresses.size() > 0) {
								Address t = addresses.get(0);
								HospitalApplication.prefs.setCity(t.getLocality());
								HospitalApplication.prefs.setZipCode(t.getPostalCode() ==  null?0:Integer.parseInt(t.getPostalCode()));
							}
						}
					} catch (IOException e) {
						Log.v(TAG, e.toString());
						e.printStackTrace();
					}
				}
	     } else {
			HospitalApplication.setCurrentLocation(HospitalApplication.prefs.getLatitude(), HospitalApplication.prefs.getLongitude());
	     }
	 }
	 
	 
	 public static void removeMLocUpdates() {
		 if(HospitalApplication.mlocManager != null) {
			 HospitalApplication.mlocManager.removeUpdates(HospitalApplication.mloclistener);
			 HospitalApplication.mlocManager = null;
		 }
	 }
}
