package com.micro.health.hospital.finder;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class LocationSettingActivity extends Activity implements OnClickListener {
	private Button back;
	private RelativeLayout location;
	private RelativeLayout distance;
	private TextView locationTxt;
	private TextView distanceTxt;

	private EditText distancePrefs;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.locationsettings);

		back = (Button) findViewById(R.id.back);
		locationTxt = (TextView) findViewById(R.id.locationtxt);
		distanceTxt = (TextView) findViewById(R.id.searchdistancetxt);
		location = (RelativeLayout) findViewById(R.id.location);
		distance = (RelativeLayout) findViewById(R.id.distance);

		back.setOnClickListener(this);
		location.setOnClickListener(this);
		distance.setOnClickListener(this);

		distanceTxt.setText(HospitalApplication.prefs.getDistance() + " " + getString(R.string.miles));
		
	}
	
	

	@Override
	protected void onResume() {
		super.onResume();
		if (HospitalApplication.prefs.getZipCode() == 0)
			locationTxt.setText(HospitalApplication.prefs.getCity());
		else
			locationTxt.setText(HospitalApplication.prefs.getZipCode() + "(" + HospitalApplication.prefs.getCity() + ")");
	}

	public void onClick(View v) {
		if (v.getId() == R.id.back) {
			onBackPressed();
		} else if (v.getId() == R.id.location) {
			Intent intent = new Intent(LocationSettingActivity.this, LocationSelectActivity.class);
			startActivity(intent);
		} else if (v.getId() == R.id.distance) {
			callPrefsResultsDialog();
		}
	}

	private void callPrefsResultsDialog() {
		AlertDialog.Builder alert = new AlertDialog.Builder(this);

		alert.setTitle(getString(R.string.app_name));
		alert.setMessage(getString(R.string.changeSettings));

		LayoutInflater inflater = LocationSettingActivity.this.getLayoutInflater();
		final LinearLayout ll = (LinearLayout) inflater.inflate(R.layout.zipcitydistancedialog, null);
		distancePrefs = (EditText) ll.findViewById(R.id.distance);
		distancePrefs.setText(HospitalApplication.prefs.getDistance() + "");
		distancePrefs.setFilters(new InputFilter[] { new InputFilterMinMax("1", "200") });
		alert.setView(ll);

		alert.setPositiveButton("Ok", prefsDialogListener);
		alert.setNegativeButton("Cancel", prefsDialogListener);
		alert.setNeutralButton("Reset", prefsDialogListener);

		alert.show();
	}

	private DialogInterface.OnClickListener prefsDialogListener = new DialogInterface.OnClickListener() {

		@Override
		public void onClick(DialogInterface dialog, int which) {
			if (which == Dialog.BUTTON_POSITIVE) {
				if (distancePrefs.getText().toString().length() > 0) {
					dialog.dismiss();
					dialog.cancel();
					HospitalApplication.prefs.setDistance(Integer.parseInt(distancePrefs.getText().toString()));
					distanceTxt.setText(HospitalApplication.prefs.getDistance()+ " " + getString(R.string.miles));
				} else {
					Utils.alertDialogShow(LocationSettingActivity.this, getString(R.string.app_name),getString(R.string.pleaseenter));
				}
			} else if (which == Dialog.BUTTON_NEUTRAL) {
				dialog.dismiss();
				dialog.cancel();
				HospitalApplication.prefs.setDistance(30);
				distanceTxt.setText(HospitalApplication.prefs.getDistance() + " " + getString(R.string.miles));
			} else {
				dialog.dismiss();
				dialog.cancel();
			}

		}
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT) && keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		Intent intent = new Intent(LocationSettingActivity.this, HospitalFinderActivity.class);
		intent.putExtra(HospitalApplication.FROM, HospitalApplication.LOCATION);
		startActivity(intent);
		finish();
	}

}
