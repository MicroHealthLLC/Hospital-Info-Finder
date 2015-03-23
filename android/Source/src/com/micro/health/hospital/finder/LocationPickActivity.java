package com.micro.health.hospital.finder;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import android.app.Activity;
import android.content.Context;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class LocationPickActivity extends Activity implements OnClickListener {
	private static final String TAG = LocationPickActivity.class.getCanonicalName();
	private Button back;
	private ListView locationListView;
	private ArrayList<Address> geoLocList = new ArrayList<Address>();
	private GeoLocAdapter geoLocAdapter;
	
	private String locationName="";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.locationpickup);
		
		Bundle bn = getIntent().getExtras();
		if(bn != null) {
			if(bn.containsKey(HospitalApplication.LOCATIONNAME)) {
				locationName = bn.getString(HospitalApplication.LOCATIONNAME);
			}
		}

		back = (Button) findViewById(R.id.back);
		locationListView = (ListView) findViewById(R.id.loclist);
		
		back.setOnClickListener(this);
		
		Utils.showActivityViewer(LocationPickActivity.this, "", true);
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				performSearch();
			}
		}).start();
	}
	
	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if(msg.what == 0) {
				Utils.hideActivityViewer();
				if(geoLocList.size() > 0) {
					geoLocAdapter = new GeoLocAdapter(LocationPickActivity.this);
					locationListView.setAdapter(geoLocAdapter);
				}
			}
		}
	};
	
	private void performSearch() {
		Geocoder geocoder = new Geocoder(LocationPickActivity.this, Locale.ENGLISH);
		List<Address> addresses;
		try {
			addresses = geocoder.getFromLocationName(locationName, 100);
			if(addresses !=null) {
				if(addresses.size() > 0) {
					for(int i=0;i<addresses.size();i++) {
						if(addresses.get(i).hasLatitude() && addresses.get(i).hasLongitude()) {
							geoLocList.add(addresses.get(i));
						}
					}
				}
			}
			handler.sendEmptyMessage(0);
		} catch (IOException e) {
			Log.v(TAG, e.toString());
			e.printStackTrace();
		}
	}
	
	

	@Override
	protected void onResume() {
		super.onResume();
	}

	public void onClick(View v) {
		if (v.getId() == R.id.back) {
			onBackPressed();
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT) && keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		finish();
	}
	
	public static class ViewHolder{
		TextView title;
		TextView subtitle;
		RelativeLayout rl;
    }
	
	private class GeoLocAdapter extends ArrayAdapter<Address> {
		public GeoLocAdapter(Context context) {
			super(context, R.layout.geolocitems, geoLocList);
		}

		public int getCount() {
			return geoLocList.size();
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View vi=convertView;
	        ViewHolder holder;
	        LayoutInflater inflater = LocationPickActivity.this.getLayoutInflater();
        	vi = inflater.inflate(R.layout.geolocitems, null);
			holder=new ViewHolder();
			vi.setTag(holder);
			
			if(geoLocList.get(position) != null) {
				final Address xx = geoLocList.get(position);
				
				holder.title=(TextView)vi.findViewById(R.id.title);
				holder.subtitle=(TextView)vi.findViewById(R.id.subtitle);
				holder.rl=(RelativeLayout)vi.findViewById(R.id.llmain);
				
				holder.title.setText(xx.getFeatureName() +", " + xx.getAdminArea());
				holder.subtitle.setText(xx.getCountryName());
				
				holder.rl.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
							HospitalApplication.prefs.setCity(xx.getAdminArea());
							try {
								HospitalApplication.prefs.setZipCode(xx.getPostalCode()== null?0:Integer.parseInt(xx.getPostalCode()));
							} catch(NumberFormatException e) {
								Log.e(TAG, e.toString());
							} catch(Exception e) {
								Log.e(TAG, e.toString());	
							}
							
							HospitalApplication.prefs.setLatitude(xx.hasLatitude()?xx.getLatitude():0);
							HospitalApplication.prefs.setLongitude(xx.hasLongitude()?xx.getLongitude():0);
							if(HospitalApplication.prefs.getLatitude() > 0 && HospitalApplication.prefs.getLongitude()>0) {
								HospitalApplication.setCurrentLocation(xx.getLatitude(), xx.getLongitude());
							}						
							HospitalApplication.prefs.setUseCurrentLocation(false);
							finish();
					}
				});
			}
	        return vi;
		}
		
		

	}

	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}
	
	

}
