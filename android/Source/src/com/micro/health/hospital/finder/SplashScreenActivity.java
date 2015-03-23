package com.micro.health.hospital.finder;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.micro.health.hospital.finder.database.HospitalFinderDBAdapter;


public class SplashScreenActivity extends Activity {
	private static final String TAG = SplashScreenActivity.class.getCanonicalName();
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);
		
		new Thread(new Runnable() {

			@Override
			public void run() {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					Log.v(TAG,  e.toString());
					e.printStackTrace();
				}
				HospitalFinderDBAdapter myDbHelper = new HospitalFinderDBAdapter(SplashScreenActivity.this); //in my case contextObject is a Map
				myDbHelper.open();
				myDbHelper.close();
				handler.sendEmptyMessage(0);
			}
		}).start();
	}
	
	private Handler handler = new Handler()
	{

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				Utils.createCurrentLocation(SplashScreenActivity.this);
				Intent intent = new Intent(SplashScreenActivity.this, HospitalFinderActivity.class);
				startActivity(intent);
				finish();
			}
				
		}
		
	};
}
