package com.micro.health.hospital.finder;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

public class LocationSelectActivity extends MapActivity implements OnClickListener {
	private Button back;
	private EditText locationName;
	private ImageButton rectile;
	private MapView mapView;
	private ImageView cancel;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.locationselect);
		
		back = (Button) findViewById(R.id.back);
		locationName = (EditText) findViewById(R.id.loc);
		rectile = (ImageButton) findViewById(R.id.rectile);
		mapView = (MapView) findViewById(R.id.map_location_viewer);
		cancel = (ImageView) findViewById(R.id.searchcancel);
		
		back.setOnClickListener(this);
		rectile.setOnClickListener(this);
		cancel.setOnClickListener(this);
		
		mapView.setBuiltInZoomControls(true);
		
		locationName.addTextChangedListener(searchTextWatcher);
		    
		locationName.setOnEditorActionListener(new TextView.OnEditorActionListener() {
	    	    @Override
	    	    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
	    	        if (actionId == EditorInfo.IME_ACTION_SEARCH) {
	    	        	if(locationName.getText().toString().length() > 0) {
	    	        		Intent intent = new Intent(LocationSelectActivity.this, LocationPickActivity.class);
	    	        		intent.putExtra(HospitalApplication.LOCATIONNAME, locationName.getText().toString());
	    	        		startActivity(intent);
	    	        		finish();
	    	        	}
	    	            return true;
	    	        }
	    	        return false;
	    	    }
	    });
		
		if(HospitalApplication.getCurrentLocation() != null) {
			MyItemizedOverlay itemizedOverlay = new MyItemizedOverlay(getResources().getDrawable(R.drawable.pin), mapView);
			GeoPoint point = new GeoPoint((int)(HospitalApplication.getCurrentLocation().getLatitude()*1E6),(int)(HospitalApplication.getCurrentLocation().getLongitude()*1E6));
			OverlayItem overlayItem = new OverlayItem(point, "",null);
			itemizedOverlay.addOverlay(overlayItem);
			mapView.getOverlays().add(itemizedOverlay);
			mapView.getController().animateTo(point);
		}
				
		locationName.setText(HospitalApplication.prefs.getZipCode() + " (" + HospitalApplication.prefs.getCity() + ")");
	}
	
	public void onClick(View v) {
		if(v.getId() == R.id.back) {
			onBackPressed();
		} else if(v.getId() == R.id.rectile){
			HospitalApplication.prefs.setUseCurrentLocation(true);
			Utils.createCurrentLocation(LocationSelectActivity.this);
			if(HospitalApplication.getCurrentLocation() != null) {
				mapView.getOverlays().clear();
				MyItemizedOverlay itemizedOverlay = new MyItemizedOverlay(getResources().getDrawable(R.drawable.pin), mapView);
				GeoPoint point = new GeoPoint((int)(HospitalApplication.getCurrentLocation().getLatitude()*1E6),(int)(HospitalApplication.getCurrentLocation().getLongitude()*1E6));
				OverlayItem overlayItem = new OverlayItem(point, "",null);
				itemizedOverlay.addOverlay(overlayItem);
				mapView.getOverlays().add(itemizedOverlay);
				mapView.getController().animateTo(point);
			}
			locationName.setText(HospitalApplication.prefs.getCity());
		} else if(v.getId() == R.id.searchcancel){
			locationName.setText("");
		}
	}
	
	
	
	private TextWatcher searchTextWatcher = new TextWatcher() {
		
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if(s.length() > 0) {
				cancel.setVisibility(View.VISIBLE);
			} else {
				cancel.setVisibility(View.GONE);
			}
		}
		
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			
		}
		
		@Override
		public void afterTextChanged(Editable s) {
			
		}
	};

	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT)
				&& keyCode == KeyEvent.KEYCODE_BACK
				&& event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		finish();
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}


}
