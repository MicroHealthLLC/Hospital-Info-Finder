/*
Contributed by Tim Huynh Le, for MicroHealth, LLC.,
under the GN Affero General Public License 3.0
*/

package com.micro.health.hospital.finder;

import android.app.Activity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;



public class CopyrightActivity extends Activity implements OnClickListener {
	private Button setting;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.copyright);
        
        setting = (Button) findViewById(R.id.faqsettingbtn);
        setting.setOnClickListener(this);
	
   
   }
    public void onClick(View v) {
    	if (v.getId() == R.id.faqsettingbtn) {
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
