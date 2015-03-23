package com.micro.health.hospital.finder;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class SettingActivity extends Activity implements OnClickListener {
	private TextView Faq;
	private TextView Copyright;
	private TextView upgread;
	private TextView Feddback;
	
	private Button done;

	// private LinearLayout weight;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.settings);
		
		done = (Button) findViewById(R.id.donebtn);
		Faq = (TextView) findViewById(R.id.faq);
		Copyright = (TextView) findViewById(R.id.copyrigt);
		Feddback = (TextView) findViewById(R.id.feedback);
		upgread = (TextView) findViewById(R.id.upgred);

		Faq.setOnClickListener(this);
		Copyright.setOnClickListener(this);
		Feddback.setOnClickListener(this);
		upgread.setOnClickListener(this);
		done.setOnClickListener(this);

	}

	public void onClick(View v) {
		Intent intent;
		if (v.getId() == R.id.faq) {
			intent = new Intent(SettingActivity.this, FAQActivity.class);
			startActivity(intent);
		} else if (v.getId() == R.id.copyrigt) {
			intent = new Intent(SettingActivity.this, CopyrightActivity.class);
			startActivity(intent);
		} else if (v.getId() == R.id.feedback) {
			Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
			String[] recipients = new String[] { "feedback@microhealthonline.com" };
			emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL,recipients);
			emailIntent.putExtra(android.content.Intent.EXTRA_CC, "");
			emailIntent.putExtra(android.content.Intent.EXTRA_BCC, "tonyinae@mac.com");
			emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,"Feedback for Hospital Finder 1.0");
			emailIntent.setType("text/plain");
			startActivity(Intent.createChooser(emailIntent, "Send mail..."));
		} else if (v.getId() == R.id.upgred) {
			 final Dialog dialog = new Dialog(SettingActivity.this, R.style.CustomDialogTheme);
             dialog.setContentView(R.layout.upgrade);
             dialog.setTitle("");
             dialog.setCancelable(true);
             
             Button notnow = (Button) dialog.findViewById(R.id.notnow);
             notnow.setOnClickListener(new OnClickListener() {
             @Override
                 public void onClick(View v) {
                    dialog.dismiss();
                    dialog.cancel();
                 }
             });
             
             Button upgradeto = (Button) dialog.findViewById(R.id.upgradeto);
             upgradeto.setSelected(true);
             upgradeto.setOnClickListener(new OnClickListener() {
             @Override
                 public void onClick(View v) {
                    //
                 }
             });
             //now that the dialog is set up, it's time to show it    
             dialog.show();
		} else if(v.getId() == R.id.donebtn) {
			onBackPressed();
		}
	}
	
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


}
